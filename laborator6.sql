--1--

--METODA1--
SELECT DISTINCT w.employee_id, e.last_name, e.first_name
FROM works_on w
JOIN employees e ON e.employee_id = w.employee_id
WHERE NOT EXISTS(SELECT p.start_date
       FROM projects p
       WHERE p.start_date BETWEEN TO_DATE('2006/01/01', 'yyyy/mm/dd') AND TO_DATE('2006/06/30', 'yyyy/mm/dd')
       AND NOT EXISTS(SELECT w1.employee_id
                     FROM works_on w1
                     WHERE w1.employee_id = w.employee_id
                     AND w1.project_id = p.project_id));
                     
--METODA2--
SELECT w.employee_id, e.last_name, e.first_name
FROM works_on w
JOIN employees e ON e.employee_id = w.employee_id
WHERE w.project_id IN (SELECT p.project_id
                      FROM projects p
                      WHERE p.start_date BETWEEN TO_DATE('2006/01/01', 'yyyy/mm/dd')
                      AND TO_DATE('2006/06/30', 'yyyy/mm/dd'))
GROUP BY w.employee_id, e.last_name, e.first_name
HAVING COUNT(w.project_id) = (SELECT COUNT(*)
                              FROM projects p1
                              WHERE p1.start_date BETWEEN TO_DATE('2006/01/01', 'yyyy/mm/dd')
                              AND TO_DATE('2006/06/30', 'yyyy/mm/dd'));
                              
                              
--METODA3--


--METODA4--
SELECT DISTINCT w.employee_id, e.first_name, e.last_name
FROM works_on w
JOIN employees e ON e.employee_id = w.employee_id
WHERE NOT EXISTS((SELECT p.project_id
                 FROM projects p
                 WHERE p.start_date BETWEEN TO_DATE('2006/01/01', 'yyyy/mm/dd')
                 AND TO_DATE('2006/06/30', 'yyyy/mm/dd'))
                 MINUS
                 (SELECT p1.project_id
                  FROM projects p1, works_on w1
                  WHERE p1.project_id = w1.project_id
                  AND w1.employee_id = w.employee_id));
                  
                  
                  
--2--

--a--
SELECT DISTINCT w.employee_id
FROM works_on w
WHERE NOT EXISTS((SELECT w1.project_id
                  FROM works_on w1
                  WHERE w1.employee_id = 200)
                  MINUS
                  (SELECT w2.project_id
                  FROM works_on w2
                  WHERE w.employee_id = w2.employee_id));
                  
--b--
SELECT DISTINCT w.employee_id
FROM works_on w
WHERE NOT EXISTS((SELECT w2.project_id
                  FROM works_on w2
                  WHERE w.employee_id = w2.employee_id)
                  MINUS
                  (SELECT w1.project_id
                  FROM works_on w1
                  WHERE w1.employee_id = 200));
                  
                  
--c--
SELECT DISTINCT w.employee_id
FROM works_on w
WHERE NOT EXISTS((SELECT w3.project_id
                  FROM works_on w3
                  WHERE w.employee_id = w3.employee_id)
                  MINUS
                  (SELECT w4.project_id
                  FROM works_on w4
                  WHERE w4.employee_id = 200)) AND
      NOT EXISTS((SELECT w1.project_id
                  FROM works_on w1
                  WHERE w1.employee_id = 200)
                  MINUS
                  (SELECT w2.project_id
                  FROM works_on w2
                  WHERE w.employee_id = w2.employee_id));    


--3--
SELECT  c.country_name, COUNT(e.employee_id) AS "Numar"
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations l ON d.location_id = l.location_id
RIGHT JOIN countries c ON l.country_id = c.country_id
GROUP BY c.country_name;


--4--
SELECT e.employee_id
FROM employees e
WHERE EXISTS(SELECT p.project_manager
             FROM projects p
             JOIN employees e1 ON e1.employee_id = p.project_manager
             WHERE e.department_id = e1.department_id);
             
             
--5--
SELECT DISTINCT w.employee_id
FROM works_on w
WHERE NOT EXISTS((SELECT w1.project_id
                  FROM works_on w1
                  WHERE w1.employee_id = w.employee_id)
                  MINUS
                  (SELECT p.project_id
                  FROM projects p
                  WHERE p.project_manager = 102));
                  

--7--
SELECT e.last_name, e.first_name, e.department_id, e.salary
FROM employees e
WHERE e.job_id = &job_input;

--8--
SELECT e.last_name, e.first_name, e.department_id, e.salary
FROM employees e
WHERE e.hire_date > TO_DATE(&data_calendaristica, 'YYYY/MM/DD');

--9--
SELECT &&coloana
FROM &tabel
WHERE &conditie
ORDER BY &coloana;
UNDEFINE coloana;


--10--
SELECT e.first_name, e.last_name, e.job_id, e.salary, d.department_name
FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
WHERE LOWER(l.city) = LOWER(&oras);
