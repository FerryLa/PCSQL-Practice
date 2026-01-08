"""
번역기 설정 모듈
API 키와 환경 설정을 관리합니다.

[API 키 발급 방법]

1. DeepL API Free (월 50만 자 무료)
   - https://www.deepl.com/ko/pro#developer 접속
   - "무료 회원가입하기" 클릭
   - 카드 정보 입력 (인증용, 실결제 없음)
   - 계정 > API 키에서 키 확인
   - 엔드포인트: https://api-free.deepl.com (Free 플랜)

2. Papago API (네이버 클라우드 플랫폼)
   - https://www.ncloud.com 가입
   - 콘솔 > AI·NAVER API > Papago Translation 이용 신청
   - Application 등록 > Papago Translation 선택
   - Client ID, Client Secret 발급
   - 신규 가입 시 크레딧 제공 (유료, 종량제)
"""

import os
import json
from pathlib import Path
from dataclasses import dataclass, asdict
from typing import Optional


@dataclass
class APIConfig:
    """API 설정 데이터클래스"""
    # DeepL 설정
    deepl_api_key: str = "f9a95561-32d4-4a6f-839c-4fab6f7f77aa:fx"
    deepl_endpoint: str = "https://api-free.deepl.com/v2/translate"
    
    # Papago 설정 (네이버 클라우드 플랫폼)
    papago_client_id: str = "ws9ymisn4r"
    papago_client_secret: str = "WhSwM3KnhCCM9FCNCe0m3ZPKb5IK7DMKQbXx4HTg"
    papago_endpoint: str = "https://papago.apigw.ntruss.com/nmt/v1/translation"
    
    # 기본 설정
    default_source_lang: str = "auto"  # 자동 감지
    default_target_lang: str = "KO"    # 한국어
    primary_translator: str = "deepl"  # 기본 번역기: deepl 또는 papago
    
    # 단축키 설정
    hotkey_translate: str = "ctrl+shift+t"      # 번역 실행
    hotkey_swap_lang: str = "ctrl+shift+s"      # 언어 방향 전환
    hotkey_switch_engine: str = "ctrl+shift+e"  # 번역 엔진 전환
    hotkey_copy_result: str = "ctrl+shift+c"    # 결과 복사
    
    def validate(self) -> dict:
        """설정 유효성 검사"""
        issues = {}
        
        if not self.deepl_api_key:
            issues['deepl'] = "DeepL API 키가 설정되지 않았습니다."
        
        if not self.papago_client_id or not self.papago_client_secret:
            issues['papago'] = "Papago Client ID/Secret이 설정되지 않았습니다."
        
        return issues


class ConfigManager:
    """설정 파일 관리 클래스"""
    
    DEFAULT_CONFIG_PATH = Path.home() / ".translator_config.json"
    
    def __init__(self, config_path: Optional[Path] = None):
        self.config_path = config_path or self.DEFAULT_CONFIG_PATH
        self.config = self._load_config()
    
    def _load_config(self) -> APIConfig:
        """설정 파일 로드"""
        if self.config_path.exists():
            try:
                with open(self.config_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                return APIConfig(**data)
            except (json.JSONDecodeError, TypeError) as e:
                print(f"설정 파일 로드 실패: {e}")
        
        return APIConfig()
    
    def save_config(self) -> None:
        """설정 파일 저장"""
        with open(self.config_path, 'w', encoding='utf-8') as f:
            json.dump(asdict(self.config), f, indent=2, ensure_ascii=False)
        print(f"설정이 저장되었습니다: {self.config_path}")
    
    def setup_interactive(self) -> None:
        """대화형 설정"""
        print("\n" + "="*60)
        print("🌐 번역기 API 설정")
        print("="*60)
        
        # DeepL 설정
        print("\n[1] DeepL API 설정 (월 50만 자 무료)")
        print("    발급: https://www.deepl.com/ko/pro#developer")
        key = input(f"    API Key [{self.config.deepl_api_key[:10]}...]: ").strip()
        if key:
            self.config.deepl_api_key = key
        
        # Papago 설정
        print("\n[2] Papago API 설정 (네이버 클라우드 플랫폼)")
        print("    발급: https://www.ncloud.com > 콘솔 > AI·NAVER API")
        
        client_id = input(f"    Client ID [{self.config.papago_client_id[:10] if self.config.papago_client_id else ''}...]: ").strip()
        if client_id:
            self.config.papago_client_id = client_id
        
        client_secret = input(f"    Client Secret [{self.config.papago_client_secret[:10] if self.config.papago_client_secret else ''}...]: ").strip()
        if client_secret:
            self.config.papago_client_secret = client_secret
        
        # 기본 번역기 선택
        print("\n[3] 기본 번역기 선택")
        print("    1. DeepL (영어 번역 품질 우수)")
        print("    2. Papago (한국어 번역 품질 우수)")
        choice = input(f"    선택 [현재: {self.config.primary_translator}]: ").strip()
        if choice == "1":
            self.config.primary_translator = "deepl"
        elif choice == "2":
            self.config.primary_translator = "papago"
        
        self.save_config()
        
        # 유효성 검사
        issues = self.config.validate()
        if issues:
            print("\n⚠️  설정 확인 필요:")
            for service, msg in issues.items():
                print(f"   - {msg}")
        else:
            print("\n✅ 모든 API가 설정되었습니다!")


# 언어 코드 매핑
DEEPL_LANGUAGES = {
    "auto": None,  # 자동 감지 (source만)
    "KO": "KO",
    "EN": "EN",
    "JA": "JA",
    "ZH": "ZH",
    "DE": "DE",
    "FR": "FR",
    "ES": "ES",
    "IT": "IT",
    "PT": "PT-BR",
    "RU": "RU",
}

PAPAGO_LANGUAGES = {
    "auto": "auto",
    "KO": "ko",
    "EN": "en",
    "JA": "ja",
    "ZH": "zh-CN",
    "DE": "de",
    "FR": "fr",
    "ES": "es",
    "IT": "it",
    "PT": "pt",
    "RU": "ru",
}


if __name__ == "__main__":
    manager = ConfigManager()
    manager.setup_interactive()