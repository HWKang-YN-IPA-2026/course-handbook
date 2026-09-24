package edu.ynu.p1.v04;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public final class IntegrationCheck {
    private static final LocalDate AS_OF = LocalDate.of(2026, 9, 23);

    public static void main(String[] args) throws Exception {
        ConnectionFactory factory = new ConnectionFactory(DbConfig.load());
        EnrollmentService service = new EnrollmentService(factory);
        expect("AC-404", service.enroll("S001", "MATH101-02", AS_OF), false, "RETAKE_NOT_ALLOWED");
        expect("AC-405", service.enroll("S002", "MATH101-02", AS_OF), true, "ENROLLED");
        expect("AC-406", service.enroll("S002", "MATH101-01", AS_OF), false, "DUPLICATE_TERM_COURSE");
        expect("AC-407", service.enroll("X001", "MATH101-02", AS_OF), false, "NO_ACTIVE_AGREEMENT");
        expect("AC-408", service.enroll("E001", "MATH101-02", AS_OF), true, "ENROLLED");
        expect("AC-409", service.enroll("E002", "MATH101-02", AS_OF), false, "EXTERNAL_QUOTA_FULL");
        concurrentLastSeat(service);
        try (Connection c = factory.open(); Statement s = c.createStatement();
             ResultSet rs = s.executeQuery("SELECT count(*) FROM enrollment WHERE class_id='CS102-01'")) {
            rs.next();
            if (rs.getInt(1) != 1) throw new AssertionError("AC-411 FAIL: oversold seat");
        }
        System.out.println("AC-411 PASS: database contains exactly one concurrent winner");
        System.out.println("ALL LESSON-05 CHECKS PASSED");
    }

    private static void concurrentLastSeat(EnrollmentService service) throws Exception {
        CountDownLatch ready = new CountDownLatch(2);
        CountDownLatch start = new CountDownLatch(1);
        ExecutorService pool = Executors.newFixedThreadPool(2);
        try {
            Future<EnrollmentResult> a = pool.submit(() -> race(service, ready, start, "C001"));
            Future<EnrollmentResult> b = pool.submit(() -> race(service, ready, start, "C002"));
            ready.await(); start.countDown();
            List<EnrollmentResult> results = List.of(a.get(), b.get());
            long successes = results.stream().filter(EnrollmentResult::success).count();
            if (successes != 1) throw new AssertionError("AC-410 FAIL: successes=" + successes);
            System.out.println("AC-410 PASS: two concurrent requests produce one winner");
        } finally {
            pool.shutdown();
        }
    }

    private static EnrollmentResult race(EnrollmentService service, CountDownLatch ready,
                                         CountDownLatch start, String studentId) throws Exception {
        ready.countDown(); start.await();
        return service.enroll(studentId, "CS102-01", AS_OF);
    }

    private static void expect(String id, EnrollmentResult actual, boolean success, String code) {
        if (actual.success() != success || !code.equals(actual.code()))
            throw new AssertionError(id + " FAIL: " + actual);
        System.out.printf("%s PASS: %s%n", id, actual.code());
    }
}
