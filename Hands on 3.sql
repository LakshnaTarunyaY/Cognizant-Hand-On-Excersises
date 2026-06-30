SELECT current_database();

-----------------------------------------------------------
-- HANDS-ON 3
-- Advanced SQL - Subqueries, Views & Transactions
-----------------------------------------------------------

-----------------------------------------------------------
-- Task 1 : Subqueries
-----------------------------------------------------------

-- 35. Students enrolled in more courses than average

SELECT s.student_id, s.first_name, s.last_name FROM students s JOIN enrollments e ON s.student_id=e.student_id GROUP BY s.student_id,s.first_name,s.last_name HAVING COUNT(*) > (SELECT AVG(course_count) FROM (SELECT COUNT(*) AS course_count FROM enrollments GROUP BY student_id) avg_table);

-----------------------------------------------------------

-- 36. Courses where every enrolled student scored A

SELECT c.course_name FROM courses c WHERE NOT EXISTS (SELECT * FROM enrollments e WHERE e.course_id=c.course_id AND e.grade<>'A');

-----------------------------------------------------------

-- 37. Highest paid professor in each department

SELECT * FROM professors p WHERE salary=(SELECT MAX(salary) FROM professors WHERE department_id=p.department_id);

-----------------------------------------------------------

-- 38. Departments with average salary above 85000

SELECT * FROM (SELECT d.dept_name, AVG(p.salary) AS avg_salary FROM departments d JOIN professors p ON d.department_id=p.department_id GROUP BY d.dept_name) dept_avg WHERE avg_salary>85000;

-----------------------------------------------------------
-- Task 2 : Views
-----------------------------------------------------------

-- 39. Student enrollment summary view

CREATE VIEW vw_student_enrollment_summary AS
SELECT s.student_id,
       s.first_name || ' ' || s.last_name AS student_name,
       d.dept_name,
       COUNT(e.course_id) AS total_courses,
       ROUND(AVG(CASE WHEN e.grade='A' THEN 4 WHEN e.grade='B' THEN 3 WHEN e.grade='C' THEN 2 WHEN e.grade='D' THEN 1 WHEN e.grade='F' THEN 0 END),2) AS gpa
FROM students s
JOIN departments d ON s.department_id=d.department_id
LEFT JOIN enrollments e ON s.student_id=e.student_id
GROUP BY s.student_id,student_name,d.dept_name;

-----------------------------------------------------------

-- 40. Course statistics view

CREATE VIEW vw_course_stats AS
SELECT c.course_name,
       c.course_code,
       COUNT(e.student_id) AS total_enrollments,
       ROUND(AVG(CASE WHEN e.grade='A' THEN 4 WHEN e.grade='B' THEN 3 WHEN e.grade='C' THEN 2 WHEN e.grade='D' THEN 1 WHEN e.grade='F' THEN 0 END),2) AS avg_gpa
FROM courses c
LEFT JOIN enrollments e ON c.course_id=e.course_id
GROUP BY c.course_name,c.course_code;

-----------------------------------------------------------

-- 41. Students with GPA above 3.0

SELECT * FROM vw_student_enrollment_summary WHERE gpa>3.0;

-----------------------------------------------------------

-- 42. Attempt update through view

UPDATE vw_student_enrollment_summary SET gpa=4 WHERE student_id=1;

-- PostgreSQL will give an error because this view is based on
-- multiple tables and contains aggregate functions.
-- Such views are generally not updatable.

-----------------------------------------------------------

-- 43. Drop and recreate view with CHECK OPTION

DROP VIEW vw_course_stats;

DROP VIEW vw_student_enrollment_summary;

CREATE VIEW vw_student_enrollment_summary AS
SELECT student_id,first_name,last_name,email
FROM students
WHERE enrollment_year>=2022
WITH LOCAL CHECK OPTION;

-----------------------------------------------------------
-- Task 3 : Functions & Transactions
-----------------------------------------------------------

-- 44. Function to enroll a student

CREATE OR REPLACE FUNCTION fn_enroll_student(sid INT,cid INT,edate DATE)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM enrollments WHERE student_id=sid AND course_id=cid) THEN
        RAISE EXCEPTION 'Student already enrolled in this course';
    END IF;

    INSERT INTO enrollments(student_id,course_id,enrollment_date)
    VALUES(sid,cid,edate);
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------

-- Test function

SELECT fn_enroll_student(2,2,'2024-01-10');

-----------------------------------------------------------

-- 45. Create transfer log table

CREATE TABLE department_transfer_log (
    log_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT,
    old_department INT,
    new_department INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-----------------------------------------------------------

-- Transfer student function

CREATE OR REPLACE FUNCTION sp_transfer_student(sid INT,new_dept INT)
RETURNS VOID AS $$
DECLARE
old_dept INT;
BEGIN
    SELECT department_id INTO old_dept FROM students WHERE student_id=sid;

    UPDATE students
    SET department_id=new_dept
    WHERE student_id=sid;

    INSERT INTO department_transfer_log(student_id,old_department,new_department)
    VALUES(sid,old_dept,new_dept);
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------

-- Test transfer

SELECT sp_transfer_student(1,2);

-----------------------------------------------------------

-- 46. Transaction test

BEGIN;

UPDATE students
SET department_id=999
WHERE student_id=1;

INSERT INTO department_transfer_log(student_id,old_department,new_department)
VALUES(1,1,999);

ROLLBACK;

-----------------------------------------------------------

-- 47. SAVEPOINT example

BEGIN;

INSERT INTO enrollments(student_id,course_id,enrollment_date,grade)
VALUES(2,2,'2024-01-01','A');

SAVEPOINT first_insert;

INSERT INTO enrollments(student_id,course_id,enrollment_date,grade)
VALUES(999,2,'2024-01-01','A');

ROLLBACK TO first_insert;

COMMIT;
