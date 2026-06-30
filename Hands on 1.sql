--Hands on 1--
CREATE TABLE departments (
    department_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);


CREATE TABLE students (
    student_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,

    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE courses (
    course_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,

    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE enrollments (
    enrollment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

CREATE TABLE professors (
    professor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),

    CONSTRAINT fk_professor_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

--data insertion from here on--
--departments

INSERT INTO departments (dept_name, hod_name, budget) VALUES
('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
('Electronics', 'Dr. Priya Nair', 620000.00),
('Mechanical', 'Dr. Suresh Iyer', 540000.00),
('Civil', 'Dr. Ananya Sharma', 430000.00);
-- students
INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
('Arjun', 'Mehta', 'arjun.mehta@college.edu', '2003-04-12', 1, 2022),
('Priya', 'Suresh', 'priya.suresh@college.edu', '2003-07-25', 1, 2022),
('Rohan', 'Verma', 'rohan.verma@college.edu', '2002-11-08', 2, 2021),
('Sneha', 'Patel', 'sneha.patel@college.edu', '2004-01-30', 3, 2023),
('Vikram', 'Das', 'vikram.das@college.edu', '2003-09-14', 1, 2022),
('Kavya', 'Menon', 'kavya.menon@college.edu', '2002-05-17', 2, 2021),
('Aditya', 'Singh', 'aditya.singh@college.edu', '2004-03-22', 4, 2023),
('Deepika','Rao', 'deepika.rao@college.edu', '2003-08-09', 1, 2022);
-- courses
INSERT INTO courses (course_name, course_code, credits, department_id) VALUES
('Data Structures & Algorithms', 'CS101', 4, 1),
('Database Management Systems', 'CS102', 3, 1),
('Object Oriented Programming', 'CS103', 4, 1),
('Circuit Theory', 'EC101', 3, 2),
('Thermodynamics', 'ME101', 3, 3);
-- enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2022-07-01', 'A'), (1, 2, '2022-07-01', 'B'),
(2, 1, '2022-07-01', 'B'), (2, 3, '2022-07-01', 'A'),
(3, 4, '2021-07-01', 'A'), (4, 5, '2023-07-01', NULL),
(5, 1, '2022-07-01', 'C'), (5, 2, '2022-07-01', 'A'),
(6, 4, '2021-07-01', 'B'), (7, 5, '2023-07-01', NULL),
(8, 1, '2022-07-01', 'A'), (8, 3, '2022-07-01', 'B');

SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;
SELECT * FROM professors;

-----------------------------------------------------------
-- Task 2: Normalization Analysis
-----------------------------------------------------------

-- 1NF (First Normal Form)
-- Every column stores a single (atomic) value.Examples:
--  1. first_name contains only one name.
--  2. email contains only one email address.
--  3. department_id contains only one department.
-- Hypothetical violation:
-- If phone_number stored '9876543210,9123456780' in one field,
-- the column would contain multiple values and violate 1NF.

-- 2NF (Second Normal Form)
-- Every non-key attribute depends on the whole primary key.
-- In enrollments, the candidate key is (student_id, course_id).
-- enrollment_date and grade describe the student's enrollment
-- in a specific course, so they depend on both student_id and course_id.
-- Therefore the schema satisfies 2NF.

-- 3NF (Third Normal Form)
-- No non-key attribute depends on another non-key attribute.
-- Example:
-- If dept_name were stored in students, then
-- student_id -> department_id -> dept_name
-- would create a transitive dependency.
-- Instead, dept_name is stored only in departments and linked
-- using department_id, so the schema satisfies 3NF.

-- 3NF Analysis for Enrollments
-- The enrollments table contains only attributes that describe
-- the relationship between a student and a course.
-- grade and enrollment_date depend directly on the enrollment.
-- There are no transitive dependencies, so the table satisfies 3NF.

-----------------------------------------------------------
-- Task 3: Alter and Extend Schema
------------------------------------------------------------

-- 10. Add a column phone_number VARCHAR(15) to the students table.
ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);
-- 11. Add a column max_seats INT DEFAULT 60 to the courses table.
ALTER TABLE courses ADD COLUMN max_seats INT DEFAULT(60);
-- 12. Add a CHECK constraint to enrollments ensuring grade is one of ('A','B','C','D','F') or NULL.
ALTER TABLE enrollments ADD CONSTRAINT Grade_Checker CHECK (grade IN ('A','B','C','D','F') OR grade is NULL) ;
-- 13. Rename the hod_name column in departments to head_of_dept (PostgreSQL: ALTER COLUMN ... 
ALTER TABLE departments RENAME COLUMN hod_name TO head_of_dept;
-- 14. Drop the phone_number column you added in step 1 (simulate a schema rollback).
ALTER TABLE students DROP COLUMN phone_number;


