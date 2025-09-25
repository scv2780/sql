SELECT *
FROM TAB
;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'rrrr/mm/dd') AS "system"
      ,TO_CHAR(1234.5, '$099,99.99') AS "num"
FROM dual
;

SELECT empno
      ,ename
      ,job
      ,TO_CHAR(sal, '999,999') AS "salary"
FROM emp
;

SELECT *
FROM professor
WHERE hiredate >= TO_DATE('1990/01/01 09:00:00', 'rrrr/mm/dd hh24:mi:ss')
AND hiredate < TO_DATE('2000/01/01 00:00:00', 'rrrr/mm/dd hh24:mi:ss')
;

SELECT *
FROM emp
WHERE sal + NVL(comm, 0) >= 2000
;

SELECT name
      ,pay
      ,bonus
      ,pay * 12 + NVL(bonus, 0) AS "TOTAL"
FROM professor
WHERE deptno = 201
;

SELECT profno
      ,name
      ,NVL2(bonus, (pay*12) + bonus, (pay*12)) AS "total"
FROM professor
;

SELECT empno
      ,ename
      ,comm
      ,NVL2(comm, 'Exist', 'NULL') AS "NVL2"
FROM emp
WHERE deptno = 30
;

SELECT empno
      ,ename
      ,DECODE(job, 'SALESMAN', '영업부서', 
        DECODE(job, 'MANAGER', '관리부서', '기타부서')) AS "dept"
      ,job
FROM emp
;

SELECT name
      ,jumin
      ,DECODE(SUBSTR(jumin, 7, 1), 1, '남자', '여자') AS "Gender"
FROM student
;

SELECT name
      ,tel
      ,DECODE(SUBSTR(tel, 1, 2), 02, 'SEOUL',
        DECODE(SUBSTR(tel, 1, 3), 031, 'GYEONGGI',
        DECODE(SUBSTR(tel, 1, 3), 051, 'BUSAN',
        DECODE(SUBSTR(tel, 1, 3), 052, 'ULSAN',
        DECODE(SUBSTR(tel, 1, 3), 055, 'GYEONGNAM'))))) as "LOC"
FROM student
WHERE deptno1 = 101
;

SELECT name
      ,tel
      ,DECODE(SUBSTR(tel, 1, INSTR(tel, ')')-1), '02', 'SEOUL',
                                                 '031', 'GYEONGGI',
                                                 '051', 'BUSAN',
                                                 '052', 'ULSAN',
                                                 '055', 'GYEONGNAM', 'NULL') AS "LOC"
FROM student
WHERE deptno1 = 101
;

SELECT name
      ,tel
      ,CASE SUBSTR(tel, 1, INSTR(tel, ')')-1) WHEN '02' THEN 'SEOUL'
                                              WHEN '031' THEN 'GYEONGGI'
                                              WHEN '051' THEN 'BUSAN'
                                              WHEN '052' THEN 'ULSAN'
                                              WHEN '055' THEN 'GYEONGNAM'
                                              ELSE '기타' 
       END AS "LOC"
FROM student
WHERE deptno1 = 101
;

SELECT profno
      ,name
      ,position
      ,CASE WHEN pay * 12 > 5000 THEN 'High'
            WHEN pay * 12 > 4000 THEN 'Mid'
            WHEN pay * 12 > 3000 THEN 'Low'
            ELSE 'Etc'
       END AS "Sal"
FROM professor
WHERE CASE WHEN pay * 12 > 5000 THEN 'High'
            WHEN pay * 12 > 4000 THEN 'Mid'
            WHEN pay * 12 > 3000 THEN 'Low'
            ELSE 'Etc'
       END = 'High'
;

SELECT empno
      ,ename
      ,sal
      ,CASE WHEN sal > 4000 THEN 'LEVEL 5'
            WHEN sal > 3000 THEN 'LEVEL 4'
            WHEN sal > 2000 THEN 'LEVEL 3'
            WHEN sal > 1000 THEN 'LEVEL 2'
            WHEN sal > 0 THEN 'LEVEL 1'
       END AS "LEVEL"
FROM emp
;

SELECT *
FROM department
;

SELECT profno
      ,name
      ,'professon'
      ,pay
FROM professor
WHERE deptno = 101
UNION
SELECT studno
      ,name
      ,'Student'
      ,0
FROM student
WHERE deptno1 = 101
;


SELECT MIN(job)
       ,COUNT(*) "인원"
       ,SUM(sal) as "직무 급여 합계"
       ,AVG(sal) AS " 급여 평균"
       ,STDDEV(sal) AS "분산"
