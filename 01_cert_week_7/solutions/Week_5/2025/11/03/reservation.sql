
/* 문제 설명
RESERVATION 테이블은 회의실 예약 요청 정보를 담고 있는 테이블입니다. RESERVATION 테이블의 구조는 다음과 같으며, ID, USER_ID, START_TIME, END_TIME는 각각 예약 요청 ID, 유저의 ID, 회의실 이용 시작 시간, 회의실 이용 종료 시간을 나타냅니다.

NAME	TYPE	NULLABLE
ID	INT	FALSE
USER_ID	INT	FALSE
START_TIME	DATETIME	FALSE
END_TIME	DATETIME	FALSE
문제
회의실 예약 요청 정보를 통해 어떤 요청이 확정되었는지 알아보려고 합니다.

예약 요청은 다음과 같이 처리됩니다.

요청된 회의실 이용 시간이 먼저 요청된 모든 예약들의 이용 시간과 겹치지 않는다면 예약이 확정됩니다.
먼저 끝나는 회의의 종료 시각과 다음 회의의 시작 시각이 같다면 두 이용 시간은 겹치지 않습니다.
예약 요청 ID가 작을수록 먼저 요청되었음을 의미합니다.
확정되지 않은 예약 요청도 이후 발생하는 요청의 확정 여부에 영향을 줍니다.
예약이 확정된 요청의 ID와 회의실 이용 시작 시간, 종료 시간을 조회하는 SQL문을 작성해 주세요.

결과는 회의실 이용 시작 시간을 기준으로 오름차순 정렬해 주세요. */

SELECT r.id, r.start_time, r.end_time
FROM reservation r -- 신규 조회
WHERE NOT EXISTS (   -- 이 조건을 만족하는 행이 하나도 없을 때만 참
    SELECT 1
    FROM reservation p -- 기존 테이블 조회
    WHERE p.id < r.id
    -- 겹침절
    AND p.end_time > r.start_time
    AND p.start_time < r.end_time

)
ORDER BY r.start_time;