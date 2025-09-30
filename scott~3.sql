-- scott~3

-- SELECT ROWNUM 중간에 하나가 삭제 되어도 순번대로 표시
-- 1page: 1~ 10, 2page: 11~ 20,
-- ROWNUM 는 항상 1부터 시작하기 때문에 따로 묶어서 해야 다른 페이지 불러올 수 있음
-- ORFER BY는 오래 걸리기 때문에 현장에서 잘 쓰지 않는다
SELECT b.*
FROM (SELECT /*+ INDEX(a SYS_C008630) */ ROWNUM rn, a.*
      FROM board_t a ) b
WHERE b.rn > (:page - 1) * 10
AND b.rn <= (:page * 10);

-- 실행계획 직접 설정 (인덱스로 정렬)
SELECT /*+ INDEX_DESC(b SYS_C008630) */ b.*
FROM board_t b;

CREATE INDEX board_write_date_idx
ON board_t(write_date);
