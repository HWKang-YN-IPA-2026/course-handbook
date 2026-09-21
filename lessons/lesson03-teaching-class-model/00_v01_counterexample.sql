-- v0.1反例：Course同时承担课程定义和开课实例。
DROP TABLE IF EXISTS v01_enrollment;
DROP TABLE IF EXISTS v01_course;
DROP TABLE IF EXISTS v01_student;

CREATE TABLE v01_student (
    student_id VARCHAR(20) PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL
);

CREATE TABLE v01_course (
    course_id VARCHAR(20) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

CREATE TABLE v01_enrollment (
    student_id VARCHAR(20) NOT NULL REFERENCES v01_student(student_id),
    course_id VARCHAR(20) NOT NULL REFERENCES v01_course(course_id),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO v01_student VALUES ('S001', '张同学');
INSERT INTO v01_course VALUES ('MATH101', '高等数学');
INSERT INTO v01_enrollment VALUES ('S001', 'MATH101');

-- 结果只能说明S001选择了MATH101，不能回答教学班、教师、时间和容量。
SELECT s.student_id, s.student_name, c.course_id, c.course_name
FROM v01_enrollment e
JOIN v01_student s ON s.student_id = e.student_id
JOIN v01_course c ON c.course_id = e.course_id;

-- 讨论：若把01班和02班复制成两条Course，课程定义会重复；
-- 若只增加class_name字段，一条Course仍无法同时表示多个教学班。

