--1--
--a) Toate functiile cu exceptia functiei COUNT(*) ignora valorile NULL
--b) WHERE este folosit atunci cand vrem sa filtram randurile inainte de a se grupa, iar HAVING este folosit pentru a filtra grupurile de linii returnate

--2--
SELECT MIN(e.salary) AS Minim,
       MAX(e.salary) AS Maxim,
       SUM(e.salary) AS Suma,
       ROUND(AVG(e.salary)) AS Medie
FROM employees e;

--3--
SELECT MIN(e.salary) AS Minim,
       MAX(e.salary) AS Maxim,
       SUM(e.salary) AS Suma,
       ROUND(AVG(e.salary)) AS Medie,
       e.job_id
FROM employees e
GROUP BY e.job_id;

--4--
SELECT e.job_id, COUNT(*) AS "Numar Angajati"
FROM employees e
GROUP BY e.job_id;

--5--
SELECT COUNT(*)
FROM (SELECT DISTINCT e.manager_id 
      FROM employees e
      WHERE e.manager_id IS NOT NULL);
      
--6--
SELECT MAX(e.salary) - MIN(e.salary) AS "Diferenta"
FROM employees e;

--7--
SELECT d.department_name,
       l.city,
      COUNT(*) AS "Numar angajati",
      ROUND(AVG(e.salary)) AS "Medie"
FROM departments d
JOIN locations l ON l.location_id = d.location_id
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name, l.city;

--8--
SELECT e.employee_id,
       e.last_name,
       e.first_name,
       e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(f.salary)
                  FROM employees f)
ORDER BY e.salary DESC;

--9--
SELECT e.manager_id,
       MIN(e.salary) AS Minim
FROM employees e
WHERE e.manager_id IS NOT NULL
GROUP BY e.manager_id
HAVING MIN(e.salary) > 1000
ORDER BY MIN(e.salary) DESC;

--10--
SELECT d.department_name,
       d.department_id,
       MAX(e.salary) AS Maxim
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name, d.department_id
HAVING MAX(e.salary) > 3000;

--11--
SELECT MIN(AVG(e.salary)) AS "Salariu mediu minim"
FROM employees e
GROUP BY e.job_id;

--12--
SELECT d.department_id,
       d.department_name,
       SUM(e.salary) AS Suma
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

--13--
SELECT ROUND(MAX(AVG(e.salary))) AS "Salariu mediu maxim"
FROM employees e
GROUP BY e.department_id;

--14--
SELECT j.job_id,
       j.job_title,
       ROUND(AVG(e.salary)) AS Medie
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
GROUP BY j.job_id, j.job_title
HAVING AVG(e.salary) = (SELECT MIN(AVG(f.salary))
                        FROM employees f
                        GROUP BY f.job_id);

--15--
SELECT ROUND(AVG(e.salary)) AS Medie
FROM employees e
HAVING AVG(e.salary) > 2500;

--16--
SELECT e.department_id,
       e.job_id,
       SUM(e.salary) AS Suma
FROM employees e
GROUP BY e.department_id, e.job_id;

--17--
SELECT d.department_name,
       MIN(e.salary) AS Minim
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) = (SELECT MAX(AVG(f.salary)) 
                        FROM employees f
                        GROUP BY f.department_id);
                        
--18--

--a--
SELECT d.department_name,
       d.department_id,
       COUNT(*) AS "Numar angajati"
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name, d.department_id
HAVING COUNT(*) < 4;

--b--
SELECT d.department_name,
       d.department_id,
       COUNT(*) AS "Numar angajati"
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name, d.department_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                   FROM employees f 
                   GROUP BY f.department_id);
                   
                   
--19--
SELECT e.first_name, e.last_name
FROM employees e
WHERE TO_CHAR(e.hire_date, 'DD') = (SELECT TO_CHAR(h.hire_date, 'DD')
                                    FROM employees h
                                    GROUP BY TO_CHAR(h.hire_date, 'DD')
                                    HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                                       FROM employees f
                                                       GROUP BY TO_CHAR(f.hire_date, 'DD')));
                                                       
                                                       
