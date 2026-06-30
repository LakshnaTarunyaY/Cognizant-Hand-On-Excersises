SELECT current_database();
-----------------------------------------------------------
-- HANDS-ON 2
-- Writing SQL Queries - DML, Joins & Aggregations
-----------------------------------------------------------

-----------------------------------------------------------
-- Task 1: Insert, Update and Delete Data
-----------------------------------------------------------

-- 15. Insert sample data into all tables

-- departments
INSERT INTO departments (dept_name, head_of_dept, budget) VALUES
('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
('Electronics', 'Dr. Priya Nair', 620000.00),
('Mechanical', 'Dr. Suresh Iyer', 540000.00),
('Civil', 'Dr. Ananya Sharma', 430000.00);

-- students
INSERT INTO students(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Arjun','Mehta','arjun.mehta@college.edu','2003-04-12',1,2022),
('Priya','Suresh','priya.suresh@college.edu','2003-07-25',1,2022),
('Rohan','Verma','rohan.verma@college.edu','2002-11-08',2,2021),
('Sneha','Patel','sneha.patel@college.edu','2004-01-30',3,2023),
('Vikram','Das','vikram.das@college.edu','2003-09-14',1,2022),
('Kavya','Menon','kavya.menon@college.edu','2002-05-17',2,2021),
('Aditya','Singh','aditya.singh@college.edu','2004-03-22',4,2023),
('Deepika','Rao','deepika.rao@college.edu','2003-08-09',1,2022);

-- courses
INSERT INTO courses(course_name,course_code,credits,department_id)
VALUES
('Data Structures & Algorithms','CS101',4,1),
('Database Management Systems','CS102',3,1),
('Object Oriented Programming','CS103',4,1),
('Circuit Theory','EC101',3,2),
('Thermodynamics','ME101',3,3);

-- enrollments
INSERT INTO enrollments(student_id,course_id,enrollment_date,grade)
VALUES
(1,1,'2022-07-01','A'),
(1,2,'2022-07-01','B'),
(2,1,'2022-07-01','B'),
(2,3,'2022-07-01','A'),
(3,4,'2021-07-01','A'),
(4,5,'2023-07-01',NULL),
(5,1,'2022-07-01','C'),
(5,2,'2022-07-01','A'),
(6,4,'2021-07-01','B'),
(7,5,'2023-07-01',NULL),
(8,1,'2022-07-01','A'),
(8,3,'2022-07-01','B');

-- professors
INSERT INTO professors(prof_name,email,department_id,salary)
VALUES
('Dr. Anand Krishnan','anand.k@college.edu',1,95000.00),
('Dr. Meena Pillai','meena.p@college.edu',1,88000.00),
('Dr. Sunil Rajan','sunil.r@college.edu',2,82000.00),
('Dr. Latha Gopal','latha.g@college.edu',3,79000.00),
('Dr. Kartik Bose','kartik.b@college.edu',4,76000.00);

SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM enrollments;

-----------------------------------------------------------

-- 16. Insert two new students

INSERT INTO students(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Rahul','Sharma','rahul.sharma@college.edu','2004-06-15',1,2023),
('Anjali','Reddy','anjali.reddy@college.edu','2003-12-20',2,2022);

SELECT COUNT(*) FROM students;

-----------------------------------------------------------

-- 17. Update grade

UPDATE enrollments
SET grade='B'
WHERE student_id=5
AND course_id=1;

-----------------------------------------------------------

-- 18. Preview records before deleting

SELECT *
FROM enrollments
WHERE grade IS NULL;

DELETE FROM enrollments
WHERE grade IS NULL;

-----------------------------------------------------------

-- 19. Verify row count

SELECT COUNT(*) FROM enrollments;

-----------------------------------------------------------
-- Task 2: Single Table Queries
-----------------------------------------------------------

-- 20. Students enrolled in 2022

SELECT *
FROM students
WHERE enrollment_year=2022
ORDER BY last_name;

-----------------------------------------------------------

-- 21. Courses with more than 3 credits

SELECT *
FROM courses
WHERE credits>3
ORDER BY credits DESC;

-----------------------------------------------------------

-- 22. Professors with salary between 80000 and 95000

SELECT *
FROM professors
WHERE salary BETWEEN 80000 AND 95000;

-----------------------------------------------------------

-- 23. Students with college email

SELECT *
FROM students
WHERE email LIKE '%@college.edu';

-----------------------------------------------------------

-- 24. Student count by enrollment year

SELECT enrollment_year,
COUNT(*) AS total_students
FROM students
GROUP BY enrollment_year;

-----------------------------------------------------------
-- Task 3: JOIN Queries
-----------------------------------------------------------

-- 25. Student name with department

SELECT
first_name || ' ' || last_name AS student_name,
dept_name
FROM students
JOIN departments
ON students.department_id = departments.department_id;

-----------------------------------------------------------

-- 26. Student name with course

SELECT
first_name || ' ' || last_name AS student_name,
course_name
FROM enrollments
JOIN students
ON enrollments.student_id = students.student_id
JOIN courses
ON enrollments.course_id = courses.course_id;

-----------------------------------------------------------

-- 27. Students not enrolled in any course

SELECT
students.student_id,
first_name,
last_name
FROM students
LEFT JOIN enrollments
ON students.student_id = enrollments.student_id
WHERE enrollments.student_id IS NULL;

-----------------------------------------------------------

-- 28. Course with number of enrollments

SELECT
course_name,
COUNT(enrollment_id) AS enrollment_count
FROM courses
LEFT JOIN enrollments
ON courses.course_id = enrollments.course_id
GROUP BY course_name;

-----------------------------------------------------------

-- 29. Department with professors

SELECT
dept_name,
prof_name,
salary
FROM departments
LEFT JOIN professors
ON departments.department_id = professors.department_id;

-----------------------------------------------------------
-- Task 4: Aggregations
-----------------------------------------------------------

-- 30. Total enrollments per course

SELECT
course_name,
COUNT(enrollment_id) AS enrollment_count
FROM courses
LEFT JOIN enrollments
ON courses.course_id = enrollments.course_id
GROUP BY course_name;

-----------------------------------------------------------

-- 31. Average salary per department

SELECT
dept_name,
ROUND(AVG(salary),2) AS average_salary
FROM departments
LEFT JOIN professors
ON departments.department_id = professors.department_id
GROUP BY dept_name;

-----------------------------------------------------------

-- 32. Departments with budget greater than 600000

SELECT *
FROM departments
WHERE budget > 600000;

-----------------------------------------------------------

-- 33. Grade distribution for CS101

SELECT
grade,
COUNT(*) AS total_students
FROM enrollments
JOIN courses
ON enrollments.course_id = courses.course_id
WHERE course_code='CS101'
GROUP BY grade;

-----------------------------------------------------------

-- 34. Departments with more than 2 enrolled students

SELECT
dept_name,
COUNT(enrollments.student_id) AS total_students
FROM departments
JOIN students
ON departments.department_id = students.department_id
JOIN enrollments
ON students.student_id = enrollments.student_id
GROUP BY dept_name
HAVING COUNT(enrollments.student_id) > 2;