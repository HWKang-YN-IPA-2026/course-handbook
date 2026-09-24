\set ON_ERROR_STOP on

-- 一行表示一名学生在一个学期的一次课程修读结果。
SELECT s.student_id,
       s.student_name,
       c.course_name,
       t.term_name,
       e.final_score,
       e.passed
FROM student s
JOIN enrollment e ON e.student_id = s.student_id
JOIN course c ON c.course_id = e.course_id
JOIN academic_term t ON t.term_id = e.term_id
WHERE s.student_id = 'S002'
ORDER BY t.start_date, c.course_id;
