--1--
SELECT e.last_name,
       TO_CHAR(e.hire_date, 'MON'), 
       TO_CHAR(e.hire_date, 'YYYY')
FROM EMPLOYEES e
JOIN EMPLOYEES f ON f.department_id = e.department_id
WHERE LOWER(f.last_name) = 'gates' 
      AND LOWER(f.last_name) LIKE '%a%'
      AND f.employee_id <> e.employee_id;
      

--2--
SELECT DISTINCT e.employee_id, 
                e.last_name,
                d.department_id,
                d.department_name
FROM EMPLOYEES e
JOIN EMPLOYEES f ON f.department_id = e.department_id
JOIN DEPARTMENTS d ON e.department_id = d.department_id
WHERE LOWER(f.last_name) LIKE '%t%' AND f.employee_id <> e.employee_id;


--3--
SELECT e.last_name,
       e.salary,
       j.job_title,
       l.city,
       c.country_name
FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN JOBS j ON j.job_id = e.job_id
JOIN locations l ON l.location_id = d.location_id
JOIN countries c ON c.country_id = l.country_id
WHERE e.manager_id IN (SELECT employee_id FROM employees WHERE LOWER(last_name) = 'king');

--4--
SELECT d.department_id,
       d.department_name,
       e.last_name,
       j.job_title,
       TO_CHAR(e.salary, 'S99,999.00')
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
JOIN LOCATIONS l ON l.location_id = d.location_id
JOIN JOBS j ON j.job_id = e.job_id
WHERE LOWER(d.department_name) LIKE '%ti%'
ORDER BY d.department_name, e.last_name;

--5--
SELECT e.last_name,
       d.department_id,
       d.department_name,
       l.city,
       j.job_title
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
JOIN LOCATIONS l ON l.location_id = d.location_id
JOIN JOBS j ON j.job_id = e.job_id
WHERE LOWER(l.city) = 'oxford';

--6--
SELECT DISTINCT e.employee_id,
       e.last_name,
       e.salary
FROM EMPLOYEES e
JOIN JOBS j ON e.job_id = j.job_id
JOIN EMPLOYEES f ON f.department_id = e.department_id
WHERE e.salary > (j.min_salary + j.max_salary) / 2
AND LOWER(f.last_name) LIKE '%f%'
AND f.employee_id <> e.employee_id;

--7--
SELECT e.last_name,
       d.department_name
FROM EMPLOYEES e
LEFT JOIN DEPARTMENTS d ON d.department_id = e.department_id;

--8--
SELECT e.last_name,
       d.department_name
FROM EMPLOYEES e
RIGHT JOIN DEPARTMENTS d ON d.department_id = e.department_id;


--9--
--UNION de RIGHT JOIN si LEFT JOIN --

--10--
SELECT e.department_id
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
WHERE LOWER(d.department_name) LIKE '%re%'
UNION 
SELECT f.department_id
FROM EMPLOYEES f
WHERE f.job_id = 'SA_REP';

--11--
SELECT e.department_id
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
WHERE LOWER(d.department_name) LIKE '%re%'
UNION ALL
SELECT f.department_id
FROM EMPLOYEES f
WHERE f.job_id = 'SA_REP';

--12--
SELECT d.department_id
FROM EMPLOYEES e
RIGHT JOIN DEPARTMENTS d ON d.department_id = e.department_id
MINUS 
SELECT d.department_id
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id;

--13--
SELECT e.department_id
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
WHERE LOWER(d.department_name) LIKE '%re%'
INTERSECT
SELECT f.department_id
FROM EMPLOYEES f
WHERE f.job_id = 'HR_REP';


--14--
SELECT e.employee_id,
       e.job_id,
       e.last_name
FROM EMPLOYEES e
JOIN JOBS j ON j.job_id = e.job_id
WHERE e.salary > (j.min_salary + j.max_salary)/2;

--15--
SELECT e.last_name,
       e.hire_date
FROM EMPLOYEES e
WHERE e.hire_date > (SELECT hire_date FROM EMPLOYEES WHERE LOWER(last_name)='gates');

--16--
SELECT e.last_name,
       e.hire_date
FROM EMPLOYEES e
WHERE e.department_id = (SELECT department_id FROM EMPLOYEES WHERE LOWER(last_name)='gates')
AND LOWER(e.last_name) <> 'gates';

--17--
SELECT e.last_name,
       e.salary
FROM EMPLOYEES e
WHERE e.manager_id = (SELECT employee_id FROM EMPLOYEES WHERE manager_id is NULL);

--18--
SELECT d.department_id,
       d.department_name,
       e.salary
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
WHERE (d.department_id, e.salary) IN (SELECT department_id, salary FROM EMPLOYEES WHERE commission_pct IS NOT NULL AND e.last_name <> last_name);

--19--
SELECT e.last_name,
       d.department_name
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
WHERE e.salary > (SELECT (min_salary+max_salary)/2 FROM JOBS WHERE e.job_id = job_id);

--20--
SELECT *
FROM EMPLOYEES e
WHERE e.salary > ALL(SELECT salary FROM EMPLOYEES WHERE LOWER(job_id) LIKE '%clerk')
ORDER BY e.salary DESC;

SELECT *
FROM EMPLOYEES e
WHERE e.salary > ANY(SELECT salary FROM EMPLOYEES WHERE LOWER(job_id) LIKE '%clerk')
ORDER BY e.salary DESC;

--21--
SELECT e.last_name,
       d.department_name,
       e.salary
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
WHERE e.commission_pct IS NULL AND e.manager_id IN (SELECT manager_id FROM EMPLOYEES WHERE commission_pct IS NOT NULL);


--22--
SELECT e.last_name,
       e.department_id,
       e.salary,
       e.job_id
FROM EMPLOYEES e
WHERE (e.salary, e.commission_pct) IN (SELECT e1.salary, e1.commission_pct
                                       FROM EMPLOYEES e1
                                       JOIN DEPARTMENTS d1 ON d1.department_id = e1.department_id
                                       JOIN LOCATIONS l1 ON d1.location_id = l1.location_id
                                       WHERE LOWER(l1.city)='oxford');
                                       
                                       
--23--
SELECT e.last_name,
       e.department_id,
       e.job_id
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON d.department_id = e.department_id
JOIN LOCATIONS l ON l.location_id = d.location_id
WHERE LOWER(l.city) = 'toronto';