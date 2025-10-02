# Github Action

## 1. 실행권한 부여 + 테스트

``` 
bash

chmod +x scripts/new_day.sh
./scripts/new_day.sh 2025-10-03   # ← 실행하면 solutions/2025/10/03/{python,sql,java}/ 생성
```
  
윈도우 Git Bash에서 권한이 안 먹히면:


```
bash

git update-index --chmod=+x scripts/new_day.sh
```

## 2. 두 개 YAML 파일 내용
둘 다 저장소 루트의 .github/workflows/ 폴더에 넣는다. 날짜는 네 일정에 맞게 바꿔도 되고, 아래는 2025-10-03 시작, 2025-11-21 종료 기준
- 풀이 파일을 solutions/YYYY/MM/DD/**에 넣고 푸시하면 README의 자동 구역을 **✅ 또는 ⏰**로 갱신

## 3. 저장소 Actions 활성화
Repo → Settings → Actions → General → Allow all actions and reusable workflows
- README.md에 자동 구역이 정확히
- 두 워크플로가 .github/workflows/ 아래에 있고, permissions: contents: write 들어가 있는지 확인.