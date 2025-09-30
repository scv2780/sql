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

-- sal => 1000 변경.
UPDATE emp
SET sal = 1000
WHERE sal < 1000
;

-- sales 직무 -> comm 500미만인 사원 => 500 추가
UPDATE emp
SET comm = comm + 500
WHERE NVL(comm, 0) < 500
;

-- 1981년 전반기에 입사한 사원(1~6월) => 10% 인상.
UPDATE emp
SET sal = sal + sal * 0.1
WHERE hiredate >= '1981/01/01'
AND hiredate < '1981/07/01'
;

--
SELECT *
FROM professor;

SELECT *
FROM student;

SELECT *
FROM department;
-- Rene Russo 학생의 담당교수의 번호, 이름, position 확인.
SELECT s.name
      ,p.profno
      ,p.name
      ,p.position
FROM student s
LEFT OUTER JOIN professor p
ON s.profno = p.profno
WHERE studno = 9412
;
-- 전공: 'Computer Engineering' => 학생들의 학번, 이름을 확인.
SELECT s.studno
      ,s.name
      ,d.dname
FROM department d
LEFT OUTER JOIN student s
ON d.deptno = s.deptno1
WHERE d.deptno = 101
;
-- 전공1, 전공2 =>
SELECT s.studno
      ,s.name
      ,d.dname
      ,s.deptno1
      ,s.deptno2
FROM department d
LEFT OUTER JOIN student s
ON d.deptno = s.deptno1
OR d.deptno = s.deptno2
WHERE d.deptno = 101
;
-- 학생중에 전공1 'Computer Engineering' 학생들의 담당교수의 교수번호, 이름, position 확인.
SELECT DISTINCT p.profno
      ,p.name AS "PNAME"
      ,p.position
FROM professor p
JOIN student s
ON p.profno = s.profno
JOIN department d
ON s.deptno1 = d.deptno
WHERE d.deptno = 101;
--
SELECT *
FROM student;

SELECT *
FROM department;
-- 담당교수가 assistant professor 인 학생의 정보
SELECT s.*
FROM student s
JOIN professor p
ON s.profno = p.profno
WHERE p.position = 'assistant professor';

-- 학생전공 'Computer Engineering' 몸무게의 평균 / 평균보다 무거운 사람
SELECT *
FROM student ss
WHERE ss.weight > (SELECT AVG(weight)
                   FROM student s
                   JOIN department d
                   ON s. deptno1 = d.deptno
                   WHERE d.dname = 'Computer Engineering');

-- 전공: Electronic Engineering 학생들의 담당교수.
SELECT *
FROM professor pp
      -- 가져올 값이 하나가 아닐때 IN 사용
WHERE pp.profno IN (SELECT p.profno
                    FROM professor p
                    JOIN student s
                    ON p.profno = s.profno
                    JOIN department d
                    ON s.deptno1 = d.deptno
                    WHERE d.dname = 'Electronic Engineering');
                    
-- 담당교수 급여(pay)의 평균이상을 교수번호, 이름 확인.
SELECT p.profno
      ,p.name
FROM professor p
WHERE P.pay >= (SELECT AVG(pp.pay)
                FROM professor pp);
                
-- 보너스가 없는 사람중 제일 먼저 입사한 사람보다 먼저 입사한 사람
SELECT *
FROM professor;

SELECT pp.*
FROM professor pp
WHERE hiredate <
(SELECT MIN(P.hiredate)
FROM professor P
WHERE bonus IS NULL);

-- 보너스가 없는 사람들중에 월급 > 보너스가 있는 사람들 중에 월급 => 월급 10% 인상
SELECT p.*
      ,p.pay + p.pay*0.1
FROM professor p
WHERE pay + bonus <
(SELECT MAX(pp.pay)
FROM professor pp
WHERE bonus IS NULL);

UPDATE professor p
SET p.pay = p.pay + p.pay*0.1
WHERE pay + bonus <
(SELECT MAX(pp.pay)
FROM professor pp
WHERE bonus IS NULL);
-------------------------
SELECT * FROM emp;

SELECT * FROM dept;

-- view
CREATE OR REPLACE VIEW emp_dept_v
AS
SELECT empno, ename, job, sal, e.deptno, dname, comm
FROM emp e
JOIN dept d
ON e.deptno = d.deptno;

SELECT *
FROM emp_dept_v;

CREATE OR REPLACE VIEW emp_v
AS
SELECT empno, ename, job, deptno
FROM emp;

-- 뷰는 조회 용도로만 업데이트로는 사용하지 말기
UPDATE emp_v
SET ename = ''
   ,deptno = ''
WHERE empno = '9999';

SELECT * FROM tab;

SELECT v.*
FROM stud_prof_v v
JOIN department d
ON v.deptno = d.deptno
WHERE position = 'a full professor';

-- 학생, 담당교수 정보 뷰.
CREATE OR REPLACE VIEW stud_prof_v AS
SELECT s.studno
      , s.name studname
      , s.birthday, tel
      , s.deptno1 deptno
      , p.profno
      , p.name profname
      , p.position
      , p.email
FROM student s
LEFT OUTER JOIN professor p
ON s.profno = p.profno;

SELECT profno, name, position, email
FROM professor;

SELECT e.*, d.* 
FROM emp e
JOIN dept d
ON e.deptno = d.deptno
WHERE ename = DECODE('ALL', 'ALL', ename, 'ALL')
AND job = DECODE('CLERK', 'ALL', job, 'CLERK')
AND d.deptno = DECODE('-1', -1, d.deptno, -1);

CREATE TABLE board_t
(board_no NUMBER(5) PRIMARY KEY
, title VARCHAR2(100) NOT NULL
, content VARCHAR2(1000) NOT NULL
, writer VARCHAR2(50) NOT NULL
, write_date DATE DEFAULT SYSDATE
, likes NUMBER(3) DEFAULT 0
);

-- 1, 게시판 글연습, 게시판이 잘 되는지 연습합니다, 홍길동
-- 2, 두더지게시판, 두더지는 무섭습니다, 김길동
-- 3, sql재밌네, sql중에 join은 어렵지만 재밌네요, 박석민
-- 4, 삭제는 어떻게 해요, delete from 테이블 where 조건절, 고길동

DELETE FROM board_t;
SELECT * FROM board_t;

INSERT INTO board_t(board_no, title, content, writer)
VALUES(board_t_seq.nextval , '게시판 글연습', '게시판이 잘 되는지 연습합니다', '홍길동');
INSERT INTO board_t(board_no, title, content, writer)
VALUES(board_t_seq.nextval , '두더지게시판', '두더지는 무섭습니다', '김길동');
INSERT INTO board_t(board_no, title, content, writer)
VALUES(board_t_seq.nextval , 'sql재밌네', 'sql중에 join은 어렵지만 재밌네요', '박석민');
INSERT INTO board_t(board_no, title, content, writer)
VALUES(board_t_seq.nextval , '삭제는 어떻게 해요', 'delete from 테이블 where 조건절', '고길동');

-- 시퀀스 사용.
CREATE SEQUENCE board_t_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
MINVALUE 1
--CYCLE
;
DROP SEQUENCE board_t_seq;
SELECT board_t_seq.nextval FROM dual;

SELECT MAX(board_no)+1 FROM board_t;

SELECT MAX(board_no) FROM board_t;

ALTER TABLE board_t         -- 데이터 크기 변경
MODIFY board_no NUMBER(10);

INSERT INTO board_t(board_no, title, content, writer)
SELECT board_t_seq.nextval, title, content, writer
FROM board_t;

