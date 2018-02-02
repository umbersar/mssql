USE SQLCookbook;

SELECT *, CAST(CONCAT(A.A,B.B) AS INT) + 1 AS NUM FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS A(A)  
CROSS JOIN (SELECT * FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS CP(A)) AS B(B)


--3.8
SELECT E.ENAME, D.LOC
FROM EMP AS E
INNER JOIN DEPT AS D ON D.DEPTNO = E.DEPTNO
WHERE E.DEPTNO=10

--3.7
SELECT * FROM (VALUES(1),(1),(2)) AS TBL(A) EXCEPT SELECT * FROM (VALUES(1),(2)) AS TBL2(A) 
SELECT * FROM (VALUES(1),(2)) AS TBL2(A) EXCEPT SELECT * FROM (VALUES(1),(1),(2)) AS TBL(A) 


SELECT BB0.CARDINALITY, BB.DATA
FROM
(	SELECT CASE WHEN COUNT(NUM) >1 THEN 'DIFFERENT CARDINALITY' ELSE 'SAME CARDINALITY' END AS CARDINALITY
	FROM (
	SELECT COUNT(*)
	FROM EMP AS E
	UNION
	SELECT COUNT(*)
	FROM DEPT AS D
	) AS B(NUM)
) AS BB0(CARDINALITY)
CROSS APPLY (
SELECT CASE WHEN COUNT(NUM) >1 THEN 'DIFFERENT DEPTNOs' ELSE 'SAME DEPTNOs' END AS [DATA]
FROM (
SELECT DEPTNO
FROM EMP AS E
INTERSECT
SELECT DEPTNO
FROM DEPT AS D
) AS B(NUM)
) AS BB([DATA])

--3.6
--IN-EFFICIENT AS TABLE DEPT WILL BE SCANNED AS MANY AS THE NUMBER OF ROWS IN EMP TABLE
SELECT E.EMPNO, (SELECT DEPT.DNAME FROM DEPT WHERE DEPT.DEPTNO = E.DEPTNO) AS [DEPTNO]
FROM EMP AS E

SELECT E.EMPNO, d.DNAME
FROM EMP AS E
INNER JOIN DEPT AS D ON D.DEPTNO = E.DEPTNO

--3.5
SELECT DEPT.*
FROM DEPT
LEFT OUTER JOIN EMP ON EMP.DEPTNO = DEPT.DEPTNO
WHERE EMP.EMPNO IS NULL

--3.4
SELECT *
FROM DEPT
WHERE DEPTNO NOT IN (SELECT DEPTNO FROM EMP);

SELECT V FROM (VALUES(1)) AS B(V)
WHERE V NOT IN (SELECT V FROM (VALUES(3),(4),(NULL)) AS D(V));
--1 NOT IN(3,4,NULL)
--NOT (1==3 OR 1==4 OR 1==NULL)
--NOT (FALSE AND FALSE AND UNKNOWN)
--TRUE AND TRUE AND UNKNOWN
--NOT TRUE

SELECT V FROM (VALUES(1)) AS B(V)
WHERE V IN (SELECT V FROM (VALUES(1),(NULL)) AS D(V));
--1 IN(1,NULL)
--(1==1 OR 1==NULL)
--TRUE OR UNKNOWN
--TRUE

SELECT V FROM (VALUES(1)) AS B(V)
WHERE NOT EXISTS (SELECT * FROM (VALUES(3),(4),(NULL)) AS D(V) WHERE D.V=B.V);

--2.7
SELECT ENAME, DEPTNO
FROM EMP
WHERE EMP.DEPTNO = 10
UNION ALL
SELECT '------', NULL
UNION ALL
SELECT DNAME, DEPTNO
FROM DEPT

select * from (values(1),(1),(2)) as tbl(a) union all select * from (values(2),(3)) as tbl2(a) 

--2.6
SELECT *
FROM EMP
ORDER BY CASE WHEN JOB = 'SALESMAN' THEN COMM ELSE SAL END, COMM;

--2.5
SELECT *
FROM EMP
ORDER BY CASE WHEN COMM IS NOT NULL THEN 0 ELSE 1 END, COMM;

SELECT *
FROM EMP
ORDER BY CASE WHEN COMM IS NOT NULL THEN 0 ELSE 1 END, COMM DESC;

SELECT *
FROM EMP
ORDER BY CASE WHEN COMM IS NOT NULL THEN 1 ELSE 0 END, COMM ;

SELECT *
FROM EMP
ORDER BY CASE WHEN COMM IS NOT NULL THEN 1 ELSE 0 END, COMM DESC;

--2.4
;WITH CTE AS
(SELECT CONCAT(E.ENAME, ' ', E.DEPTNO) AS D
FROM EMP AS E
)
,CTE2 AS (
SELECT *
FROM CTE AS C 
CROSS APPLY string_split(C.D, ' ') AS SP
)
,CTE3 AS
(
SELECT D, [0] AS DEPTNO, [1] AS [NAME]
FROM (SELECT CTE2.D, CTE2.value, CASE WHEN ISNUMERIC(CTE2.value) = 0 THEN 1 ELSE 0 END AS IsNumber FROM CTE2) AS BASE
PIVOT(MAX(BASE.VALUE) FOR IsNumber IN ([1],[0])) AS PVT
)
SELECT *
FROM CTE3
ORDER BY DEPTNO



SELECT JOB
FROM EMP AS E
group by JOB
ORDER BY max(sal)

SELECT E.ENAME
FROM EMP AS E
--ORDER BY 1-- THIS IS REFERRING THE COLUMN 1 IN THE SELECT LIST(E.ENAME), NOT THE COLUMN 1 FROM THE UNDERLYING TABLE AS THE OUTPUT OF SELECT IS INPUT OF ORDER BY
--ORDER BY E.JOB-- EVEN IF THE COLUMN IS NOT SELECT LIST WE CAN STILL REFER TO COLUMNS INT ROWSET THAT FORMS THE INPUT TO ORDER BY UNLESS DISTINCT IS USED IN SELECT
--ORDER BY (SELECT NULL)
--ORDER BY (SELECT 234 AS T)--can use any value here to get random records...
--ORDER BY (SELECT NEWID())--have a to use a value that changes each time it is called to get random values for each run AND THERE IS NO ORDER TO VALUES GENERATED
--ORDER BY (SELECT SYSDATETIME())--THERE IS AN IMPLICIT ORDER IN USING DATATIME VALUES. THE ORDER WILL REMAIN SAME FOR EACH RUN. SO THE ROWS FETCHED CANNOT BE GUURANTEED TO BE NOT THE SAME
ORDER BY NEWID()--THERE IS AN IMPLICIT ORDER IN USING DATATIME VALUES. THE ORDER WILL REMAIN SAME FOR EACH RUN. SO THE ROWS FETCHED CANNOT BE GUURANTEED TO BE NOT THE SAME
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

SELECT TOP(5) *
FROM EMP;

SELECT *
FROM EMP AS E
--ORDER BY (SELECT NULL)
ORDER BY (SELECT 234 AS T)--can use any value here to get random records...
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--SELECT 'TT' + NULL
SELECT CONCAT('TT', NULL)