--20--
SELECT COUNT(COUNT(*)) AS "Numarul departamentelor"
FROM employees e
GROUP BY e.department_id
HAVING COUNT(*) > 15;

--21--
SELECT e.department_id,
       SUM(e.salary) AS Suma
FROM employees e
WHERE e.department_id <> 30
GROUP BY e.department_id
HAVING COUNT(*) > 10;

--22--
SELECT d.department_id,
      d.department_name,
      (SELECT COUNT(f.employee_id)
       FROM employees f
       WHERE f.department_id = e.department_id) AS "Count",
       (SELECT AVG(f.employee_id)
       FROM employees f
       WHERE f.department_id = e.department_id) AS "Avg",
       e.last_name,
       e.salary,
       e.job_id
FROM departments d
LEFT OUTER JOIN employees e ON e.department_id = d.department_id;


--23--
SELECT d.department_name,
       e.job_id,
       l.city,
       SUM(e.salary) AS Suma
FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
WHERE e.department_id > 80
GROUP BY d.department_name, e.job_id, l.city;


--24--
SELECT e.last_name,
       e.first_name
FROM employees e
WHERE (SELECT COUNT(*)
       FROM job_history jh
       WHERE jh.employee_id = e.employee_id) >= 2;
       
       
--25--
SELECT AVG(NVL(e.commission_pct, 0))
FROM employees e;

--27--
SELECT e.job_id,
       SUM(e.salary),
       (SELECT SUM(f.salary)
        FROM employees f
        WHERE f.department_id = 30) AS "Dep 30",
        (SELECT SUM(f.salary)
        FROM employees f
        WHERE f.department_id = 50) AS "Dep 50",
        (SELECT SUM(f.salary)
        FROM employees f
        WHERE f.department_id = 80) AS "Dep 80",
        (SELECT SUM(f.salary)
        FROM employees f) AS "Total"
FROM employees e
GROUP BY e.job_id;

--28--
SELECT (SELECT COUNT(*)
        FROM employees f) AS Total,
        (SELECT COUNT(*)
        FROM employees f
        WHERE TO_CHAR(f.hire_date, 'YYYY')=1997) AS "1997",
        (SELECT COUNT(*)
        FROM employees f
        WHERE TO_CHAR(f.hire_date, 'YYYY')=1998) AS "1998",
        (SELECT COUNT(*)
        FROM employees f
        WHERE TO_CHAR(f.hire_date, 'YYYY')=1999) AS "1999",
        (SELECT COUNT(*)
        FROM employees f
        WHERE TO_CHAR(f.hire_date, 'YYYY')=2000) AS "2000"
FROM dual;


--29 -> la fel ca 22 --

--30--
SELECT d.department_id,
       d.department_name,
       info.suma
FROM departments d
RIGHT JOIN (SELECT e.department_id,
             SUM(e.salary) AS suma
            FROM employees e
            GROUP BY e.department_id) info ON info.department_id = d.department_id;


--31--
SELECT e.last_name,
       e.salary,
       e.department_id,
       info.medie
FROM employees e
RIGHT JOIN (SELECT f.department_id,
            AVG(f.salary) AS medie
            FROM employees f
            GROUP BY f.department_id) info ON info.department_id = e.department_id;
            
            
--32--
SELECT e.last_name,
       e.salary,
       e.department_id,
       info.medie,
       info.numar
FROM employees e
RIGHT JOIN (SELECT f.department_id,
            AVG(f.salary) AS medie,
            COUNT(*) AS numar
            FROM employees f
            GROUP BY f.department_id) info ON info.department_id = e.department_id;
        
        
        
--33--   
SELECT nume,
       e.first_name,
       salariu_min,
       id
FROM (SELECT d.department_name AS nume,
             MIN(e.salary) AS salariu_min,
             d.department_id AS id 
      FROM departments d
      JOIN employees e on e.department_id = d.department_id 
      GROUP BY d.department_name, d.department_id)
JOIN employees e on e.department_id = id
WHERE e.salary = salariu_min;