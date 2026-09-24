package edu.ynu.enrollment.v01;

import java.time.Clock;
import java.util.concurrent.atomic.AtomicInteger;

public final class BoundaryCheck {
    public static void main(String[] args) {
        rejectsInconsistentEnrollmentCount();
        rejectsNegativeCapacity();
        System.out.println("2/2 boundary checks passed");
    }

    private static void rejectsInconsistentEnrollmentCount() {
        EnrollmentRepository repository = new EnrollmentRepository();
        AtomicInteger ids = new AtomicInteger(1);
        EnrollmentService service = new EnrollmentService(repository,
                () -> "E%03d".formatted(ids.getAndIncrement()), Clock.systemUTC());
        Student student = new Student("S001", StudentStatus.ACTIVE);
        Course inconsistent = new Course("C001", "Java程序设计", true, 2, 3);
        EnrollmentResult result = service.enroll(new EnrollmentRequest(student, inconsistent));
        equal(ResultCode.DATA_ERROR, result.code(), "已选人数大于容量");
        equal(0, repository.count(), "数据异常时记录数不变");
        System.out.println("PASS capacity=2, enrolled=3 -> DATA_ERROR");
    }

    private static void rejectsNegativeCapacity() {
        try {
            new Course("C001", "Java程序设计", true, -1, 0);
            throw new AssertionError("负容量必须被拒绝");
        } catch (IllegalArgumentException expected) {
            equal("INVALID_CAPACITY", expected.getMessage(), "负容量结果");
        }
        System.out.println("PASS capacity=-1 -> INVALID_CAPACITY");
    }

    private static void equal(Object expected, Object actual, String message) {
        if (!expected.equals(actual)) {
            throw new AssertionError(message + ": expected=" + expected + ", actual=" + actual);
        }
    }
}
