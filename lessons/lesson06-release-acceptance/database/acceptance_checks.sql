\set ON_ERROR_STOP on

DO $$ BEGIN
  IF (SELECT count(*) FROM information_schema.tables
      WHERE table_schema='public' AND table_name IN
      ('student','academic_term','course','teaching_class','enrollment','school','course_sharing')) <> 7
  THEN RAISE EXCEPTION 'AC-01 FAIL: core tables incomplete'; END IF;
  RAISE NOTICE 'AC-01 PASS: seven core tables exist';
END $$;

DO $$ BEGIN
  IF (SELECT count(*) FROM teaching_class WHERE course_id='MATH101' AND term_id='2026-FALL') <> 2
  THEN RAISE EXCEPTION 'AC-02 FAIL: two-class fixture missing'; END IF;
  RAISE NOTICE 'AC-02 PASS: one course has two teaching classes';
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid='enrollment'::regclass AND contype='u'
      AND pg_get_constraintdef(oid) LIKE '%student_id, course_id, term_id%'
  ) THEN RAISE EXCEPTION 'AC-03 FAIL: uniqueness constraint missing'; END IF;
  RAISE NOTICE 'AC-03 PASS: same course and term uniqueness is enforced';
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM course_sharing WHERE partner_school_id='PARTNER')
  THEN RAISE EXCEPTION 'AC-04 FAIL: sharing model has no agreement'; END IF;
  RAISE NOTICE 'AC-04 PASS: inter-school sharing model is populated';
END $$;

DO $$ BEGIN
  IF (SELECT count(*) FROM course_sharing
      WHERE DATE '2026-09-23' BETWEEN valid_from AND valid_to) <> 1
  THEN RAISE EXCEPTION 'AC-05 FAIL: active/expired fixtures invalid'; END IF;
  RAISE NOTICE 'AC-05 PASS: active and expired agreements are distinguishable';
END $$;

DO $$ BEGIN
  IF (SELECT count(*) FROM enrollment WHERE term_id='2026-SPRING' AND passed IS NOT NULL) <> 2
  THEN RAISE EXCEPTION 'AC-06 FAIL: historical results missing'; END IF;
  RAISE NOTICE 'AC-06 PASS: historical results exist';
END $$;

DO $$ BEGIN
  IF (SELECT retake_policy FROM course WHERE course_id='MATH101') <> 'FAILED_ONLY'
  THEN RAISE EXCEPTION 'AC-07 FAIL: retake policy invalid'; END IF;
  RAISE NOTICE 'AC-07 PASS: course retake policy is explicit';
END $$;

DO $$
DECLARE rejected boolean := false;
BEGIN
  BEGIN
    INSERT INTO enrollment(student_id,class_id,course_id,term_id)
    VALUES ('S001','MATH101-02','MATH101','2026-FALL');
  EXCEPTION WHEN unique_violation THEN rejected := true;
  END;
  IF NOT rejected THEN RAISE EXCEPTION 'AC-08 FAIL: duplicate accepted'; END IF;
  RAISE NOTICE 'AC-08 PASS: database rejects same-term duplicate';
END $$;

DO $$
BEGIN
  BEGIN
    INSERT INTO enrollment(student_id,class_id,course_id,term_id)
    VALUES ('C001','CS102-01','CS102','2026-FALL');
    RAISE EXCEPTION 'simulated failure';
  EXCEPTION WHEN raise_exception THEN NULL;
  END;
  IF EXISTS (SELECT 1 FROM enrollment WHERE student_id='C001' AND class_id='CS102-01')
  THEN RAISE EXCEPTION 'AC-09 FAIL: rollback left a row'; END IF;
  RAISE NOTICE 'AC-09 PASS: failed unit of work leaves no row';
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname='idx_enrollment_class')
     OR NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname='idx_enrollment_student_course')
  THEN RAISE EXCEPTION 'AC-10 FAIL: required indexes missing'; END IF;
  RAISE NOTICE 'AC-10 PASS: required lookup indexes exist';
END $$;
