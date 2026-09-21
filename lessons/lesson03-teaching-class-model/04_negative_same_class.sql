-- AC-004：S001已经选择MATH101-01，再次选择同班，应失败。
INSERT INTO enrollment(student_id, class_id, course_id, term_id)
VALUES ('S001', 'MATH101-01', 'MATH101', '2026-FALL');
