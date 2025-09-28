-- 210p 1번 문제
SELECT * FROM emp;

SELECT MAX(sal + NVL(comm, 0))
      ,MIN(sal + NVL(comm, 0))
      ,TRUNC(AVG(sal + NVL(comm, 0)), 1)
FROM emp
;
-- 210p 2번 문제
SELECT * FROM student;

SELECT COUNT(*) || 'EA' AS "TOTAL"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '01' , 1, NULL)) || 'EA' AS "JAN"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '02' , 1, NULL)) || 'EA' AS "FEB"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '03' , 1, NULL)) || 'EA' AS "MAR"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '04' , 1, NULL)) || 'EA' AS "APR"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '05' , 1, NULL)) || 'EA' AS "MAY"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '06' , 1, NULL)) || 'EA' AS "JUN"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '07' , 1, NULL)) || 'EA' AS "JUL"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '08' , 1, NULL)) || 'EA' AS "AUG"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '09' , 1, NULL)) || 'EA' AS "SEP"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '10' , 1, NULL)) || 'EA' AS "OCT"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '11' , 1, NULL)) || 'EA' AS "NOV"
      ,COUNT(DECODE(SUBSTR(birthday, 4, 2), '12' , 1, NULL)) || 'EA' AS "DEC"
FROM student
;

SELECT SUBSTR(birthday, 4, 2) AS "MM"
      ,COUNT(*) || 'EA' AS "EA"
FROM student
GROUP BY SUBSTR(birthday, 4, 2)
ORDER BY 1
;

WITH months AS(SELECT LPAD(LEVEL, 2, '0') AS "MM"
      FROM DUAL
      CONNECT BY LEVEL <= 12)
SELECT m.MM
      ,NVL(COUNT(s.birthday), 0) AS "EA"
FROM months m
LEFT JOIN student s
ON SUBSTR(s.birthday, 4, 2) = m.MM
GROUP BY m.MM
ORDER BY 1
;

