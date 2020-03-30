--4--
SELECT *
FROM employees;

--5--
SELECT e.employee_id,
       e.last_name,
       e.first_name,
       e.job_id,
       e.hire_date
FROM employees e;

--6--
SELECT e.job_id
FROM employees e;

SELECT DISTINCT e.job_id
FROM employees e;

--7--
SELECT e.last_name || ' ' || e.first_name || '-' || e.job_id AS Info
FROM employees e;

--8--
SELECT e.employee_id || ', ' || e.last_name || ', ' || e.first_name || ', ' || e.email || ', ' || e.phone_number || ', ' || e.hire_date || ', '
       || e.job_id || ', ' || e.salary || ', ' || e.commission_pct || ', ' || e.manager_id || ', ' || e.department_id AS "Informatii complete"
FROM employees e;

--9--
SELECT e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE e.salary > 2850;

--10--
SELECT e.last_name,
       e.first_name,
       e.department_id
FROM employees e
WHERE e.employee_id = 104;

--11--
SELECT e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE e.salary NOT BETWEEN 1500 AND 2850;

--12--
SELECT e.last_name,
       e.first_name,
       e.job_id,
       e.hire_date
FROM employees e
WHERE e.hire_date BETWEEN '20-FEB-1987' AND '1-MAY-1989'
ORDER BY e.hire_date;

--13--
SELECT e.last_name,
       e.first_name,
       e.job_id
FROM employees e
WHERE e.department_id IN (10,30)
ORDER BY e.last_name;

--14--
SELECT e.last_name AS Angajat,
       e.salary AS Salariu 
FROM employees e
WHERE e.department_id IN (10,30) AND e.salary > 3500;

--15--
SELECT sysdate
FROM dual;

--16--
SELECT e.last_name,
       e.first_name,
       e.hire_date
FROM employees e
WHERE TO_CHAR(e.hire_date, 'YYYY') = 1987;

SELECT e.last_name,
       e.first_name,
       e.hire_date
FROM employees e
WHERE e.hire_date LIKE '%87%';

--17--
SELECT e.last_name,
       e.first_name,
       e.job_id
FROM employees e
WHERE e.manager_id IS NULL;

--18--
SELECT e.last_name,
       e.first_name,
       e.salary,
       e.commission_pct
FROM employees e
WHERE e.commission_pct IS NOT NULL
ORDER BY e.salary DESC, e.commission_pct DESC;

--19--
SELECT e.last_name,
       e.first_name,
       e.salary,
       e.commission_pct
FROM employees e
ORDER BY e.salary DESC, e.commission_pct DESC;
--Valorile NULL ale comisioanelor sunt puse la inceputul listei sortate descrescator pt fiecare salariu--

--20--
SELECT e.last_name,
       e.first_name
FROM employees e
WHERE LOWER(e.first_name) LIKE '__a%';

--21--
SELECT e.last_name,
       e.first_name
FROM employees e
WHERE (LOWER(e.first_name) LIKE '%l%l%' AND 
      e.department_id = 30) OR
      e.manager_id = 101;
      
      
--22--
SELECT e.last_name,
       e.first_name,
       e.job_id,
       e.salary
FROM employees e
WHERE (LOWER(e.job_id) LIKE '%clerk%' OR
      LOWER(e.job_id) LIKE '%rep%') AND
      e.salary NOT IN (1000,2000,3000);
      
--23--
SELECT e.last_name,
       e.first_name,
       e.salary,
       e.commission_pct
FROM employees e
WHERE e.salary > 5 * e.commission_pct * e.salary;
      
      