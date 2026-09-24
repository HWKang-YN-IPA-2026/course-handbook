-- v0.2 -> v0.3：加入学校、共享协议与外校容量。
CREATE TABLE school (
    school_id VARCHAR(20) PRIMARY KEY,
    school_name VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO school(school_id, school_name) VALUES ('YNU', '云南大学');
ALTER TABLE student ADD COLUMN school_id VARCHAR(20);
UPDATE student SET school_id = 'YNU' WHERE school_id IS NULL;
ALTER TABLE student ALTER COLUMN school_id SET NOT NULL;
ALTER TABLE student ADD CONSTRAINT fk_student_school FOREIGN KEY (school_id) REFERENCES school(school_id);
ALTER TABLE course ADD COLUMN host_school_id VARCHAR(20);
UPDATE course SET host_school_id = 'YNU' WHERE host_school_id IS NULL;
ALTER TABLE course ALTER COLUMN host_school_id SET NOT NULL;
ALTER TABLE course ADD CONSTRAINT fk_course_school FOREIGN KEY (host_school_id) REFERENCES school(school_id);
ALTER TABLE teaching_class ADD COLUMN external_capacity INT NOT NULL DEFAULT 0;
ALTER TABLE teaching_class ADD CONSTRAINT ck_external_capacity CHECK (external_capacity >= 0 AND external_capacity <= capacity);
CREATE TABLE course_sharing (
    sharing_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id VARCHAR(20) NOT NULL REFERENCES course(course_id),
    host_school_id VARCHAR(20) NOT NULL REFERENCES school(school_id),
    partner_school_id VARCHAR(20) NOT NULL REFERENCES school(school_id),
    term_id VARCHAR(20) NOT NULL REFERENCES academic_term(term_id),
    quota INT NOT NULL CHECK (quota >= 0),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    CHECK (host_school_id <> partner_school_id),
    CHECK (valid_from <= valid_to),
    UNIQUE (course_id, partner_school_id, term_id)
);
