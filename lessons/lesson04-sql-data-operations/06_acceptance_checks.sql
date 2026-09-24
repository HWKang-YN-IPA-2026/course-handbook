-- AC-301：v0.3结构迁移和学校回填。
DO $$ BEGIN
  IF (SELECT count(*) FROM student WHERE school_id IS NULL) <> 0
  THEN RAISE EXCEPTION 'AC-301 failed'; END IF;
  RAISE NOTICE 'AC-301 PASS: v0.3 migration and backfill';
END $$;

-- AC-302：固定基线包含两班和一条初始选课。
DO $$ BEGIN
  IF (SELECT count(*) FROM teaching_class WHERE course_id='MATH101') <> 2
     OR (SELECT count(*) FROM enrollment) <> 1
  THEN RAISE EXCEPTION 'AC-302 failed'; END IF;
  RAISE NOTICE 'AC-302 PASS: fixed baseline rows';
END $$;

-- AC-303：排序和聚合练习的预期值稳定。
DO $$ BEGIN
  IF (SELECT max(capacity) FROM teaching_class) <> 40
     OR (SELECT min(capacity) FROM teaching_class) <> 35
  THEN RAISE EXCEPTION 'AC-303 failed'; END IF;
  RAISE NOTICE 'AC-303 PASS: aggregate expectations';
END $$;

-- AC-304：INSERT演示回滚后没有残留。
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM enrollment WHERE student_id='S002')
  THEN RAISE EXCEPTION 'AC-304 failed'; END IF;
  RAISE NOTICE 'AC-304 PASS: insert rollback has no residue';
END $$;

-- AC-305：临时DELETE演示没有改变学生基线。
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM student WHERE student_id='TMP01')
     OR (SELECT count(*) FROM student) <> 5
  THEN RAISE EXCEPTION 'AC-305 failed'; END IF;
  RAISE NOTICE 'AC-305 PASS: temporary delete is isolated';
END $$;

-- AC-306：无WHERE UPDATE回滚后配额恢复。
DO $$ BEGIN
  IF (SELECT quota FROM course_sharing
      WHERE course_id='MATH101' AND partner_school_id='PARTNER'
        AND term_id='2026-FALL') <> 1
     OR (SELECT quota FROM course_sharing
         WHERE course_id='MATH101' AND partner_school_id='OTHER'
           AND term_id='2026-FALL') <> 2
  THEN RAISE EXCEPTION 'AC-306 failed'; END IF;
  RAISE NOTICE 'AC-306 PASS: unsafe update rolled back';
END $$;
