\echo 'DML3 UPDATE前用同一WHERE确认，修改后ROLLBACK'
SELECT sharing_id, quota
FROM course_sharing
WHERE course_id='MATH101'
  AND partner_school_id='PARTNER'
  AND term_id='2026-FALL';
BEGIN;
UPDATE course_sharing
SET quota = 2
WHERE course_id='MATH101'
  AND partner_school_id='PARTNER'
  AND term_id='2026-FALL';
SELECT partner_school_id, quota FROM course_sharing ORDER BY partner_school_id;
ROLLBACK;

\echo 'DML4 只删除本事务创建的临时数据'
BEGIN;
INSERT INTO student(student_id, student_name, status, school_id)
VALUES ('TMP01', '临时学生', 'ACTIVE', 'YNU');
DELETE FROM student WHERE student_id='TMP01';
SELECT count(*) AS temp_student_after_delete FROM student WHERE student_id='TMP01';
ROLLBACK;

\echo 'DML5 故意遗漏WHERE，观察后ROLLBACK'
BEGIN;
UPDATE course_sharing SET quota = 0;
SELECT partner_school_id, quota FROM course_sharing ORDER BY partner_school_id;
ROLLBACK;
SELECT partner_school_id, quota AS quota_after_rollback
FROM course_sharing ORDER BY partner_school_id;
