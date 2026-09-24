DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS teaching_class;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS academic_term;
DROP TABLE IF EXISTS student;

CREATE TABLE student (
    student_id VARCHAR(20) PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'SUSPENDED'))
);

CREATE TABLE academic_term (
    term_id VARCHAR(20) PRIMARY KEY,
    term_name VARCHAR(50) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CHECK (start_date < end_date)
);

CREATE TABLE course (
    course_id VARCHAR(20) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

CREATE TABLE teaching_class (
    class_id VARCHAR(20) PRIMARY KEY,
    course_id VARCHAR(20) NOT NULL REFERENCES course(course_id),
    term_id VARCHAR(20) NOT NULL REFERENCES academic_term(term_id),
    class_name VARCHAR(100) NOT NULL,
    teacher_name VARCHAR(50) NOT NULL,
    schedule_text VARCHAR(100) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('OPEN', 'CLOSED')),
    UNIQUE (class_id, course_id, term_id)
);

CREATE TABLE enrollment (
    enrollment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL REFERENCES student(student_id),
    class_id VARCHAR(20) NOT NULL,
    course_id VARCHAR(20) NOT NULL,
    term_id VARCHAR(20) NOT NULL,
    enrolled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id, course_id, term_id)
        REFERENCES teaching_class(class_id, course_id, term_id),
    UNIQUE (student_id, course_id, term_id)
);

CREATE INDEX idx_teaching_class_course_term
    ON teaching_class(course_id, term_id);

CREATE INDEX idx_enrollment_class
    ON enrollment(class_id);
