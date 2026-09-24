-- 每一行测试数据对应一个共享资格场景。
INSERT INTO school(school_id, school_name) VALUES
('PARTNER', '共享高校'), ('OTHER', '未签约高校');
INSERT INTO student(student_id, student_name, status, school_id) VALUES
('E001', '外校甲', 'ACTIVE', 'PARTNER'),
('E002', '外校乙', 'ACTIVE', 'PARTNER'),
('X001', '未签约学生', 'ACTIVE', 'OTHER');
UPDATE teaching_class
SET external_capacity = CASE class_id WHEN 'MATH101-01' THEN 2 WHEN 'MATH101-02' THEN 1 ELSE 0 END;
INSERT INTO course_sharing(course_id, host_school_id, partner_school_id, term_id, quota, valid_from, valid_to) VALUES
('MATH101', 'YNU', 'PARTNER', '2026-FALL', 1, DATE '2026-09-01', DATE '2027-01-31'),
('MATH101', 'YNU', 'OTHER', '2026-FALL', 2, DATE '2025-09-01', DATE '2026-01-31');
