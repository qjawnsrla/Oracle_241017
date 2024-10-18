-- 조인 : 여러 테이블을 하나의 테이블처럼 사용하는 것
-- 이 때 필요한 것 PK (Primary Key)와 테이블 간 공통값인 FK(Foreign Key)를 사용
-- Join의 종류
-- Inner Join (동등 조인) : 두 테이블에서 일치하는 데이터만 선택
-- Left Join : 왼쪽 테이블의 모든 데이터와 일치하는 데이터 선택
-- Right Join : 오른쪽 테이블의 모든 데이터와 일치하는 데이터 선택
-- Full Outer Join : 두 테이블의 모든 데이터를 선택

-- 카테시안 곱
SELECT *
FROM emp, dept
ORDER BY empno;

-- 등가 조인 : 일치하는 열이 존재, Inner 조인이라도 함, 가장 일반적인 조인방식
-- 오라클 조인 방식 
SELECT empno, ename, job, sal, deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY empno;

-- ANSI 조인
SELECT empno, ename, job, sal, e.deptno
FROM emp e JOIN dept D
ON e. deptno = d.DEPTNO
ORDER BY empno;

-- DEPT 테이블과 emp 테이블은 1:N 관계를 가짐 (부서 테이블의 부서번호에는 여러명의 사원이 올 수 있음)
-- 조인에서 출력범위 설정하기
SELECT empno, ename, sal, d.deptno, dname, loc
FROM emp e JOIN dept D
ON e.DEPTNO = d.DEPTNO 
WHERE sal >= 3000;

-- EMP 테이블 별칭을 E로, DEPT 테이블 별칭은 D로 하여 다음과 같이 등가 조인을 했을 때 급여가 2500 이하이고 사원번호가 9999 이하인 사원의 정보가 출력되도록 작성
-- 오라클 조인이나 ANSI 조인 아무거나 사용
SELECT *
FROM EMP e JOIN DEPT d
ON e.DEPTNO = d.deptno
WHERE e.sal <= 2500 AND e.empno <= 9999
ORDER BY empno;

-- 비등가 조인 : 동일한 칼럼이 존재하지 않는 경우 조인할 떄 사용, 일반적인 방식은 아님
SELECT * FROM SALGRADE;		-- 각 급여에 대한 등급 표시

SELECT ename, sal, grade
FROM emp e JOIN SALGRADE s 
ON sal BETWEEN s.LOSAL AND s.HISAL;		-- 급여와 losal ~ hisal 비등가 조인

-- 자체 조인 (SELF JOIN) : 자기 자신의 테이블 조인하는 것을 말함 (같은 테이블을 두 번 사용)
SELECT e1.empno AS "사원 번호", e1.ename AS "사원 이름",
	e2.empno AS "상관 사원번호",
	e2.ename AS "상관 이름",
FROM EMP e1 JOIN EMP e2
ON e1.mgr = e2.empno;

-- 외부 조인 (Outer Join) : Left, Right, Full
SELECT e.ename, e.deptno, d.dname
FROM EMP e JOIN DEPT d
e.deptno= d.DEPTNO
ORDER BY e.deptno;

SELECT e.ename, e.deptno, d.dname
FROM EMP e LEFT OUTER JOIN DEPT d
e.deptno= d.DEPTNO
ORDER BY e.deptno;

-- NATURL JOIN : 등가 조인과 비슷하지만 WHERE 조건절 없이 사용
-- 두 테이블의 동일한 이름이 있는 열을 자동으로 찾아서 조인해줌
SELECT empno, ename, deptno, dname
FROM emp e NATURAL JOIN dept d;

-- JOIN ~ USING : 등가 조인을 대신하는 조인 방식
SELECT empno, ename, job, deptno, dname, loc
FROM EMP e JOIN DEPT d USING(deptno)
ORDER BY e.empno;

-- Q1. 급여가 2000 초과인 사원들의 정보 출력(부서번호, 부서이름, 사원번호, 사원이름, 급여)
-- JOIN ~ ON, NATURAL JOIN, JOIN ~ USING 아무거나 사용
SELECT deptno, dname, empno, ename, sal
FROM EMP e NATURAL JOIN dept d
WHERE sal > 2000;


-- Q2. 각 부서별 평균 급여, 최대급여, 최소급여, 사원수 출력
-- (부서번호, 부서이름, 평균 급여, 최대 급여, 최소 급여, 사원 수)
SELECT deptno AS "부서번호",
	dname AS "부서이름",
	ROUND(AVG(sal)) AS "평균 급여",
	MAX(sal) AS "최대 급여",
	MIN(sal) AS "최소 급여",
	COUNT(*) AS "사원 수"
FROM EMP e JOIN DEPT D
ON e.DEPTNO = d.DEPTNO 
GROUP BY d.deptno, d.dname;



-- Q3. 모든 부서 정보와 사원정보 출력 (부서번호와 부서이름순으로 정렬), 모든 부서가 나와야 함
SELECT *
FROM EMP e RIGHT OUTER JOIN DEPT D
ON e.DEPTNO = d.DEPTNO
ORDER BY d.DEPTNO, d.DEPTNO;










