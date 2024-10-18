 -- 다중행 함수 : 여러 행에 대해서 함수가 적용되어 하나의 결과를 나타내는 함수
 
 SELECT deptno, empno, sum(sal)
 FROM emp
 GROUP BY DEPTNO;

-- 다중행 함수의 종류
-- SUM() : 지정한 데이터의 합을 반환
-- COUNT() : 지정한 데이터의 개수를 반환
-- MAX() : 최대값 반환
-- MIN() : 최소값 반환
-- AVG() : 평균값 반환

SELECT SUM(DISTINCT sal), SUM(sal)
FROM emp;

-- 모든 사원에 대해서 급여와 추가 수당의합을 구하기
SELECT sum(sal), sum(comm)
FROM emp;

-- 20번 부서의 모든 사원에 대해서 급여와 추가수당의 합을 구하기
SELECT sum(sal), sum(comm), DEPTNO
FROM EMP
GROUP BY deptno;

-- 각 직책별로 급여와 추가 수당의 합 구하기
SELECT job AS "직책", sum(sal) AS "급여", sum(comm) AS "성과급"
FROM EMP
GROUP BY job;

-- 각 부서별 최대(MAX) 급여를 출력하기
SELECT max(sal), deptno
FROM emp
GROUP BY DEPTNO;

-- GROUP BY 없이 출력하려면?
SELECT max(sal) FROM emp WHERE deptno = 10;
SELECT max(sal) FROM emp WHERE deptno = 20;
SELECT max(sal) FROM emp WHERE deptno = 30;

-- 부서번호가 20인 사원 중 가장 최근 입사자 출력하기
SELECT max(hiredate)
FROM EMP
WHERE DEPTNO = 20;

-- 서브쿼리 사용하기 : 각 부서별 최대 (MAX) 급여 출력하는데 사원번호, 이름, 직책, 부서번호 출력
SELECT max(sal), deptno
FROM EMP
GROUP BY deptno;

SELECT max(sal)
	FROM emp e2
	WHERE e2.deptno = 10;

SELECT empno, ename, job, deptno
FROM emp e
WHERE sal = (
	SELECT max(sal)
	FROM EMP e2
	WHERE e2.deptno = e.DEPTNO
);

SELECT empno, ename, job, deptno
FROM emp e
WHERE sal = (
	SELECT max(sal)
	FROM EMP e2
	WHERE e2.job = e.job
);

-- HAVING 절 : 그룹화된 대상에 대한 출력제한
-- GROUP BY 존재할 때만 사용할 수 있음
-- WHERE 조건절과 동일하게 동작하지만, 그룹화된 결과 값의 범위를 제한할 때 사용
SELECT deptno, job, avg(sal)
FROM emp
GROUP BY DEPTNO, JOB
	HAVING AVG(sal) >= 2000
ORDER BY DEPTNO;

-- WHERE절과 HAVING절 함께 사용하기
SELECT deptno, job, avg(sal)	-- 순서 5. 출력할 열 제한
FROM EMP				-- 순서 1. 먼저 테이블을 가져
WHERE sal <= 3000		-- 순서 2. 급여 기준으로 행을 제한함
GROUP BY deptno, job	-- 순서 3. 부서별 직책별 그룹화 진행
	HAVING avg(sal) >= 2000		-- 순서 4. 그룹 내에서 출력제
ORDER BY deptno, job;	-- 순서 6. 그룹별 직책별 오름차순 정렬

-- HAVING절을 사용하여 EMP 테이블의 부서별 직책의 평균 급여가 500 이상인 사원들의 부서번호, 직책, 부서별 직책의 평균 급여가 출력
SELECT deptno, job, avg(sal)
FROM EMP
GROUP BY deptno, JOB
	HAVING avg(sal) >= 500
ORDER BY deptno, job;

