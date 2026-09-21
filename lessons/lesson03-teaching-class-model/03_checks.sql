-- AC-001：两个教学班属于同一门课程、同一学期，且正常选课可查询。
SELECT tc.class_id, c.course_name, t.term_name,
       tc.class_name, tc.teacher_name, tc.schedule_text, tc.capacity
FROM teaching_class tc
JOIN course c ON c.course_id = tc.course_id
JOIN academic_term t ON t.term_id = tc.term_id
ORDER BY tc.class_id;

-- 应返回S001在MATH101的1条记录。
SELECT student_id, course_id, term_id, COUNT(*) AS enrollment_count
FROM enrollment
GROUP BY student_id, course_id, term_id;

-- 失败场景拆分在04—06脚本中，便于课堂逐个执行和解释。
