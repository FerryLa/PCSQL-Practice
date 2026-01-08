# 🌐 듀얼 번역기 (DeepL + Papago)

단축키 기반 번역 도구 - DeepL과 Papago API를 함께 활용하여 빠르고 정확한 번역을 제공합니다.

## ✨ 주요 기능

- **듀얼 엔진**: DeepL (영어 품질 우수) + Papago (한국어 품질 우수)
- **전역 단축키**: 어떤 앱에서든 즉시 번역
- **자동 폴백**: 한 엔진 실패 시 자동으로 다른 엔진으로 전환
- **비교 번역**: 양쪽 엔진 결과를 동시에 확인
- **시스템 트레이**: 백그라운드 실행 및 알림 지원

## 📦 설치

### 1. 의존성 설치

```bash
python -m pip install --upgrade pip
pip install requests keyboard pyperclip pystray Pillow
```

# 방법 2: Git Bash에서 경로 수정
bash# 슬래시로 변경하고 따옴표로 감싸기

# 또는 winpty 사용
```
winpty python -m pip install requests keyboard pyperclip pystray Pillow
```

### 2. API 키 발급

#### DeepL API Free (월 50만 자 무료)

1. https://www.deepl.com/ko/pro#developer 접속
2. "무료 회원가입하기" 클릭
3. 이메일 인증 후 카드 정보 입력 (인증용, 실결제 없음)
4. 계정 설정 > API 키 섹션에서 키 확인

#### Papago API (네이버 클라우드 플랫폼)

1. https://www.ncloud.com 가입 (신규 가입 시 크레딧 제공)
2. 콘솔 접속 > AI·NAVER API > Papago Translation 이용 신청
3. Application 등록 > Papago Translation 체크
4. Client ID / Client Secret 확인

### 3. API 설정

```bash
python main.py --setup
```

대화형으로 API 키를 입력하면 `~/.translator_config.json`에 저장됩니다.

## 🚀 사용법

### 기본 실행 (단축키 모드)

```bash
python main.py
```

### 시스템 트레이 모드

```bash
python tray_app.py
```

### CLI 테스트 모드

```bash
python main.py --cli
```

## ⌨️ 단축키

| 단축키 | 기능 |
|--------|------|
| `Ctrl+Shift+T` | 클립보드 텍스트 번역 |
| `Ctrl+Shift+S` | 언어 방향 전환 (KO↔EN) |
| `Ctrl+Shift+E` | 번역 엔진 전환 (DeepL↔Papago) |
| `Ctrl+Shift+B` | 비교 번역 (양쪽 결과 표시) |
| `Ctrl+Shift+L` | 대상 언어 순환 (KO→EN→JA→ZH) |
| `Ctrl+Shift+C` | 마지막 번역 결과 복사 |

## 📁 파일 구조

```
translator/
├── config.py       # 설정 관리 및 API 키 저장
├── translator.py   # 번역 API 클라이언트 (DeepL, Papago)
├── main.py         # 메인 애플리케이션 (단축키 모드)
├── tray_app.py     # 시스템 트레이 GUI
└── README.md       # 이 문서
```

## 💰 요금 정보

### DeepL API Free
- **무료**: 월 500,000자
- 카드 등록 필요 (인증용)
- 초과 시 자동 중단 (추가 과금 없음)

### Papago API (네이버 클라우드)
- **종량제**: 100만 자당 약 20,000원
- 신규 가입 시 크레딧 제공
- 일일/월간 한도 직접 설정 가능

## 🔧 설정 파일

`~/.translator_config.json` 예시:

```json
{
  "deepl_api_key": "your-deepl-api-key",
  "deepl_endpoint": "https://api-free.deepl.com/v2/translate",
  "papago_client_id": "your-ncp-client-id",
  "papago_client_secret": "your-ncp-client-secret",
  "papago_endpoint": "https://papago.apigw.ntruss.com/nmt/v1/translation",
  "default_source_lang": "auto",
  "default_target_lang": "KO",
  "primary_translator": "deepl",
  "hotkey_translate": "ctrl+shift+t",
  "hotkey_swap_lang": "ctrl+shift+s",
  "hotkey_switch_engine": "ctrl+shift+e",
  "hotkey_copy_result": "ctrl+shift+c"
}
```

## 🌍 지원 언어

| 코드 | 언어 | DeepL | Papago |
|------|------|:-----:|:------:|
| KO | 한국어 | ✅ | ✅ |
| EN | 영어 | ✅ | ✅ |
| JA | 일본어 | ✅ | ✅ |
| ZH | 중국어 | ✅ | ✅ |
| DE | 독일어 | ✅ | ✅ |
| FR | 프랑스어 | ✅ | ✅ |
| ES | 스페인어 | ✅ | ✅ |
| IT | 이탈리아어 | ✅ | ❌ |
| PT | 포르투갈어 | ✅ | ❌ |
| RU | 러시아어 | ✅ | ✅ |

## 🐛 문제 해결

### "keyboard" 권한 오류 (Linux)
```bash
sudo python main.py
# 또는
sudo chmod +r /dev/input/*
```

### DeepL 456 오류
- 월간 무료 한도(50만 자) 초과
- 다음 달까지 대기 또는 유료 플랜 업그레이드

### Papago 429 오류
- API 호출 한도 초과
- NCP 콘솔에서 일일/월간 한도 확인 및 조정

## 📝 라이선스

MIT License

## 🔗 관련 링크

- [DeepL API 문서](https://www.deepl.com/docs-api)
- [Papago API 가이드](https://api.ncloud-docs.com/docs/ai-naver-papagonmt)
- [네이버 클라우드 플랫폼](https://www.ncloud.com)
