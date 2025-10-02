
markdown
# 🚀 GitHub 자동화 스터디 저장소

코딩 풀이를 날짜별로 정리하고, GitHub Actions를 통해 README.md에 자동으로 ✅ / ⏰ / ❌ 상태를 갱신합니다.

---

## 🛠️ 실행 스크립트 사용법

```bash
chmod +x scripts/new_day.sh
./scripts/new_day.sh 2025-10-03
```

- 실행 시: `solutions/2025/10/03/{python,sql,java}/` 폴더 생성됨

🔧 Git Bash에서 권한이 안 먹힐 경우:

```bash
git update-index --chmod=+x scripts/new_day.sh
```

---

## ⚙️ GitHub Actions 설정

### 1. 워크플로 파일 위치

`.github/workflows/` 폴더에 아래 두 파일을 넣습니다:

- `update-daily-status.yml`: 풀이 푸시 시 ✅ 또는 ⏰ 갱신
- `daily-schedule.yml`: 매일 새벽 6시 자동 실행 → 풀이 없으면 ❌ 갱신

### 2. Actions 활성화

- 저장소 → Settings → Actions → General
- ✅ **Allow all actions and reusable workflows** 체크
- 두 YAML 파일에 아래 권한 포함 확인:

```yaml
permissions:
  contents: write
```

---

## ✅ 수동 푸시 테스트

1. 더미 파일 생성:

```bash
mkdir -p solutions/2025/10/03/python
echo 'print("hello")' > solutions/2025/10/03/python/hello.py
```

2. 커밋 & 푸시:

```bash
git add solutions/2025/10/03/python/hello.py
git commit -m "feat: add daily solution (2025-10-03)"
git push
```

3. 확인:

- GitHub → Actions 탭 → `Update Daily Status on Push` 실행됨
- README.md의 해당 날짜가 다음 기준에 따라 갱신됨:
    - ✅: 서울시간 기준 23:59:59 이전 첫 푸시
    - ⏰: 그 이후 ~ 익일 06:00 사이 푸시

---

## ⏰ 스케줄 트리거 테스트

- `daily-schedule.yml`은 매일 새벽 6시(KST) 자동 실행
- 풀이가 없으면 해당 날짜는 ❌로 표시됨

---

## 🔐 브랜치 보호 설정 (권장)

### 1. Ruleset 생성

- 저장소 → Settings → Branches → Rulesets
- `main`, `develop` 각각에 대해 아래 설정 적용

### 2. 필수 옵션

- ✅ Require a pull request before merging
- ✅ Block force pushes
- ✅ Restrict deletions
- ✅ Dismiss stale approvals when new commits are pushed
- ➕ Require approvals: 1인 팀이면 0~1, 협업이면 1~2

### 3. 선택 옵션

- Require linear history: 스쿼시/리베이스만 허용
- Require status checks to pass: CI 사용 시 필수 체크 지정

---

## 📁 풀이 파일 구조

```text
solutions/
└── YYYY/
    └── MM/
        └── DD/
            ├── python/
            ├── sql/
            └── java/
```

- 커밋 메시지 예시: `feat: add daily solution (2025-10-03)`
- README.md는 날짜별 풀이 여부에 따라 자동 상태 갱신됨

---

## 📌 기타 참고

- `scripts/update_readme.py`가 핵심 자동화 스크립트입니다
- `requirements.txt`에 필요한 Python 패키지 명시
- GitHub Issue 또는 Projects 탭을 활용해 적립/보상 관리 가능
```