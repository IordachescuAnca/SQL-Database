--1--
SELECT e.first_name || ' ' || e.last_name || ' castiga ' || e.salary || ' lunar, dar doreste ' || e.salary * 3 || ' mai mare ' AS "Salariu ideal"
FROM employees e;

SELECT CONCAT(e.first_name, CONCAT(' ', CONCAT(e.last_name, CONCAT(' castiga ', CONCAT(e.salary, CONCAT(' lunar, dar doreste ', CONCAT(e.salary * 3, ' mai mare '))))))) AS "Salariu ideal"
FROM employees e;

--2--
SELECT INITCAP(e.first_name) AS "Prenume",
       UPPER(e.last_name) AS "Nume",
       LENGTH(e.last_name) AS "Nr. Litere Nume"
FROM employees e
WHERE LOWER(e.last_name) LIKE 'j%' OR 
      LOWER(e.last_name) LIKE 'm%' OR
      LOWER(e.last_name) LIKE '__a%'
ORDER BY LENGTH(e.last_name) DESC;

SELECT INITCAP(e.first_name) AS "Prenume",
       UPPER(e.last_name) AS "Nume",
       LENGTH(e.last_name) AS "Nr. Litere Nume"
FROM employees e
WHERE UPPER(SUBSTR(e.last_name, 1, 1)) IN ('M', 'J') OR
      UPPER(SUBSTR(e.last_name, 3, 1)) = 'A'
ORDER BY LENGTH(e.last_name) DESC;

--3--
SELECT e.employee_id,
       e.last_name,
       e.first_name,
       e.department_id
FROM employees e
WHERE TRIM(BOTH ' ' FROM LOWER(e.first_name)) = 'steven';

--4--
SELECT e.first_name,
       e.last_name,
       e.employee_id,
       LENGTH(e.last_name) AS "Nr.litere Nume",
       INSTR(LOWER(e.last_name), 'a') AS "Pozitie a"
FROM employees e
WHERE LOWER(e.last_name) LIKE '%e';

--5--
SELECT e.last_name,
       e.first_name
FROM employees e
WHERE MOD(CEIL(sysdate - e.hire_date), 7) = 0;

--6--
SELECT e.employee_id,
       e.last_name,
       e.salary,
       ROUND(e.salary * 1.15, 2) AS "Salariu marit cu 15%",
       ROUND(e.salary * 1.15/100, 2) AS "Numar sute"
FROM employees e
WHERE MOD(e.salary, 1000) <> 0;

--7--
SELECT e.last_name AS "Nume angajat",
       RPAD(TO_CHAR(e.hire_date), 18, ' ') AS "Data angajatii"
FROM employees e;

--8--
SELECT TO_CHAR(sysdate + 30, 'MON-DD-YYYY HH:MI:SS') AS "Data peste 30 zile"
FROM dual;

--9--
SELECT ROUND(TO_DATE(CONCAT('31-DEC-', TO_CHAR(sysdate, 'YYYY'))) - sysdate) AS "Nr. zile pana pe 31 DEC"
FROM dual;

--10--

--a--
SELECT TO_CHAR(sysdate + 0.5, 'MON-DD-YYYY HH:MI:SS') AS "Data peste 12h"
FROM dual;

--b--
SELECT TO_CHAR(sysdate + 1/(24*12), 'MON-DD-YYYY HH:MI:SS') AS "Data peste 5 minute"
FROM dual;

--11--
SELECT e.last_name || ' ' || e.first_name AS "Nume",
       e.hire_date,
       NEXT_DAY(ADD_MONTHS(e.hire_date, 6), 'MONDAY') AS "Data negocierii"
FROM employees e;

--12--
SELECT e.last_name,
       ROUND(MONTHS_BETWEEN(sysdate, e.hire_date)) AS "Luni lucrate"
FROM employees e
ORDER BY MONTHS_BETWEEN(sysdate, e.hire_date);

--13--
SELECT e.last_name,
       e.hire_date, 
       TO_CHAR(e.hire_date, 'DAY') AS "Zi"
FROM employees e
ORDER BY TO_NUMBER(TO_CHAR(e.hire_date, 'D'));


--14--
SELECT e.last_name,
       e.first_name,
       NVL(TO_CHAR(e.commission_pct), 'Fara comision') AS "Comision"
FROM employees e;

--15--
SELECT e.last_name,
       e.first_name,
       e.commission_pct
FROM employees e
WHERE e.salary + NVL(e.commission_pct, 0) * e.salary > 10000;

--16--
SELECT e.last_name,
       e.first_name,
       e.salary,
       e.job_id,
       DECODE(UPPER(e.job_id),'IT_PROG',0.2,'SA_REP',0.25, 'SA_MAN', 0.35, 0) * e.salary + e.salary AS "Salariu renegociat"
FROM employees e;

--17--
SELECT e.last_name,
       e.first_name,
       d.department_id,
       d.department_name
FROM employees e
JOIN departments d ON d.department_id = e.department_id;

--18--
SELECT DISTINCT j.job_title
FROM jobs j
JOIN employees e ON e.job_id = j.job_id
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id = 30;

--19--
SELECT e.last_name,
       e.first_name,
       d.department_name,
       l.city
FROM employees e
JOIN departments d ON e.department_id = e.department_id
JOIN locations l ON d.location_id = d.location_id
WHERE e.commission_pct IS NOT NULL;

--20--
SELECT e.last_name,
       e.first_name,
       d.department_name
FROM employees e
JOIN departments d ON e.department_id = e.department_id
WHERE LOWER(e.last_name) LIKE '%a%';

--21--
SELECT e.last_name, 
       j.job_id,
       d.department_id,
       d.department_name
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
WHERE LOWER(l.city)='oxford';

--22--
SELECT e.employee_id AS "ANG#",
       e.last_name AS "Angajat",
       e.manager_id AS "MGR#",
       e1.last_name AS "Manager"
FROM employees e
JOIN employees e1 ON e.manager_id = e1.employee_id;

--23--
SELECT e.employee_id AS "ANG#",
       e.last_name AS "Angajat",
       e.manager_id AS "MGR#",
       e1.last_name AS "Manager"
FROM employees e
LEFT OUTER JOIN employees e1 ON e.manager_id = e1.employee_id;

--24--
SELECT e.last_name, 
       e.department_id,
       e1.last_name AS "Coleg"
FROM employees e
JOIN employees e1 ON e.department_id = e1.department_id
WHERE e.employee_id <> e1.employee_id;

--25--
SELECT e.last_name,
       j.job_id,
       j.job_title,
       d.department_name
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
JOIN departments d ON d.department_id = e.department_id;

--26--
SELECT e.last_name,
       e.first_name,
       e.hire_date
FROM employees e
JOIN employees e1 ON e.hire_date > e1.hire_date
WHERE LOWER(e1.last_name) = 'gates';

--27--
SELECT e.last_name AS "Angajat",
       e.hire_date AS "Data_ang",
       e1.last_name AS "Manager",
       e1.hire_date AS "Data_mgr"
FROM employees e
JOIN employees e1 ON (e.hire_date < e1.hire_date AND e1.employee_id = e.manager_id);