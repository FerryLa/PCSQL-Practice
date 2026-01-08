"""
시스템 트레이 GUI 모듈

Features:
- 시스템 트레이 아이콘으로 백그라운드 실행
- 번역 결과 팝업 알림
- 트레이 메뉴로 엔진/언어 전환
- 사용량 모니터링

Dependencies:
    pip install pystray Pillow
"""

import sys
import threading
from typing import Optional
import io

try:
    from PIL import Image, ImageDraw, ImageFont
    import pystray
    from pystray import MenuItem as Item
    HAS_TRAY = True
except ImportError:
    HAS_TRAY = False

from config import ConfigManager, APIConfig
from translator import DualTranslator, TranslatorEngine
from main import HotkeyTranslator


class TrayIcon:
    """시스템 트레이 아이콘 관리"""
    
    def __init__(self, app: 'TrayTranslator'):
        self.app = app
        self.icon: Optional[pystray.Icon] = None
    
    def create_icon_image(self, engine: TranslatorEngine) -> Image.Image:
        """동적 아이콘 이미지 생성"""
        size = 64
        image = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(image)
        
        # 배경 원
        if engine == TranslatorEngine.DEEPL:
            bg_color = (0, 114, 255)  # DeepL 파란색
        else:
            bg_color = (3, 199, 90)   # Papago 녹색
        
        draw.ellipse([2, 2, size-2, size-2], fill=bg_color)
        
        # 텍스트 "T" (Translate)
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
        except:
            font = ImageFont.load_default()
        
        draw.text((size//2, size//2), "T", fill="white", font=font, anchor="mm")
        
        return image
    
    def create_menu(self) -> pystray.Menu:
        """트레이 메뉴 생성"""
        return pystray.Menu(
            Item(
                f'현재 엔진: {self.app.hotkey_app.current_engine.upper()}',
                None,
                enabled=False
            ),
            Item(
                f'언어: {self.app.hotkey_app.language_pair}',
                None,
                enabled=False
            ),
            pystray.Menu.SEPARATOR,
            Item('DeepL로 전환', self._on_set_deepl, 
                 checked=lambda item: self.app.hotkey_app.translator.current_engine == TranslatorEngine.DEEPL),
            Item('Papago로 전환', self._on_set_papago,
                 checked=lambda item: self.app.hotkey_app.translator.current_engine == TranslatorEngine.PAPAGO),
            pystray.Menu.SEPARATOR,
            Item('한국어 (KO)', lambda: self._on_set_target('KO'),
                 checked=lambda item: self.app.hotkey_app._target_lang == 'KO'),
            Item('영어 (EN)', lambda: self._on_set_target('EN'),
                 checked=lambda item: self.app.hotkey_app._target_lang == 'EN'),
            Item('일본어 (JA)', lambda: self._on_set_target('JA'),
                 checked=lambda item: self.app.hotkey_app._target_lang == 'JA'),
            Item('중국어 (ZH)', lambda: self._on_set_target('ZH'),
                 checked=lambda item: self.app.hotkey_app._target_lang == 'ZH'),
            pystray.Menu.SEPARATOR,
            Item('사용량 확인', self._on_show_usage),
            Item('설정', self._on_settings),
            pystray.Menu.SEPARATOR,
            Item('종료', self._on_quit),
        )
    
    def _on_set_deepl(self) -> None:
        self.app.hotkey_app.translator.set_engine(TranslatorEngine.DEEPL)
        self._update_icon()
    
    def _on_set_papago(self) -> None:
        self.app.hotkey_app.translator.set_engine(TranslatorEngine.PAPAGO)
        self._update_icon()
    
    def _on_set_target(self, lang: str) -> None:
        self.app.hotkey_app._target_lang = lang
        self._update_menu()
    
    def _on_show_usage(self) -> None:
        stats = self.app.hotkey_app.translator.get_usage_stats()
        api_usage = self.app.hotkey_app.translator.get_deepl_api_usage()
        
        msg = f"세션 사용량:\n"
        msg += f"  DeepL: {stats['deepl_chars']:,}자\n"
        msg += f"  Papago: {stats['papago_chars']:,}자\n"
        
        if api_usage:
            used = api_usage.get('character_count', 0)
            limit = api_usage.get('character_limit', 500000)
            percent = (used / limit * 100) if limit > 0 else 0
            msg += f"\nDeepL API 월간 사용량:\n"
            msg += f"  {used:,} / {limit:,}자 ({percent:.1f}%)"
        
        self.icon.notify(msg, "📊 사용량")
    
    def _on_settings(self) -> None:
        self.icon.notify("설정을 변경하려면 'python main.py --setup' 실행", "⚙️ 설정")
    
    def _on_quit(self) -> None:
        self.app.stop()
    
    def _update_icon(self) -> None:
        """아이콘 업데이트"""
        if self.icon:
            self.icon.icon = self.create_icon_image(
                self.app.hotkey_app.translator.current_engine
            )
            self._update_menu()
    
    def _update_menu(self) -> None:
        """메뉴 업데이트"""
        if self.icon:
            self.icon.menu = self.create_menu()
    
    def start(self) -> None:
        """트레이 아이콘 시작"""
        engine = self.app.hotkey_app.translator.current_engine
        
        self.icon = pystray.Icon(
            name="translator",
            icon=self.create_icon_image(engine),
            title="번역기",
            menu=self.create_menu()
        )
        
        self.icon.run()
    
    def stop(self) -> None:
        """트레이 아이콘 중지"""
        if self.icon:
            self.icon.stop()
    
    def notify(self, message: str, title: str = "번역기") -> None:
        """알림 표시"""
        if self.icon:
            self.icon.notify(message, title)


class TrayTranslator:
    """
    시스템 트레이 기반 번역기 애플리케이션
    
    백그라운드에서 실행되며 단축키와 트레이 메뉴로 제어
    """
    
    def __init__(self, config: APIConfig):
        self.config = config
        self.hotkey_app = HotkeyTranslator(config)
        self.tray: Optional[TrayIcon] = None
        self._running = False
        
        # 콜백 연결
        self.hotkey_app.on_translation_complete = self._on_translation_complete
        self.hotkey_app.on_engine_changed = self._on_engine_changed
        self.hotkey_app.on_error = self._on_error
    
    def _on_translation_complete(self, result) -> None:
        """번역 완료 알림"""
        if self.tray and self.tray.icon:
            short_result = result.translated_text[:100]
            if len(result.translated_text) > 100:
                short_result += "..."
            
            engine_name = "DeepL" if result.engine == TranslatorEngine.DEEPL else "Papago"
            self.tray.notify(
                f"{short_result}",
                f"✅ {engine_name} 번역"
            )
    
    def _on_engine_changed(self, engine: TranslatorEngine) -> None:
        """엔진 변경 시 아이콘 업데이트"""
        if self.tray:
            self.tray._update_icon()
            engine_name = "DeepL" if engine == TranslatorEngine.DEEPL else "Papago"
            self.tray.notify(f"번역 엔진이 {engine_name}(으)로 변경되었습니다.", "🔄 엔진 전환")
    
    def _on_error(self, message: str) -> None:
        """오류 알림"""
        if self.tray and self.tray.icon:
            self.tray.notify(message, "❌ 오류")
    
    def start(self) -> None:
        """애플리케이션 시작"""
        self._running = True
        
        # 단축키 등록
        self.hotkey_app.register_hotkeys()
        
        print("\n" + "="*60)
        print("🌐 시스템 트레이 번역기 실행")
        print("="*60)
        print("시스템 트레이에서 번역기를 제어할 수 있습니다.")
        print(f"기본 단축키: {self.config.hotkey_translate}")
        print("="*60 + "\n")
        
        # 트레이 아이콘 시작 (블로킹)
        if HAS_TRAY:
            self.tray = TrayIcon(self)
            self.tray.start()  # 이 함수는 블로킹됨
        else:
            print("pystray/Pillow가 설치되지 않아 트레이 아이콘 없이 실행합니다.")
            self.hotkey_app.run_forever()
    
    def stop(self) -> None:
        """애플리케이션 중지"""
        self._running = False
        self.hotkey_app.unregister_hotkeys()
        
        if self.tray:
            self.tray.stop()
        
        print("\n번역기가 종료되었습니다.")


def main():
    """메인 진입점"""
    if not HAS_TRAY:
        print("⚠️  pystray 또는 Pillow가 설치되지 않았습니다.")
        print("설치: pip install pystray Pillow")
        print("\n트레이 없이 기본 모드로 실행합니다...")
        
        from main import main as cli_main
        cli_main()
        return
    
    # 설정 로드
    manager = ConfigManager()
    
    # 설정 검증
    issues = manager.config.validate()
    if issues:
        print("\n⚠️  API 설정이 필요합니다:")
        for service, msg in issues.items():
            print(f"   - {msg}")
        print("\n설정 실행: python main.py --setup")
        return
    
    # 트레이 모드 실행
    app = TrayTranslator(manager.config)
    
    try:
        app.start()
    except KeyboardInterrupt:
        app.stop()


if __name__ == "__main__":
    main()