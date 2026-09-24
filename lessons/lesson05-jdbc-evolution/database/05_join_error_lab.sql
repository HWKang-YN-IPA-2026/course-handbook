-- 教师按段执行。本文件故意保留错误，用于观察和诊断，不能加入自动准备脚本。
\set VERBOSITY verbose

-- E1：遗漏连接条件，行数异常增大。
SELECT s.student_id, e.course_id
FROM student s CROSS JOIN enrollment e
WHERE s.student_id = 'S002';

-- E2：字段不存在。PostgreSQL 应报告 SQLSTATE 42703。
SELECT e.score
FROM enrollment e;

-- E3：别名使用错误。PostgreSQL 应提示缺少 FROM 子句项。
SELECT student.student_name
FROM student s;
