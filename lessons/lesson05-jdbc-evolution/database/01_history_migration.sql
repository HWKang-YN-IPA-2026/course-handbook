-- v0.3 -> v0.4：加入历史成绩与课程重修策略。
ALTER TABLE course
    ADD COLUMN retake_policy VARCHAR(30) NOT NULL DEFAULT 'FAILED_ONLY'
    CHECK (retake_policy IN ('FAILED_ONLY', 'ALLOW_IMPROVEMENT'));

ALTER TABLE enrollment ADD COLUMN final_score NUMERIC(5,2);
ALTER TABLE enrollment ADD COLUMN passed BOOLEAN;
ALTER TABLE enrollment ADD CONSTRAINT ck_enrollment_result
    CHECK (
        (final_score IS NULL AND passed IS NULL)
        OR
        (final_score BETWEEN 0 AND 100 AND passed IS NOT NULL)
    );

CREATE INDEX IF NOT EXISTS idx_enrollment_student_course
    ON enrollment(student_id, course_id);
CREATE INDEX IF NOT EXISTS idx_course_sharing_lookup
    ON course_sharing(course_id, partner_school_id, term_id, valid_from, valid_to);
