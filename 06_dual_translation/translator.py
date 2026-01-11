"""
번역 API 클라이언트 모듈
DeepL과 Papago API를 통합 관리합니다.
"""

import requests
from dataclasses import dataclass
from typing import Optional, Tuple
from enum import Enum
import logging

from config import APIConfig, DEEPL_LANGUAGES, PAPAGO_LANGUAGES


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class TranslatorEngine(Enum):
    """번역 엔진 열거형"""
    DEEPL = "deepl"
    PAPAGO = "papago"


@dataclass
class TranslationResult:
    """번역 결과 데이터클래스"""
    success: bool
    source_text: str
    translated_text: str
    source_lang: str
    target_lang: str
    engine: TranslatorEngine
    error_message: Optional[str] = None
    char_count: int = 0


class DeepLTranslator:
    """DeepL API 클라이언트"""
    
    def __init__(self, api_key: str, endpoint: str = "https://api-free.deepl.com/v2/translate"):
        self.api_key = api_key
        self.endpoint = endpoint
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"DeepL-Auth-Key {api_key}",
            "Content-Type": "application/json"
        })
    
    def translate(
        self,
        text: str,
        target_lang: str = "KO",
        source_lang: Optional[str] = None
    ) -> TranslationResult:
        """
        DeepL API로 번역 수행
        
        Args:
            text: 번역할 텍스트
            target_lang: 대상 언어 (KO, EN, JA 등)
            source_lang: 원본 언어 (None이면 자동 감지)
        
        Returns:
            TranslationResult 객체
        """
        if not self.api_key:
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang or "auto",
                target_lang=target_lang,
                engine=TranslatorEngine.DEEPL,
                error_message="DeepL API 키가 설정되지 않았습니다."
            )
        
        # 언어 코드 변환
        deepl_target = DEEPL_LANGUAGES.get(target_lang, target_lang)
        deepl_source = DEEPL_LANGUAGES.get(source_lang) if source_lang else None
        
        payload = {
            "text": [text],
            "target_lang": deepl_target
        }
        
        if deepl_source:
            payload["source_lang"] = deepl_source
        
        try:
            response = self.session.post(self.endpoint, json=payload, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            translations = data.get("translations", [])
            
            if translations:
                result = translations[0]
                detected_lang = result.get("detected_source_language", source_lang or "auto")
                translated = result.get("text", "")
                
                return TranslationResult(
                    success=True,
                    source_text=text,
                    translated_text=translated,
                    source_lang=detected_lang,
                    target_lang=target_lang,
                    engine=TranslatorEngine.DEEPL,
                    char_count=len(text)
                )
            
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang or "auto",
                target_lang=target_lang,
                engine=TranslatorEngine.DEEPL,
                error_message="번역 결과가 비어있습니다."
            )
            
        except requests.exceptions.HTTPError as e:
            error_msg = f"HTTP 오류: {e.response.status_code}"
            if e.response.status_code == 403:
                error_msg = "API 키가 유효하지 않습니다."
            elif e.response.status_code == 456:
                error_msg = "월간 번역 한도를 초과했습니다."
            
            logger.error(f"DeepL API 오류: {error_msg}")
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang or "auto",
                target_lang=target_lang,
                engine=TranslatorEngine.DEEPL,
                error_message=error_msg
            )
            
        except requests.exceptions.RequestException as e:
            logger.error(f"DeepL 요청 오류: {e}")
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang or "auto",
                target_lang=target_lang,
                engine=TranslatorEngine.DEEPL,
                error_message=f"네트워크 오류: {str(e)}"
            )
    
    def get_usage(self) -> Optional[dict]:
        """API 사용량 조회"""
        try:
            response = self.session.get(
                self.endpoint.replace("/translate", "/usage"),
                timeout=10
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"사용량 조회 실패: {e}")
            return None


