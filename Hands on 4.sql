SELECT current_database();
-----------------------------------------------------------
-- HANDS-ON 4
-- Query Optimization - Indexes, EXPLAIN & N+1 Problem
-----------------------------------------------------------

-----------------------------------------------------------
-- Task 1 : Baseline Performance
-----------------------------------------------------------

-- 48. View execution plan

EXPLAIN
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- 49 & 50
-- After running EXPLAIN, copy the output here.
--
-- Example:
-- Seq Scan on students
-- Hash Join
-- Nested Loop
--
-- Estimated Cost : 25.40..48.70
--
-- Since the tables are small, PostgreSQL performs
-- a Sequential Scan instead of using indexes.

-----------------------------------------------------------
-- Task 2 : Create Indexes
-----------------------------------------------------------

-- 51. B-Tree index

CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);

-----------------------------------------------------------

-- 52. Composite Unique Index

CREATE UNIQUE INDEX idx_enrollments_student_course
ON enrollments(student_id, course_id);

-----------------------------------------------------------

-- 53. Course code index

CREATE INDEX idx_courses_course_code
ON courses(course_code);

-----------------------------------------------------------

-- 54. Run EXPLAIN again

EXPLAIN
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- Comment:
-- After creating indexes, PostgreSQL may use an
-- Index Scan instead of a Sequential Scan depending
-- on the table size and query planner.

-----------------------------------------------------------

-- 55. Partial Index

CREATE INDEX idx_pending_grades
ON enrollments(student_id)
WHERE grade IS NULL;