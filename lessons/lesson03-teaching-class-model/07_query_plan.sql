-- 索引用于提高常用过滤与连接查询的速度，不能替代约束。
EXPLAIN
SELECT class_id, teacher_name, schedule_text, capacity
FROM teaching_class
WHERE course_id = 'MATH101'
  AND term_id = '2026-FALL';

EXPLAIN
SELECT COUNT(*)
FROM enrollment
WHERE class_id = 'MATH101-01';

-- 小数据量时优化器可能选择顺序扫描，这是正常现象。
-- 教学重点是识别查询条件和索引列，而不是强行得到某一种执行计划。
