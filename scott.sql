SELECT empno
      ,ename
      ,job
      ,mgr
FROM emp; -- 보통 대문자로 칼럼은 소문자 이 규칙을 따른다

select * from emp; -- 급할때는 그냥 소문자

-- 표현식 사용.
SELECT empno AS "사원번호" -- 별칭(alias) as 뒤에 ""
      ,ename "사원이름" -- as 없어도 됌
      ,'Good Morning !! ' || ename AS "welcome 메세지"
      ,ename ||'''s 의 급여' || sal AS "급여" -- kim's salary
FROM emp;

-- DISTINCT 중복된 값 제거
SELECT DISTINCT job, deptno
FROM emp
ORDER BY job DESC; -- ORDER BY는 정렬 DESC 역순

