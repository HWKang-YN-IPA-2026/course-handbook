\echo 'Q1 开放教学班：SELECT / WHERE'
SELECT class_id, class_name, teacher_name, capacity
FROM teaching_class
WHERE status = 'OPEN'
ORDER BY class_id;

\echo 'Q2 容量排序：ORDER BY'
SELECT class_id, capacity
FROM teaching_class
ORDER BY capacity DESC, class_id ASC;

\echo 'Q3 整体统计：COUNT / MIN / MAX / AVG'
SELECT count(*) AS class_count,
       min(capacity) AS min_capacity,
       max(capacity) AS max_capacity,
       round(avg(capacity), 1) AS avg_capacity
FROM teaching_class;

\echo 'Q4 按课程统计教学班：GROUP BY'
SELECT course_id, count(*) AS class_count
FROM teaching_class
GROUP BY course_id
ORDER BY course_id;
