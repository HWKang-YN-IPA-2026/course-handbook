-- AC-005：S001改选同课程同学期的02班，仍应失败。
-- UNIQUE(student_id, class_id)无法阻止本条；
-- UNIQUE(student_id, course_id, term_id)负责拒绝。
INSERT INTO enrollment(student_id, class_id, course_id, term_id)
VALUES ('S001', 'MATH101-02', 'MATH101', '2026-FALL');
