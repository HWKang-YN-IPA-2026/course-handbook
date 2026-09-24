\echo 'DML1 成功INSERT后ROLLBACK恢复基线'
BEGIN;
INSERT INTO enrollment(student_id, class_id, course_id, term_id)
VALUES ('S002', 'MATH101-02', 'MATH101', '2026-FALL');
SELECT count(*) AS count_inside_transaction FROM enrollment;
ROLLBACK;
SELECT count(*) AS count_after_rollback FROM enrollment;

\echo 'DML2 重复选课由唯一约束拒绝'
DO $$
DECLARE rejected boolean := false;
BEGIN
  BEGIN
    INSERT INTO enrollment(student_id, class_id, course_id, term_id)
    VALUES ('S001', 'MATH101-02', 'MATH101', '2026-FALL');
  EXCEPTION WHEN unique_violation THEN
    rejected := true;
    RAISE NOTICE 'EXPECTED: same student/course/term rejected';
  END;
  IF NOT rejected THEN RAISE EXCEPTION 'duplicate enrollment was accepted'; END IF;
END $$;
