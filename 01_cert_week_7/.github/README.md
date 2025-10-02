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

## 4. 푸시 트리거 빠른 수동 테스트 (✅/⏰ 갱신 확인)

오늘 날짜로 더미 파일 하나 넣고 푸시한다. 액션이 자동으로 돈다.

1) 날짜 폴더 생성 (이미 스크립트 있으면 그걸로)
```
mkdir -p solutions/2025/10/03/python
printf 'print("hello")\n' > solutions/2025/10/03/python/hello.py
```

2) 커밋/푸시
```
git add solutions/2025/10/03/python/hello.py
git commit -m "feat: add daily solution (2025-10-03)"
git push
```
확인:
GitHub → Actions 탭 → Update Daily Status on Push 실행됨
끝나면 README의 해당 날짜가 ✅ 또는 **⏰**로 바뀌어야 한다
서울시간 23:59:59 전에 첫 푸시면 ✅
그 이후 새벽 06:00 전이면 ⏰

## 5. 스케줄 트리거 테스트(❌ 마감) 빠르게 확인