class PapagoTranslator:
    """Papago API 클라이언트 (네이버 클라우드 플랫폼)"""
    
    def __init__(
        self,
        client_id: str,
        client_secret: str,
        endpoint: str = "https://papago.apigw.ntruss.com/nmt/v1/translation"
    ):
        self.client_id = client_id
        self.client_secret = client_secret
        self.endpoint = endpoint
        self.session = requests.Session()
        self.session.headers.update({
            "X-NCP-APIGW-API-KEY-ID": client_id,
            "X-NCP-APIGW-API-KEY": client_secret,
            "Content-Type": "application/json"
        })
    
    def translate(
        self,
        text: str,
        target_lang: str = "KO",
        source_lang: str = "auto"
    ) -> TranslationResult:
        """
        Papago API로 번역 수행
        
        Args:
            text: 번역할 텍스트
            target_lang: 대상 언어
            source_lang: 원본 언어 (auto면 자동 감지)
        
        Returns:
            TranslationResult 객체
        """
        if not self.client_id or not self.client_secret:
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang,
                target_lang=target_lang,
                engine=TranslatorEngine.PAPAGO,
                error_message="Papago API 키가 설정되지 않았습니다."
            )
        
        # 언어 코드 변환
        papago_source = PAPAGO_LANGUAGES.get(source_lang, source_lang.lower())
        papago_target = PAPAGO_LANGUAGES.get(target_lang, target_lang.lower())
        
        payload = {
            "source": papago_source,
            "target": papago_target,
            "text": text
        }
        
        try:
            response = self.session.post(self.endpoint, json=payload, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            message = data.get("message", {})
            result = message.get("result", {})
            
            translated = result.get("translatedText", "")
            detected_lang = result.get("srcLangType", source_lang)
            
            if translated:
                return TranslationResult(
                    success=True,
                    source_text=text,
                    translated_text=translated,
                    source_lang=detected_lang.upper(),
                    target_lang=target_lang,
                    engine=TranslatorEngine.PAPAGO,
                    char_count=len(text)
                )
            
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang,
                target_lang=target_lang,
                engine=TranslatorEngine.PAPAGO,
                error_message="번역 결과가 비어있습니다."
            )
            
        except requests.exceptions.HTTPError as e:
            error_msg = f"HTTP 오류: {e.response.status_code}"
            
            try:
                error_data = e.response.json()
                error_code = error_data.get("error", {}).get("errorCode", "")
                if error_code == "N2MT07":
                    error_msg = "지원하지 않는 언어 조합입니다."
                elif e.response.status_code == 429:
                    error_msg = "API 호출 한도를 초과했습니다."
                elif e.response.status_code == 401:
                    error_msg = "API 키가 유효하지 않습니다."
            except:
                pass
            
            logger.error(f"Papago API 오류: {error_msg}")
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang,
                target_lang=target_lang,
                engine=TranslatorEngine.PAPAGO,
                error_message=error_msg
            )
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Papago 요청 오류: {e}")
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang,
                target_lang=target_lang,
                engine=TranslatorEngine.PAPAGO,
                error_message=f"네트워크 오류: {str(e)}"
            )


