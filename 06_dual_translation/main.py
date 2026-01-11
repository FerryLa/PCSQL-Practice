"""
단축키 기반 번역기 메인 애플리케이션

Features:
- 전역 단축키로 클립보드 텍스트 자동 번역
- 시스템 트레이 아이콘으로 상시 실행
- DeepL / Papago 엔진 실시간 전환
- 번역 결과 자동 클립보드 복사

Dependencies:
    pip install keyboard pyperclip pystray Pillow

Usage:
    python main.py           # GUI 모드 실행
    python main.py --setup   # API 설정
    python main.py --cli     # CLI 모드 테스트
"""

"""
단축키 기반 번역기 메인 애플리케이션
...
"""

import sys
import os
import time
import threading
from typing import Optional
import argparse

# 현재 파일의 디렉토리를 모듈 검색 경로에 추가
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    import keyboard
    import pyperclip
except ImportError as e:
    print(f"필수 패키지가 설치되지 않았습니다: {e}")
    print("설치: pip install keyboard pyperclip pystray Pillow")
    sys.exit(1)

from config import ConfigManager, APIConfig
from translator import DualTranslator, TranslatorEngine, TranslationResult


class HotkeyTranslator:
    """
    단축키 기반 번역기
    
    기본 단축키:
    - Ctrl+Shift+T: 클립보드 텍스트 번역
    - Ctrl+Shift+S: 언어 방향 전환 (KO↔EN)
    - Ctrl+Shift+E: 번역 엔진 전환 (DeepL↔Papago)
    - Ctrl+Shift+C: 마지막 번역 결과 복사
    - Ctrl+Shift+B: 양쪽 엔진 비교 번역
    """
    
    # 지원 언어 순환 목록
    LANGUAGE_CYCLE = ["KO", "EN", "JA", "ZH"]
    
    def __init__(self, config: APIConfig):
        self.config = config
        self.translator = DualTranslator(config)
        
        self._source_lang = "auto"
        self._target_lang = config.default_target_lang
        self._last_result: Optional[TranslationResult] = None
        self._running = False
        
        # 콜백 함수 (GUI 연동용)
        self.on_translation_complete = None
        self.on_engine_changed = None
        self.on_language_changed = None
        self.on_error = None
    
    @property
    def current_engine(self) -> str:
        return self.translator.current_engine.value
    
    @property
    def language_pair(self) -> str:
        return f"{self._source_lang} → {self._target_lang}"
    
    def _notify(self, message: str, title: str = "번역기"):
        """알림 출력 (콘솔 또는 GUI)"""
        print(f"[{title}] {message}")
    
    def translate_clipboard(self) -> Optional[TranslationResult]:
        """클립보드 텍스트 번역"""
        try:
            text = pyperclip.paste()
            
            if not text or not text.strip():
                self._notify("클립보드가 비어있습니다.", "알림")
                return None
            
            # 번역 실행
            result = self.translator.translate(
                text=text.strip(),
                target_lang=self._target_lang,
                source_lang=self._source_lang,
                use_fallback=True
            )
            
            self._last_result = result
            
            if result.success:
                # 결과를 클립보드에 복사
                pyperclip.copy(result.translated_text)
                
                engine_emoji = "🔵" if result.engine == TranslatorEngine.DEEPL else "🟢"
                self._notify(
                    f"{engine_emoji} [{result.source_lang}→{result.target_lang}]\n"
                    f"원문: {text[:50]}{'...' if len(text) > 50 else ''}\n"
                    f"번역: {result.translated_text[:100]}{'...' if len(result.translated_text) > 100 else ''}"
                )
                
                if self.on_translation_complete:
                    self.on_translation_complete(result)
            else:
                self._notify(f"번역 실패: {result.error_message}", "오류")
                if self.on_error:
                    self.on_error(result.error_message)
            
            return result
            
        except Exception as e:
            error_msg = f"번역 중 오류 발생: {str(e)}"
            self._notify(error_msg, "오류")
            if self.on_error:
                self.on_error(error_msg)
            return None
    
    def compare_translations(self) -> None:
        """양쪽 엔진으로 비교 번역"""
        try:
            text = pyperclip.paste()
            
            if not text or not text.strip():
                self._notify("클립보드가 비어있습니다.", "알림")
                return
            
            deepl_result, papago_result = self.translator.translate_both(
                text=text.strip(),
                target_lang=self._target_lang,
                source_lang=self._source_lang
            )
            
            print("\n" + "="*60)
            print(f"📝 원문: {text[:100]}{'...' if len(text) > 100 else ''}")
            print("="*60)
            
            # DeepL 결과
            if deepl_result.success:
                print(f"🔵 DeepL: {deepl_result.translated_text}")
            else:
                print(f"🔵 DeepL: ❌ {deepl_result.error_message}")
            
            # Papago 결과
            if papago_result.success:
                print(f"🟢 Papago: {papago_result.translated_text}")
            else:
                print(f"🟢 Papago: ❌ {papago_result.error_message}")
            
            print("="*60 + "\n")
            
        except Exception as e:
            self._notify(f"비교 번역 오류: {str(e)}", "오류")
    
    def swap_languages(self) -> None:
        """언어 방향 전환"""
        if self._source_lang == "auto":
            # auto → KO, EN → KO 또는 KO → EN
            if self._target_lang == "KO":
                self._source_lang = "KO"
                self._target_lang = "EN"
            else:
                self._source_lang = self._target_lang
                self._target_lang = "KO"
        else:
            # 단순 스왑
            self._source_lang, self._target_lang = self._target_lang, self._source_lang
        
        self._notify(f"언어 방향: {self.language_pair}")
        
        if self.on_language_changed:
            self.on_language_changed(self._source_lang, self._target_lang)
    
    def cycle_target_language(self) -> None:
        """대상 언어 순환"""
        try:
            current_idx = self.LANGUAGE_CYCLE.index(self._target_lang)
            next_idx = (current_idx + 1) % len(self.LANGUAGE_CYCLE)
            self._target_lang = self.LANGUAGE_CYCLE[next_idx]
        except ValueError:
            self._target_lang = self.LANGUAGE_CYCLE[0]
        
        self._notify(f"대상 언어: {self._target_lang}")
        
        if self.on_language_changed:
            self.on_language_changed(self._source_lang, self._target_lang)
    
    def switch_engine(self) -> None:
        """번역 엔진 전환"""
        new_engine = self.translator.switch_engine()
        emoji = "🔵" if new_engine == TranslatorEngine.DEEPL else "🟢"
        self._notify(f"{emoji} 번역 엔진: {new_engine.value.upper()}")
        
        if self.on_engine_changed:
            self.on_engine_changed(new_engine)
    
    def copy_last_result(self) -> None:
        """마지막 번역 결과 복사"""
        if self._last_result and self._last_result.success:
            pyperclip.copy(self._last_result.translated_text)
            self._notify("번역 결과가 클립보드에 복사되었습니다.")
        else:
            self._notify("복사할 번역 결과가 없습니다.", "알림")
    
    def register_hotkeys(self) -> None:
        """전역 단축키 등록"""
        # 번역 실행
        keyboard.add_hotkey(
            self.config.hotkey_translate,
            self.translate_clipboard,
            suppress=True
        )
        
        # 언어 방향 전환
        keyboard.add_hotkey(
            self.config.hotkey_swap_lang,
            self.swap_languages,
            suppress=True
        )
        
        # 엔진 전환
        keyboard.add_hotkey(
            self.config.hotkey_switch_engine,
            self.switch_engine,
            suppress=True
        )
        
        # 결과 복사
        keyboard.add_hotkey(
            self.config.hotkey_copy_result,
            self.copy_last_result,
            suppress=True
        )
        
        # 비교 번역 (Ctrl+Shift+B)
        keyboard.add_hotkey(
            "ctrl+shift+b",
            self.compare_translations,
            suppress=True
        )
        
        # 대상 언어 순환 (Ctrl+Shift+L)
        keyboard.add_hotkey(
            "ctrl+shift+l",
            self.cycle_target_language,
            suppress=True
        )
    
    def unregister_hotkeys(self) -> None:
        """단축키 해제"""
        keyboard.unhook_all_hotkeys()
    
    def start(self) -> None:
        """번역기 시작"""
        self._running = True
        self.register_hotkeys()
        
        print("\n" + "="*60)
        print("🌐 단축키 번역기 실행 중")
        print("="*60)
        print(f"현재 엔진: {self.current_engine.upper()}")
        print(f"언어 방향: {self.language_pair}")
        print("-"*60)
        print("단축키:")
        print(f"  {self.config.hotkey_translate:<20} 번역 실행")
        print(f"  {self.config.hotkey_swap_lang:<20} 언어 방향 전환")
        print(f"  {self.config.hotkey_switch_engine:<20} 엔진 전환")
        print(f"  {'ctrl+shift+b':<20} 비교 번역")
        print(f"  {'ctrl+shift+l':<20} 대상 언어 순환")
        print(f"  {self.config.hotkey_copy_result:<20} 결과 복사")
        print("-"*60)
        print("종료: Ctrl+C")
        print("="*60 + "\n")
    
    def stop(self) -> None:
        """번역기 중지"""
        self._running = False
        self.unregister_hotkeys()
        print("\n번역기가 종료되었습니다.")
    
    def run_forever(self) -> None:
        """메인 루프 실행"""
        self.start()
        
        try:
            while self._running:
                time.sleep(0.1)
        except KeyboardInterrupt:
            pass
        finally:
            self.stop()


