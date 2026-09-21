-- AC-006：class_id属于MATH101，但故意写成CS101，复合外键应拒绝。
INSERT INTO course(course_id, course_name) VALUES ('CS101', '程序设计基础')
ON CONFLICT (course_id) DO NOTHING;

INSERT INTO enrollment(student_id, class_id, course_id, term_id)
VALUES ('S002', 'MATH101-02', 'CS101', '2026-FALL');
