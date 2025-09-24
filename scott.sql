SELECT *
FROM student;

CHAR(2000)     -- 크기가 변하지 않는 것을 담을 떄
VARCHAR2(4000)
NUMBER(10,2)

SELECT 1 + '2' -- 오라클은 자동 형변환
FROM dual
;

SELECT NAME || '''s ID: ' || ID || ' , WEIGHT is ' || WEIGHT || 'kg' AS "IDAND WEIGHT"
FROM student;

SELECT *
FROM emp;

SELECT ename || '(' || JOB || '), ' || ename || '''' || JOB || '''' AS "NAME AND JOB"
from emp;

SELECT ename || '''s sal is $' || sal AS "Name And Sal"
FROM emp;

-- 조건절.
SELECT empno
      ,ename
      ,job
      ,mgr
      ,hiredate
      ,sal + comm as "Salary"
      --,comm
      ,deptno
      
FROM emp
WHERE empno < '8000'
AND empno >= '7900'
AND hiredate LIKE '82%'
;

SELECT *
FROM professor
WHERE pay + nvl (bonus, 0) >= 300
;

SELECT profno
      ,LOWER(name) AS "low_name"
      ,UPPER(id) AS "upp_id"
      ,INITCAP(position) AS "pos"
      ,pay
      ,CONCAT(CONCAT(name, '-'), id) AS "name_id"
FROM professor
WHERE LENGTH(name) <> 10
;

SELECT name
      ,LENGTH(name) AS "length"
      ,LENGTHB('홍길동') AS "lengthb"
      ,SUBSTR(name, 1, 5) AS "substr"
      ,INSTR(name, 'a') AS "instr"
      ,pay
      ,bonus
      ,LTRIM(LPAD(id, 10, '.'), '.') AS "lpad"
      ,RTRIM('    Hello, World    ') AS "str"
      ,REPLACE('Hello', 'H', 'h') AS "replace"
FROM professor
WHERE INSTR(UPPER(name), 'A') > 0
;

SELECT name
      ,tel
      ,SUBSTR(tel, 1, instr(tel,')')-1) AS "AREA CODE"
      ,INSTR(tel,')')-1 AS "val"
FROM student
WHERE deptno1 = '201'
;

SELECT *
FROM emp
;

SELECT ename
      ,REPLACE(ename, SUBSTR(ename,2,2), '--') "REPLACE"
FROM emp
;

SELECT *
FROM student
;

SELECT name
      ,jumin
      ,REPLACE(jumin, SUBSTR(jumin,7,7), '-/-/-/-') "REPLACE"
FROM student
;

SELECT name
      ,tel
      ,REPLACE(tel, SUBSTR(tel, INSTR(tel, ')')+1, 
        INSTR(tel, '-')-(INSTR(tel, ')')+1)), '***') "REPLACE"
FROM student
WHERE deptno1 = '102'
;

SELECT name
      ,tel
      ,REPLACE(tel, SUBSTR(tel, INSTR(tel, '-')+1, 4), '****') "REPLACE"
FROM student
WHERE deptno1 = '101'
;

SELECT empno
      ,ename
      ,job
      ,ROUND(sal / 12, 2) AS "month"
      ,TRUNC(sal / 12, 2) AS "trunc"
      ,MOD(sal, 12) AS "mod"
      ,CEIL(sal / 12) AS "ceil"
      ,FLOOR(sal / 12) AS "floor"
      ,POWER(4, 2) AS "power"
FROM emp
;

SELECT MONTHS_BETWEEN('16/01/01', '12/01/01')
FROM dual
;

SELECT ADD_MONTHS(SYSDATE, 2)
      ,NEXT_DAY(SYSDATE+1, '목') AS "next_day"
      ,LAST_DAY(ADD_MONTHS(SYSDATE, 1)) AS "last"
FROM dual
;

SELECT SYSDATE
      ,TO_CHAR(SYSDATE, 'rrrr-mm-dd hh24:mi:ss') AS "today"
FROM dual
WHERE 1=1
;

SELECT TO_DATE('2025-05-05', 'rrrr-mm-dd hh24') AS "date"
FROM dual
;