def cli_test_mode(config: APIConfig) -> None:
    """CLI 테스트 모드"""
    translator = DualTranslator(config)
    
    print("\n" + "="*60)
    print("🌐 번역기 CLI 테스트 모드")
    print("="*60)
    print("명령어:")
    print("  /engine [deepl|papago]  - 엔진 전환")
    print("  /lang [KO|EN|JA|ZH]     - 대상 언어 변경")
    print("  /compare                - 비교 번역 모드")
    print("  /usage                  - 사용량 확인")
    print("  /quit                   - 종료")
    print("="*60 + "\n")
    
    target_lang = "KO"
    compare_mode = False
    
    while True:
        try:
            text = input(f"[{translator.current_engine.value}→{target_lang}] 번역할 텍스트: ").strip()
            
            if not text:
                continue
            
            # 명령어 처리
            if text.startswith("/"):
                parts = text.split()
                cmd = parts[0].lower()
                
                if cmd == "/quit":
                    break
                elif cmd == "/engine":
                    if len(parts) > 1:
                        engine = parts[1].lower()
                        if engine == "deepl":
                            translator.set_engine(TranslatorEngine.DEEPL)
                        elif engine == "papago":
                            translator.set_engine(TranslatorEngine.PAPAGO)
                    else:
                        translator.switch_engine()
                    print(f"현재 엔진: {translator.current_engine.value}")
                elif cmd == "/lang":
                    if len(parts) > 1:
                        target_lang = parts[1].upper()
                        print(f"대상 언어: {target_lang}")
                elif cmd == "/compare":
                    compare_mode = not compare_mode
                    print(f"비교 모드: {'ON' if compare_mode else 'OFF'}")
                elif cmd == "/usage":
                    stats = translator.get_usage_stats()
                    print(f"사용량: DeepL {stats['deepl_chars']:,}자, Papago {stats['papago_chars']:,}자")
                    
                    api_usage = translator.get_deepl_api_usage()
                    if api_usage:
                        print(f"DeepL API: {api_usage.get('character_count', 0):,} / {api_usage.get('character_limit', 500000):,}자")
                continue
            
            # 번역 실행
            if compare_mode:
                deepl_result, papago_result = translator.translate_both(text, target_lang)
                print(f"🔵 DeepL: {deepl_result.translated_text if deepl_result.success else deepl_result.error_message}")
                print(f"🟢 Papago: {papago_result.translated_text if papago_result.success else papago_result.error_message}")
            else:
                result = translator.translate(text, target_lang)
                if result.success:
                    print(f"✅ {result.translated_text}")
                else:
                    print(f"❌ {result.error_message}")
            
            print()
            
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(f"오류: {e}")
    
    print("\n종료합니다.")


def main():
    parser = argparse.ArgumentParser(description="단축키 기반 듀얼 번역기")
    parser.add_argument("--setup", action="store_true", help="API 설정")
    parser.add_argument("--cli", action="store_true", help="CLI 테스트 모드")
    args = parser.parse_args()
    
    # 설정 로드
    manager = ConfigManager()
    
    if args.setup:
        manager.setup_interactive()
        return
    
    # 설정 검증
    issues = manager.config.validate()
    if issues:
        print("\n⚠️  API 설정이 필요합니다:")
        for service, msg in issues.items():
            print(f"   - {msg}")
        print("\n설정 실행: python main.py --setup")
        
        response = input("\n설정을 진행하시겠습니까? (y/n): ")
        if response.lower() == 'y':
            manager.setup_interactive()
        return
    
    if args.cli:
        cli_test_mode(manager.config)
    else:
        # 단축키 모드 실행
        app = HotkeyTranslator(manager.config)
        app.run_forever()


if __name__ == "__main__":
    main()