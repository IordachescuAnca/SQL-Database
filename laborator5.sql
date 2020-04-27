--1--

--a--
SELECT d.department_name, 
       j.job_title,
       ROUND(AVG(e.salary)) AS "Medie"
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN jobs j ON j.job_id = e.job_id
GROUP BY ROLLUP(d.department_name, j.job_title);

--b--
SELECT d.department_name, 
       j.job_title,
       ROUND(AVG(e.salary)) AS "Medie",
       GROUPING(d.department_name) AS "Interventie Dep",
       GROUPING(j.job_title) AS "Interventie Job"
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN jobs j ON j.job_id = e.job_id
GROUP BY ROLLUP(d.department_name, j.job_title);

--2--

--a--
SELECT d.department_name, 
       j.job_title,
       ROUND(AVG(e.salary)) AS "Medie"
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN jobs j ON j.job_id = e.job_id
GROUP BY CUBE(d.department_name, j.job_title);

--b--
SELECT d.department_name, 
       j.job_title,
       ROUND(AVG(e.salary)) AS "Medie",
       GROUPING(d.department_name) AS "Interventie Dep",
       GROUPING(j.job_title) AS "Interventie Job"
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN jobs j ON j.job_id = e.job_id
GROUP BY CUBE(d.department_name, j.job_title);

--3--
SELECT d.department_name,
       j.job_title,
       e.manager_id,
       MAX(e.salary) AS "Maxim",
       SUM(e.salary) AS "Suma"
FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN jobs j ON j.job_id = e.job_id
GROUP BY GROUPING SETS((d.department_name, j.job_title), (j.job_title, e.manager_id), ());

--4--
SELECT MAX(e.salary)
FROM employees e
HAVING MAX(e.salary) > 15000;

--5--

--a--
SELECT e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(f.salary)
                  FROM employees f
                  WHERE f.department_id = e.department_id AND
                  f.employee_id <> e.employee_id);
                  
--b--
SELECT e.last_name,
       e.first_name, 
       e.salary,
       (SELECT SUM(f.salary)
        FROM employees f
        WHERE e.department_id = f.department_id) AS "Suma departament",
        (SELECT COUNT(*)
        FROM employees f
        WHERE e.department_id = f.department_id) AS "Numar angajati departament",
        d.department_name,
        d.department_id
FROM employees e
JOIN departments d ON d.department_id = e.department_id
WHERE e.salary > (SELECT AVG(f.salary)
                  FROM employees f
                  WHERE f.department_id = e.department_id AND
                  f.employee_id <> e.employee_id);


SELECT e.last_name,
       e.first_name,
       e.salary,
       info.counting,
       info.sumsalary,
       d.department_name
FROM employees e
JOIN (SELECT COUNT(*) AS counting,
         SUM(f.salary) AS sumsalary,
         f.department_id 
         FROM employees f 
         GROUP BY f.department_id) info ON e.department_id = info.department_id
JOIN departments d ON d.department_id = e.department_id
WHERE e.salary > (SELECT AVG(f.salary)
                  FROM employees f
                  WHERE f.department_id = e.department_id AND
                  f.employee_id <> e.employee_id);
                  
--6--
SELECT e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE e.salary > (SELECT MAX(AVG(f.salary))
                  FROM employees f
                  GROUP BY f.department_id);
                  
SELECT e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE e.salary > ALL(SELECT AVG(f.salary)
                  FROM employees f
                  GROUP BY f.department_id); 
                  
--7--
SELECT e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE e.salary = (SELECT MIN(f.salary)
                 FROM employees f
                 WHERE f.department_id = e.department_id);
                 
SELECT e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE (e.department_id, e.salary) IN (SELECT f.department_id,
                                      MIN(f.salary)
                                      FROM employees f
                                      GROUP BY f.department_id);
                                      
                                      
SELECT e.last_name,
       e.first_name,
       info.salariumin
FROM employees e
JOIN (SELECT f.department_id,
      MIN(f.salary) AS salariumin
      FROM employees f
      GROUP BY f.department_id) info ON info.department_id = e.department_id
WHERE e.salary = salariumin;

--8--
SELECT e.last_name,
       e.first_name,
       e.hire_date,
       d.department_name
FROM employees e
JOIN departments d ON d.department_id = e.department_id
WHERE e.hire_date = (SELECT MIN(f.hire_date)
                     FROM employees f
                     WHERE e.department_id = f.department_id)
ORDER BY d.department_name DESC;


--9--
SELECT e.last_name,
       e.first_name
FROM employees e
WHERE EXISTS(SELECT f.employee_id
            FROM employees f
            WHERE e.department_id = f.department_id AND
            f.salary = (SELECT MAX(h.salary)
                        FROM employees h
                        WHERE h.department_id = 30));
                        
--10--
SELECT nume,
       prenume,
       salariu
FROM (SELECT f.last_name AS nume,
             f.first_name AS prenume,
             f.salary AS salariu
      FROM employees f
      ORDER BY f.salary DESC)
WHERE rownum < 4
ORDER BY salariu;

--11--
SELECT e.employee_id,
       e.last_name,
       e.first_name
FROM employees e
WHERE (SELECT COUNT(*)
       FROM employees f
       WHERE f.manager_id = e.employee_id) >= 2;
       
--12--
SELECT l.city
FROM locations l
WHERE EXISTS(SELECT d1.location_id
             FROM departments d1
             WHERE l.location_id = d1.location_id);

SELECT l.city
FROM locations l
WHERE l.location_id IN (SELECT d1.location_id
                        FROM departments d1);