--Q2. EMP 테이블을 이용하여 부서번호, 평균급여, 최고급여, 최저급여, 사원수를 출력 단, 평균급여 출력 시 소수점 제외하고 부서번호 별로 출력
SELECT deptno, 
	TRUNC(avg(sal),0) AS "평균급여",
	max(sal) AS "최고급여",
	min(sal) AS "최저급여",
	COUNT(*) AS "사원수"
	FROM EMP
	GROUP BY DEPTNO
	ORDER BY deptno;

--Q3. 같은 직책에 종사하는사원이 3명 이상인 직책과 인원을 출력
SELECT job,
	COUNT(*) AS "인원"
	FROM EMP
	GROUP BY job
		HAVING COUNT(*) >= 3
	ORDER BY job;

--Q4. 사원들의 입사 연도를 기준으로 부서별로 몇 명이 입사했는지 출력
SELECT deptno, 
       EXTRACT(YEAR FROM hiredate) AS "입사연도", 
       COUNT(*) AS "인원"
FROM EMP
GROUP BY deptno, EXTRACT(YEAR FROM hiredate)
ORDER BY deptno, "입사연도";

--Q5. 추가 수당을 받는 사원 수와 받지 않는 사원수를 출력 (O , X 로 표기 필요)
-- 추가 수당 | 사원수
--    X		  8
--    O		  4
SELECT NVL2(comm, 'O', 'X') AS "추가수당",
	COUNT(*) AS "사원수"
FROM EMP
GROUP BY NVL2(comm, 'O', 'X');

SELECT 
	CASE
		WHEN comm IS NULL THEN 'X'
		WHEN comm = 0 THEN 'X'
		ELSE 'O'
	END AS "추가수당",
	COUNT(*) AS "사원수"
FROM EMP
GROUP BY CASE 
		WHEN comm IS NULL THEN 'X'
		WHEN comm = 0 THEN 'X'
		ELSE 'O'
	END
ORDER BY "추가수당";
	

--Q6. 각 부서의 입사연도별 사원 수, 최고급여, 급여 합, 평균급여를 출력
SELECT deptno,
	EXTRACT (YEAR FROM hiredate) AS "입사년도",
	count(*) AS "사원수",
	MAX(sal) AS "최고급여",
	SUM(sal) AS "합계",
	ROUND(avg(sal)) AS "평균급여"
	FROM EMP
	GROUP BY deptno, EXTRACT (YEAR FROM hiredate)
	ORDER BY "부서번호", "입사년도";


-- 그룹화 관련 기타 함수 : ROLLUP (그룹화 데이터의 합계를 출력할 떄 유용)
SELECT nvl(to_char(deptno), '전체부서') AS "부서번호",
	nvl(to_char(job), '부서별직책') AS "직책",
	COUNT(*) AS "사원수",
	max(sal) AS "최대급여",
	min(sal) AS "최소급여",
	round(avg(sal)) AS "평균급여"
FROM EMP
GROUP BY ROLLUP(deptno, job)
ORDER BY "부서번호", "직책";

-- 집합연산자 : 두개 이상의 쿼리 결과를 하나로 결합하는 연산자 (수직적 처리)
-- 여러개의 select 문을 하나로 연결하는 기능
-- 집합 연산자로 결합하는 결과의 칼럼은 데이터 타입이 동일해야 함
SELECT empno, ename, sal, deptno
FROM EMP 
WHERE DEPTNO = 10
UNION 
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 20
UNION 
SELECT empno, ename, sal, deptno
FROM EMP
WHERE DEPTNO = 30;

-- 교집합 : INTERSECT
-- 여러 개의 SQL문의 결과에 대한 교집합을 반환
SELECT empno, ename, sal
FROM emp
WHERE sal > 1000	-- 1001 ~

SELECT empno, ename, sal
FROM EMP
WHERE sal < 2000	--  ~ 1999

-- 차집합 : MINUS, 중복행에 대한 결과를 하나의 결과를 보여줌
SELECT empno, ename, sal
FROM EMP

SELECT empno, ename, sal
FROM emp
WHERE sal > 2000;




