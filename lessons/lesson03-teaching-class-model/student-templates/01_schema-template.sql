-- 用本组设计完成。要求可以从空库重复执行。
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS teaching_class;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS academic_term;
DROP TABLE IF EXISTS student;

-- TODO 1: student
-- TODO 2: academic_term
-- TODO 3: course
-- TODO 4: teaching_class，包含Course与AcademicTerm外键
-- TODO 5: enrollment，表达同课程同学期重复约束
-- TODO 6: 为常用外键查询增加有理由的索引