--13--
SELECT d.department_name,
       d.department_id
FROM departments d
WHERE NOT EXISTS(SELECT e.employee_id
                 FROM employees e
                 WHERE d.department_id = e.department_id);
                 
--14--
SELECT e.employee_id,
       e.last_name,
       e.hire_date,
       e.salary,
       e.manager_id,
       LEVEL
FROM employees e
WHERE LEVEL = 2
START WITH LOWER(e.last_name)='de haan'
CONNECT BY PRIOR e.employee_id = e.manager_id;

SELECT e.employee_id,
       e.last_name,
       e.hire_date,
       e.salary,
       e.manager_id,
       LEVEL
FROM employees e
WHERE LEVEL > 1
START WITH LOWER(e.last_name)='de haan'
CONNECT BY PRIOR e.employee_id = e.manager_id;

SELECT e.employee_id,
       e.last_name,
       e.hire_date,
       e.salary,
       e.manager_id,
       LEVEL
FROM employees e
START WITH LOWER(e.last_name)='de haan'
CONNECT BY PRIOR e.manager_id = e.employee_id;

--15--
SELECT e.employee_id,
       e.last_name,
       e.hire_date,
       e.manager_id,
       LEVEL
FROM employees e
START WITH e.employee_id = 114
CONNECT BY PRIOR e.employee_id = e.manager_id;

--16--
SELECT e.employee_id,
       e.last_name,
       e.hire_date,
       e.salary,
       e.manager_id,
       LEVEL
FROM employees e
WHERE LEVEL = 3 
START WITH LOWER(e.last_name)='de haan'
CONNECT BY PRIOR e.employee_id = e.manager_id;

--17--
SELECT e.employee_id,
       e.manager_id,
       LEVEL,
       e.last_name,
       e.first_name
FROM employees e
CONNECT BY PRIOR e.employee_id = e.manager_id;

--18--
SELECT e.employee_id, 
       e.last_name,
       e.salary,
       LEVEL,
       e.manager_id
FROM employees e
START WITH e.salary = (SELECT MAX(f.salary) 
                  FROM employees f)
CONNECT BY PRIOR e.employee_id = e.manager_id AND
                 e.salary > 5000;
                
                
                
--19--
WITH temporaryTable AS
    (SELECT d.department_name,
     SUM(e.salary) AS suma
     FROM departments d
     JOIN employees e ON d.department_id = e.department_id
     GROUP BY d.department_name)
SELECT *
FROM temporaryTable
WHERE temporaryTable.suma > (SELECT AVG(suma) FROM temporaryTable);


--20--
WITH steven_data AS
      (SELECT e.employee_id AS s_id
       FROM employees e
       WHERE LOWER(e.last_name)='king' AND
       LOWER(e.first_name)='steven'),
sub_steven AS
    (SELECT e.employee_id AS ang_id,
            e.hire_date AS ang_data
    FROM employees e
    WHERE e.manager_id IN (SELECT steven_data.s_id FROM steven_data)),
old_sub_steven AS
  (SELECT s.ang_id AS old_ang_id
   FROM sub_steven s
   WHERE s.ang_data = (SELECT MIN(s1.ang_data) FROM sub_steven s1))
SELECT e.employee_id,
       e.last_name || ' ' || e.first_name AS "Data",
       e.job_id,
       e.hire_date
FROM employees e
WHERE TO_CHAR(e.hire_date, 'YYYY') <> 1970
START WITH e.employee_id IN (SELECT o.old_ang_id FROM old_sub_steven o)
CONNECT BY PRIOR e.employee_id = e.manager_id;


--21--
SELECT *
FROM (SELECT e.last_name,
             e.first_name,
             e.salary
      FROM employees e
      ORDER BY e.salary DESC)
WHERE rownum <= 10;

--22--
SELECT data_sal, job_sal
FROM (SELECT AVG(e.salary) data_sal,
      e.job_id job_sal
      FROM employees e
      GROUP BY e.job_id
      ORDER BY AVG(e.salary))
WHERE rownum <= 3;

--23--
SELECT 'Departamentul ' || d.department_name 
      || ' este condus de ' || nvl(to_char(d.manager_id), 'nimeni') 
      || ' si are numarul de salariati ' 
      || DECODE(COUNT(e.employee_id), 0, '0', COUNT(e.employee_id)) 
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name, d.manager_id;


--24--
SELECT e.last_name,
       e.first_name,
       LENGTH(e.last_name)
FROM employees e
WHERE NULLIF(LENGTH(e.last_name), LENGTH(e.first_name)) = LENGTH(e.last_name);

--25--
SELECT e.last_name,
       e.hire_date,
       e.salary,
       DECODE(TO_CHAR(e.hire_date,'YYYY'), 1989, 1.2 * e.salary, 1990, 1.15 * e.salary, 1991, 1.1 * e.salary, e.salary) AS "Marire"
FROM employees e;

--26--

SELECT DISTINCT e.job_id,
      CASE 
      WHEN UPPER(e.job_id) LIKE 'S%'
        THEN (SELECT SUM(e1.salary)
        FROM employees e1
        WHERE e1.job_id = e.job_id)
      WHEN e.job_id IN (SELECT e1.job_id
                        FROM employees e1
                        WHERE e1.salary = (SELECT MAX(e2.salary)
                                          FROM employees e2))
        THEN (SELECT AVG(e1.salary)
              FROM employees e1)
      ELSE (SELECT MIN(e1.salary) 
            FROM employees e1)
      end "Afiseaza"
FROM employees e;

