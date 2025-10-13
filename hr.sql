SELECT * FROM tab;

SELECT *
FROM employees; --> departments, jobs

SELECT *
FROM departments; --> locations

SELECT *
FROM locations; --> countries

SELECT *
FROM countries; --> regions

SELECT *
FROM regions;

SELECT *
FROM jobs;
----------------------------------------
SELECT e.employee_id
      ,e.first_name
      ,l.*
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
WHERE e.employee_id = '198'
;

SELECT e.employee_id
      ,e.first_name
      ,e.last_name
      ,l.street_address
      ,l.city
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
WHERE e.job_id = 'IT_PROG'
;

SELECT e.*
FROM departments d
JOIN employees e
ON d.manager_id = e.employee_id
WHERE e.employee_id = '103'
;

-- sal이 job의 급여에서 벗어난 사람 조회
-- JOIN으로
SELECT e.*
      ,j.min_salary
      ,j.max_salary
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
WHERE e.salary < j.min_salary
OR e.salary > j.max_salary
;

-- 서브쿼리, EXISTS로 JOIN
SELECT e.*
FROM employees e
WHERE NOT EXISTS (SELECT *
                  FROM jobs j
                  WHERE e.job_id = j.job_id
                  AND e.salary BETWEEN j.min_salary AND j.max_salary)
;
-- 시험
SELECT *
FROM employees; --> departments, jobs

SELECT *
FROM departments; --> locations

SELECT *
FROM locations; --> countries

SELECT *
FROM countries; --> regions

SELECT *
FROM regions;

SELECT *
FROM jobs;
-- 1번
SELECT employee_id
      ,last_name
      ,salary
      ,department_id
FROM employees
WHERE salary BETWEEN 7000 AND 12000
AND last_name LIKE 'H%'
;
-- 2번
SELECT employee_id
      ,last_name
      ,job_id
      ,salary
      ,department_id
FROM employees 
WHERE department_id BETWEEN 50 AND 60
AND salary > 5000
;
-- 3번
SELECT last_name
      ,salary
      ,CASE WHEN salary <= 5000 THEN salary + (salary*0.2)
            WHEN salary <= 10000 THEN salary + (salary*0.15)
            WHEN salary <= 15000 THEN salary + (salary*0.1)
            WHEN salary >= 15001 THEN salary
            END AS "SAL+"
FROM employees
WHERE :employee_id = employee_id
;
-- 4번
SELECT d.department_id
      ,d.department_name
      ,l.city
FROM departments d
JOIN locations l
ON d.location_id = l.location_id
;
-- 5번
SELECT e.employee_id
      ,e.last_name
      ,e.job_id
FROM employees e
WHERE e.department_id = (SELECT d.department_id
                         FROM departments d
                         WHERE department_name = 'IT')
;
-- 6번
SELECT *
FROM employees
WHERE hire_date < '2004/01/01'
AND job_id = 'ST_CLERK'
;
-- 7번
SELECT last_name
      ,job_id
      ,salary
      ,commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary
;
-- 8번
CREATE TABLE PROF
(PROFNO NUMBER(4)
,NAME VARCHAR2(15) NOT NULL
,ID VARCHAR2(15) NOT NULL
,HIREDATE DATE
,PAY NUMBER(4)
);
-- 9번
SELECT *
FROM prof
;

INSERT INTO prof (profno, name, id, hiredate, pay)
VALUES (1001, 'Mark', 'm1001', '07/03/01', 800);
INSERT INTO prof (profno, name, id, hiredate, pay)
VALUES (1003, 'Adam', 'a1003', '11/03/02', 0);

DELETE FROM prof
WHERE profno = 1003;
-- 10번
SELECT *
FROM prof
;

ALTER TABLE prof
ADD PRIMARY KEY(profno);

ALTER TABLE prof
ADD (GENDER VARCHAR2(3));

ALTER TABLE prof
MODIFY (name VARCHAR2(20));

-- 개인프로젝트
-- 계획 예)게시판: 로그인, 글쓰기, 글목록, 글수정...
--        테이블: 회원테이블, 게시판테이블...
--        테이블생성, 제약조건

-- 음악 추천 커뮤니티
-- 회원가입, 로그인, 글쓰기, 글목록, 글수정, 댓글
-- 회원 정보 테이블, 게시글 테이블, 댓글 테이블

