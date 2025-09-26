SELECT 'purge table "' ||tname|| '";'FROM tab;

SELECT * 
FROM tab;

SELECT * FROM user_recyclebin;

FLASHBACK TABLE new_table TO BEFORE DROP;

CREATE TABLE new_emp (
  no NUMBER(4) CONSTRAINT emp_pk PRIMARY KEY, -- 제약조건과 이름 설정
  name VARCHAR2(20) CONSTRAINT emp_name_nn NOT NULL,
  jumin VARCHAR2(13) CONSTRAINT emp_jumin_nn NOT NULL
                     CONSTRAINT emp_jumin_uk UNIQUE,
  loc_code NUMBER(1) CONSTRAINT emp_area_ck CHECK (loc_code < 5),
  deptno NUMBER(2) CONSTRAINT emp_dept_fk REFERENCES dept (deptno)
);

CREATE TABLE new_table (
no NUMBER(3) PRIMARY KEY, -- 회원번호 3자리
name VARCHAR2(100) NOT NULL, -- 이름 100자
birth DATE DEFAULT SYSDATE-- 생년월일 --to_date('2020-01-01', 'rrrr-mm-dd')
);

ALTER TABLE new_table ADD phone VARCHAR2(20); -- 칼럼 추가

ALTER TABLE new_table READ ONLY; -- 읽기 전용 테이블로 변경

SELECT * FROM new_table;
ALTER TABLE new_table ADD info generated always as (no || '-' || name); -- 가상컬럼 추가

ALTER TABLE new_table RENAME COLUMN phone TO tel; -- 칼럼 이름 변경
ALTER TABLE new_table MODIFY tel VARCHAR2(30); -- 칼럼 데이터 크기 변경

-- 테이블 데이터 유형 보기
DESCRIBE new_table;
DESC new_table;

ALTER TABLE new_table DROP COLUMN tel; -- tel 칼럼 휴지통에 버리기

TRUNCATE TABLE new_table; -- 테이블 안 데이터 삭제
DROP TABLE new_table; -- 휴지통에 버리기
DROP TABLE new_table PURGE; -- 휴지통에 안 가고 바로 삭제
DELETE FROM new_table -- 1번 항목 DELETE
WHERE no = 1;
SELECT * FROM new_table;

ROLLBACK; -- 이전 커밋으로 돌리기

INSERT INTO new_table (no, name)
VALUES(1, '홍길동');
INSERT INTO new_table (no, name, birth)
VALUES(2, '홍길동', '2001-01-01');

UPDATE new_table
SET phone = '010-2222-2222',
    birth = TO_DATE('2001-02-02', 'rrrr-mm-dd')
WHERE NO = 2
;
---------------------------------------------------------
SELECT * FROM dept2
ORDER BY dcode; -- dcode로 정렬
DESC dept2;

INSERT INTO dept2 (dcode, dname, pdept, area) -- 데이터 넣기
VALUES('9001', 'temp_1', '1006', 'temp area');

CREATE TABLE professor3
AS
SELECT * FROM professor
WHERE 1 = 2; -- CTAS

INSERT INTO professor3
SELECT * FROM professor; --ITAS

SELECT * FROM professor3;

CREATE TABLE prof_1 (  -- 테이블이 만들어지면 자동 커밋
    profno number,
    name varchar2(25));
    
CREATE TABLE prof_2 ( 
    profno number,
    name varchar2(25));
    
SELECT * FROM prof_1;
SELECT * FROM prof_2;
    
INSERT ALL
  WHEN profno BETWEEN 1000 AND 1999 THEN INTO prof_1 VALUES (profno, name)
  WHEN profno BETWEEN 2000 AND 2999 THEN INTO prof_2 VALUES (profno, name)
  SELECT profno, name
  FROM professor;
  
INSERT ALL
    INTO prof_1 VALUES (profno, name)
    INTO prof_2 VALUES (profno, name)
  SELECT profno, name
  FROM professor;

SELECT * FROM professor;

UPDATE professor  -- 데이터 변경
SET    bonus = DECODE(bonus, null, 100, bonus),
       pay = pay + (pay * 0.1),
       hpage = 'http://www.' || SUBSTR()
       -- hpage를 이메일의 회사의 홈페이지로 변경해보기.
WHERE 1=1
;

DELETE FROM professor  -- hpage 있는 사람만 지우기
WHERE hpage IS NOT NULL
;

-- dept 삭제.
SELECT * FROM dept;

DELETE FROM dept
WHERE deptno = 30;

SELECT * FROM emp;

DELETE FROM emp
WHERE deptno = 30
;

UPDATE emp
SET deptno = 50
WHERE deptno = 20;

SELECT e.* FROM emp e, dept d
WHERE e.deptno = d.deptno
;

UPDATE emp e  -- 업데이트 조인
SET sal = sal + 100
WHERE EXISTS (SELECT 1
              FROM dept d
              WHERE e.deptno = d.deptno
              AND d.loc = 'DALLAS');
              
-- 게시판, 회원관리, 상품관리 -> 프로젝트 주제
-- 오라클서버(DB) --- 웹서버(노드활용) --- 클라이언트(fetch활용)
SELECT *
FROM emp;
