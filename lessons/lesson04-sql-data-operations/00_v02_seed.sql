INSERT INTO student(student_id, student_name, status) VALUES
('S001', '张同学', 'ACTIVE'),
('S002', '李同学', 'ACTIVE');

INSERT INTO academic_term(term_id, term_name, start_date, end_date) VALUES
('2026-FALL', '2026-2027学年秋季学期', DATE '2026-09-01', DATE '2027-01-20');

INSERT INTO course(course_id, course_name) VALUES
('MATH101', '高等数学');

INSERT INTO teaching_class(
    class_id, course_id, term_id, class_name,
    teacher_name, schedule_text, capacity, status
) VALUES
('MATH101-01', 'MATH101', '2026-FALL', '高等数学01班',
 '张老师', '周一1-2节', 40, 'OPEN'),
('MATH101-02', 'MATH101', '2026-FALL', '高等数学02班',
 '李老师', '周三3-4节', 35, 'OPEN');

INSERT INTO enrollment(student_id, class_id, course_id, term_id)
VALUES ('S001', 'MATH101-01', 'MATH101', '2026-FALL');