class DualTranslator:
    """
    듀얼 번역기 - DeepL과 Papago를 통합 관리
    
    Features:
    - 자동 폴백: 주 엔진 실패 시 보조 엔진으로 자동 전환
    - 엔진 전환: 런타임에서 기본 엔진 변경 가능
    - 사용량 추적: 각 엔진별 사용량 모니터링
    """
    
    def __init__(self, config: APIConfig):
        self.config = config
        self.deepl = DeepLTranslator(
            api_key=config.deepl_api_key,
            endpoint=config.deepl_endpoint
        )
        self.papago = PapagoTranslator(
            client_id=config.papago_client_id,
            client_secret=config.papago_client_secret,
            endpoint=config.papago_endpoint
        )
        
        self._current_engine = TranslatorEngine(config.primary_translator)
        self._usage_stats = {
            TranslatorEngine.DEEPL: 0,
            TranslatorEngine.PAPAGO: 0
        }
    
    @property
    def current_engine(self) -> TranslatorEngine:
        return self._current_engine
    
    def switch_engine(self) -> TranslatorEngine:
        """번역 엔진 전환"""
        if self._current_engine == TranslatorEngine.DEEPL:
            self._current_engine = TranslatorEngine.PAPAGO
        else:
            self._current_engine = TranslatorEngine.DEEPL
        
        logger.info(f"번역 엔진 전환: {self._current_engine.value}")
        return self._current_engine
    
    def set_engine(self, engine: TranslatorEngine) -> None:
        """특정 엔진으로 설정"""
        self._current_engine = engine
        logger.info(f"번역 엔진 설정: {engine.value}")
    
    def translate(
        self,
        text: str,
        target_lang: str = "KO",
        source_lang: str = "auto",
        use_fallback: bool = True
    ) -> TranslationResult:
        """
        텍스트 번역 (자동 폴백 지원)
        
        Args:
            text: 번역할 텍스트
            target_lang: 대상 언어
            source_lang: 원본 언어
            use_fallback: 실패 시 다른 엔진으로 재시도 여부
        
        Returns:
            TranslationResult 객체
        """
        if not text.strip():
            return TranslationResult(
                success=False,
                source_text=text,
                translated_text="",
                source_lang=source_lang,
                target_lang=target_lang,
                engine=self._current_engine,
                error_message="번역할 텍스트가 비어있습니다."
            )
        
        # 주 엔진으로 번역 시도
        result = self._translate_with_engine(
            self._current_engine, text, target_lang, source_lang
        )
        
        # 실패 시 폴백
        if not result.success and use_fallback:
            fallback_engine = (
                TranslatorEngine.PAPAGO 
                if self._current_engine == TranslatorEngine.DEEPL 
                else TranslatorEngine.DEEPL
            )
            
            logger.info(f"폴백 번역 시도: {fallback_engine.value}")
            fallback_result = self._translate_with_engine(
                fallback_engine, text, target_lang, source_lang
            )
            
            if fallback_result.success:
                return fallback_result
        
        return result
    
    def _translate_with_engine(
        self,
        engine: TranslatorEngine,
        text: str,
        target_lang: str,
        source_lang: str
    ) -> TranslationResult:
        """특정 엔진으로 번역"""
        if engine == TranslatorEngine.DEEPL:
            result = self.deepl.translate(text, target_lang, source_lang if source_lang != "auto" else None)
        else:
            result = self.papago.translate(text, target_lang, source_lang)
        
        if result.success:
            self._usage_stats[engine] += result.char_count
        
        return result
    
    def translate_both(
        self,
        text: str,
        target_lang: str = "KO",
        source_lang: str = "auto"
    ) -> Tuple[TranslationResult, TranslationResult]:
        """
        양쪽 엔진으로 동시 번역 (비교용)
        
        Returns:
            (DeepL 결과, Papago 결과) 튜플
        """
        deepl_result = self._translate_with_engine(
            TranslatorEngine.DEEPL, text, target_lang, source_lang
        )
        papago_result = self._translate_with_engine(
            TranslatorEngine.PAPAGO, text, target_lang, source_lang
        )
        
        return deepl_result, papago_result
    
    def get_usage_stats(self) -> dict:
        """사용량 통계 반환"""
        return {
            "deepl_chars": self._usage_stats[TranslatorEngine.DEEPL],
            "papago_chars": self._usage_stats[TranslatorEngine.PAPAGO],
            "total_chars": sum(self._usage_stats.values())
        }
    
    def get_deepl_api_usage(self) -> Optional[dict]:
        """DeepL API 공식 사용량 조회"""
        return self.deepl.get_usage()


# 테스트 코드
if __name__ == "__main__":
    from config import ConfigManager
    
    # 설정 로드
    manager = ConfigManager()
    config = manager.config
    
    # 번역기 초기화
    translator = DualTranslator(config)
    
    # 테스트 번역
    test_texts = [
        "Hello, how are you today?",
        "The quick brown fox jumps over the lazy dog.",
        "인공지능 기술이 빠르게 발전하고 있습니다.",
    ]
    
    print("\n" + "="*60)
    print("🌐 번역 테스트")
    print("="*60)
    
    for text in test_texts:
        print(f"\n원문: {text}")
        
        # 단일 번역
        result = translator.translate(text)
        status = "✅" if result.success else "❌"
        print(f"{status} [{result.engine.value}] {result.translated_text}")
        
        if not result.success:
            print(f"   오류: {result.error_message}")
    
    # 사용량 출력
    print(f"\n📊 사용량: {translator.get_usage_stats()}")