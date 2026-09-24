-- 历史学期：S001 已通过，S002 未通过。
INSERT INTO academic_term(term_id, term_name, start_date, end_date) VALUES
('2026-SPRING', '2025-2026学年春季学期', DATE '2026-02-23', DATE '2026-07-10');

INSERT INTO teaching_class(
    class_id, course_id, term_id, class_name, teacher_name,
    schedule_text, capacity, status, external_capacity
) VALUES
('MATH101-SPRING-01', 'MATH101', '2026-SPRING', '高等数学历史班',
 '王老师', '历史记录', 40, 'CLOSED', 0);

INSERT INTO enrollment(
    student_id, class_id, course_id, term_id, enrolled_at, final_score, passed
) VALUES
('S001', 'MATH101-SPRING-01', 'MATH101', '2026-SPRING', TIMESTAMP '2026-02-23 08:00:00', 85, TRUE),
('S002', 'MATH101-SPRING-01', 'MATH101', '2026-SPRING', TIMESTAMP '2026-02-23 08:01:00', 45, FALSE);

-- 并发实验：一个座位、两名本校学生。
INSERT INTO student(student_id, student_name, status, school_id) VALUES
('C001', '并发学生甲', 'ACTIVE', 'YNU'),
('C002', '并发学生乙', 'ACTIVE', 'YNU');

INSERT INTO course(course_id, course_name, host_school_id, retake_policy) VALUES
('CS102', '程序设计进阶', 'YNU', 'FAILED_ONLY');

INSERT INTO teaching_class(
    class_id, course_id, term_id, class_name, teacher_name,
    schedule_text, capacity, status, external_capacity
) VALUES
('CS102-01', 'CS102', '2026-FALL', '程序设计进阶01班',
 '赵老师', '周五5-6节', 1, 'OPEN', 0);