FROM emp
GROUP BY job
;

SELECT TO_CHAR(hiredate, 'rrrr') AS "HD"
      ,COUNT(*) AS "인원"
FROM emp
GROUP BY TO_CHAR(hiredate, 'rrrr')
;

-- 학생, 학과별 인원.
SELECT deptno1
      ,COUNT(*) AS "인원"
FROM student
GROUP BY deptno1
HAVING COUNT(*) > 2
;

--교수, position, pay합계, 최고급여, 최저급여 출력.
SELECT position
      ,SUM(pay) AS "합계"
      ,MAX(pay) AS "최고급여"
      ,MIN(pay) AS "최저급여"
FROM professor
GROUP BY position
;

--사원, 부서별 평균급여, 인원.
SELECT deptno
      ,NULL
      ,ROUND(AVG(sal))
      ,COUNT(*)
      ,'a'
FROM emp
GROUP BY deptno
UNION
-- 사원, 부서, 직무별 평균급여, 인원.
SELECT deptno
      ,job
      ,ROUND(AVG(sal))
      ,COUNT(*)
      ,'b'
FROM emp
GROUP BY deptno, job
UNION
-- 사원, 평균급여, 인원.
SELECT NULL
      ,NULL
      ,ROUND(AVG(sal))
      ,COUNT(*)
      ,'c'
FROM emp
ORDER BY 1, 2
;

SELECT DECODE(NVL(deptno, 999), 999, '전체', deptno) AS "부서"
      ,NVL(job, '합계') AS "직무"
      ,ROUND(AVG(sal)) AS "평균급여"
      ,COUNT(*) AS "사원수"
FROM emp
GROUP BY ROLLUP(deptno, job) -- 롤업과 비슷한 CUBE 다른 합계도 보여줌
ORDER BY 1, 2
;

SELECT COUNT(*) FROM emp; -- 12
SELECT COUNT(*) FROM dept; -- 4

SELECT COUNT(*) -- 48
FROM emp, dept
;

SELECT dept.*, emp.*
FROM emp
JOIN dept
ON emp.deptno = dept.deptno
;

SELECT studno
      ,S.name AS "학생명"
      ,S.grade
      ,P.name AS "교수명"
      ,S.deptno1
      ,D.dname AS "학과명"
FROM student S--교수번호
LEFT OUTER JOIN professor P
ON S.profno = P.profno
JOIN department D
ON S.deptno1 = D.deptno
;

SELECT P.profno, P.name, S.studno, S.name, S.profno AS "담당교수"
FROM student S RIGHT OUTER JOIN professor p
ON P.profno = s.profno
;

SELECT *
FROM student
;

SELECT *
FROM salgrade
;

SELECT S.grade, E.*
FROM emp E
JOIN salgrade S
ON E.sal >= S.losal
AND E.sal <= S.hisal
AND S.grade = 1 -- WHERE 도 가능
;

-- 오라클 조인
SELECT E.*, D.*
FROM emp E, dept D
WHERE E.deptno = D.deptno
;

SELECT e1.empno AS "사원번호"
      ,e1.ename AS "사원명"
      ,e2.empno AS "관리자번호"
      ,e2.ename AS "관리자명"
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno(+)
;

SELECT s.name
      ,deptno1
      ,d.dname
FROM student s
JOIN department d
ON s.deptno1 = d.deptno
;

SELECT s.name
      ,deptno1
      ,d.dname
FROM student s, department d
WHERE s.deptno1 = d.deptno
;

SELECT e.name
      ,p.position
      ,e.pay
      ,p.s_pay AS "Low Pay"
      ,p.e_pay AS "High Pay"
FROM emp2 e
JOIN p_grade p
ON e.position = p.position
;

SELECT e.name
      ,SUBSTR(SYSDATE, 1, 4) - SUBSTR(e.birthday, 1, 4)-12 AS "AGE"
      ,e.position
      ,P.position
FROM emp2 e
JOIN p_grade p
ON SUBSTR(SYSDATE, 1, 4) - SUBSTR(e.birthday, 1, 4)-12 >= s_age
AND SUBSTR(SYSDATE, 1, 4) - SUBSTR(e.birthday, 1, 4)-12 <= e_age
ORDER BY 2
;

SELECT c.gname
      ,c.point
      ,g.gname
FROM customer c
JOIN gift g
ON c.point >= g.g_start
AND g.gname = 'Notebook'
;

SELECT *
FROM customer
;

SELECT *
FROM gift
;