-- 회원 정보 테이블: 회원 번호, 회원 ID, 회원 비밀번호, 닉네임, 이름, 전화번호, 이메일, 가입날짜
CREATE TABLE member_info (
    m_num NUMBER(20) CONSTRAINT m_num_pk PRIMARY KEY,
    m_id VARCHAR2(100) CONSTRAINT m_id_un UNIQUE NOT NULL,
    m_pw VARCHAR2(100) CONSTRAINT m_pw_nc NOT NULL,
    nickname VARCHAR2(100) CONSTRAINT nickname_un UNIQUE NOT NULL,
    m_name VARCHAR2(100) CONSTRAINT m_name_nn NOT NULL,
    m_tel VARCHAR2(50) CONSTRAINT m_tel_nn NOT NULL,
    m_email VARCHAR2(100) CONSTRAINT m_email_nn NOT NULL,
    m_date DATE DEFAULT SYSDATE
);

-- 게시글 테이블: 게시글 번호, 회원 번호, 제목, 게시글, 게시글 날짜
CREATE TABLE bulletin (
    b_num NUMBER(20) CONSTRAINT b_num_pk PRIMARY KEY,
    m_num NUMBER(20) REFERENCES member_info (m_num),  -- FK로 회원번호 참조
    b_title VARCHAR2(100) CONSTRAINT b_title_nn NOT NULL,
    b_write VARCHAR2(4000) CONSTRAINT b_write_nn NOT NULL,
    b_date DATE DEFAULT SYSDATE
);

-- 댓글 테이블: 댓글 번호, 게시글 번호, 회원 번호, 댓글, 댓글 날짜
CREATE TABLE comments (
    c_num NUMBER(20) CONSTRAINT c_num_pk PRIMARY KEY,
    b_num NUMBER(20) REFERENCES bulletin (b_num),     -- 게시글 참조
    m_num NUMBER(20) REFERENCES member_info (m_num),  -- 회원 참조
    c_write VARCHAR2(500) CONSTRAINT c_write_nn NOT NULL,
    c_date DATE DEFAULT SYSDATE
);
-- 좋아요 테이블: 좋아요 고유 번호, 게시물 번호, 회원 번호
CREATE TABLE likes (
    l_num NUMBER(20) CONSTRAINT l_num_pk PRIMARY KEY,  -- 좋아요 고유 번호
    b_num   NUMBER(20) REFERENCES bulletin(b_num) ON DELETE CASCADE, -- 어떤 게시글인지
    m_num   NUMBER(20) REFERENCES member_info(m_num) ON DELETE CASCADE, -- 누가 눌렀는지
    CONSTRAINT unique_like UNIQUE (b_num, m_num) -- 같은 사람이 같은 글에 한 번만
);

SELECT MAX(m_num) FROM member_info;
SELECT MAX(b_num) FROM bulletin;

CREATE SEQUENCE member_seq START WITH 3 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE bulletin_seq START WITH 5 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE likes_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE comments_seq START WITH 1 INCREMENT BY 1;


DROP SEQUENCE bulletin_seq;
DROP SEQUENCE member_seq;

INSERT INTO member_info(m_num, m_id, m_pw, nickname, m_name, m_tel, m_email, m_date)
VALUES(1, 'user01', '12345678', '길동이', '홍길동', '01012345678', 'asd@asdasd', SYSDATE);
INSERT INTO member_info(m_num, m_id, m_pw, nickname, m_name, m_tel, m_email, m_date)
VALUES(2, 'user02', '12345678', '준식이여', '구준식', '01023456789', 'qwe@qweqwe', SYSDATE);
INSERT INTO bulletin(b_num, m_num, b_title, b_write, b_date)
VALUES(1, 1, '첫번째 게시물이오', '테스트용이니 신경쓰지 마시오', SYSDATE);
INSERT INTO bulletin(b_num, m_num, b_title, b_write, b_date)
VALUES(2, 1, '두번째 게시물이오', '테스트용이니 신경쓰지 말라니깐', SYSDATE);
INSERT INTO bulletin(b_num, m_num, b_title, b_write, b_date)
VALUES(3, 2, '세번째 게시물이오', '저 양반이 원래 좀 이상하니 이해하시오', SYSDATE);
INSERT INTO bulletin(b_num, m_num, b_title, b_write, b_date)
VALUES(4, 2, '네번째 게시물이오', '그래도 애는 착해 아마', SYSDATE);

SELECT * FROM member_info;
SELECT * FROM bulletin;
SELECT * FROM comments;

DROP TABLE comments;
DROP TABLE bulletin;
DROP TABLE member_info;
DROP SEQUENCE member_seq;

SELECT b.b_num, m.m_num, m.nickname, b.b_title, b.b_write, b.b_date
FROM bulletin b
JOIN member_info m
ON b.m_num = m.m_num
;

INSERT INTO bulletin (b_num, m_num, b_title, b_write, b_date)
VALUES (bulletin_seq.NEXTVAL, )
;

ALTER TABLE bulletin
MODIFY(b_write VARCHAR2(4000));