package edu.ynu.enrollment.v01;

import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.concurrent.atomic.AtomicInteger;

public final class AcceptanceCheck {
    private static int passed;

    public static void main(String[] args) {
        normalEnrollment();
        fullCourse();
        closedCourse();
        duplicateEnrollment();
        inactiveStudent();
        System.out.println(passed + "/5 scenarios passed");
    }

    private static void normalEnrollment() {
        Fixture f = new Fixture();
        Course course = new Course("C001", "Java程序设计", true, 2, 1);
        int before = f.repository.count();
        EnrollmentResult result = f.service.enroll(new EnrollmentRequest(f.activeStudent, course));
        equal(ResultCode.SUCCESS, result.code(), "AC-001 result");
        equal("E001", result.enrollmentId(), "AC-001 id");
        equal(before + 1, f.repository.count(), "AC-001 record count");
        equal(2, course.enrolledCount(), "AC-001 enrolled count");
        pass("AC-001 正常选课");
    }

    private static void fullCourse() {
        Fixture f = new Fixture();
        Course course = new Course("C001", "Java程序设计", true, 2, 2);
        int before = f.repository.count();
        EnrollmentResult result = f.service.enroll(new EnrollmentRequest(f.activeStudent, course));
        equal(ResultCode.COURSE_FULL, result.code(), "AC-002 result");
        equal(before, f.repository.count(), "AC-002 record count");
        equal(2, course.enrolledCount(), "AC-002 enrolled count");
        pass("AC-002 课程满员");
    }

    private static void closedCourse() {
        Fixture f = new Fixture();
        Course course = new Course("C001", "Java程序设计", false, 2, 0);
        int before = f.repository.count();
        EnrollmentResult result = f.service.enroll(new EnrollmentRequest(f.activeStudent, course));
        equal(ResultCode.COURSE_CLOSED, result.code(), "AC-003 result");
        equal(before, f.repository.count(), "AC-003 record count");
        pass("AC-003 课程关闭");
    }

    private static void duplicateEnrollment() {
        Fixture f = new Fixture();
        Course course = new Course("C001", "Java程序设计", true, 2, 0);
        equal(ResultCode.SUCCESS,
                f.service.enroll(new EnrollmentRequest(f.activeStudent, course)).code(),
                "AC-004 setup");
        int before = f.repository.count();
        EnrollmentResult result = f.service.enroll(new EnrollmentRequest(f.activeStudent, course));
        equal(ResultCode.DUPLICATE_ENROLLMENT, result.code(), "AC-004 result");
        equal(before, f.repository.count(), "AC-004 record count");
        pass("AC-004 重复选课");
    }

    private static void inactiveStudent() {
        Fixture f = new Fixture();
        Course course = new Course("C001", "Java程序设计", true, 2, 0);
        Student inactive = new Student("S002", StudentStatus.INACTIVE);
        int before = f.repository.count();
        EnrollmentResult result = f.service.enroll(new EnrollmentRequest(inactive, course));
        equal(ResultCode.STUDENT_INACTIVE, result.code(), "AC-005 result");
        equal(before, f.repository.count(), "AC-005 record count");
        pass("AC-005 学生状态异常");
    }

    private static void equal(Object expected, Object actual, String message) {
        if (!expected.equals(actual)) {
            throw new AssertionError(message + ": expected=" + expected + ", actual=" + actual);
        }
    }

    private static void pass(String name) {
        passed++;
        System.out.println("PASS " + name);
    }

    private static final class Fixture {
        private final EnrollmentRepository repository = new EnrollmentRepository();
        private final AtomicInteger ids = new AtomicInteger(1);
        private final Student activeStudent = new Student("S001", StudentStatus.ACTIVE);
        private final EnrollmentService service = new EnrollmentService(
                repository,
                () -> "E%03d".formatted(ids.getAndIncrement()),
                Clock.fixed(Instant.parse("2026-09-12T01:00:00Z"), ZoneOffset.UTC));
    }
}
