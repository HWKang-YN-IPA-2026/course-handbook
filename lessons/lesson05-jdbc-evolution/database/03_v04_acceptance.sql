\set ON_ERROR_STOP on

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='course' AND column_name='retake_policy'
  ) THEN RAISE EXCEPTION 'AC-401 FAIL: retake_policy missing'; END IF;
  RAISE NOTICE 'AC-401 PASS: v0.4 history columns exist';
END $$;

DO $$
DECLARE passed_count integer;
DECLARE failed_count integer;
BEGIN
  SELECT count(*) FILTER (WHERE passed), count(*) FILTER (WHERE NOT passed)
    INTO passed_count, failed_count
  FROM enrollment WHERE term_id='2026-SPRING';
  IF passed_count <> 1 OR failed_count <> 1 THEN
    RAISE EXCEPTION 'AC-402 FAIL: history fixtures invalid';
  END IF;
  RAISE NOTICE 'AC-402 PASS: passed and failed histories are reproducible';
END $$;

DO $$
BEGIN
  IF (SELECT capacity FROM teaching_class WHERE class_id='CS102-01') <> 1 THEN
    RAISE EXCEPTION 'AC-403 FAIL: concurrency fixture invalid';
  END IF;
  RAISE NOTICE 'AC-403 PASS: one-seat concurrency fixture exists';
END $$;
