package edu.ynu.p1.v04;

import java.time.LocalDate;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public final class TeacherDemo {
    private static final LocalDate DEMO_DATE = LocalDate.of(2026, 9, 23);

    public static void main(String[] args) throws Exception {
        EnrollmentService service = new EnrollmentService(new ConnectionFactory(DbConfig.load()));
        show("01 已通过者再次修读", service.enroll("S001", "MATH101-02", DEMO_DATE));
        show("02 未通过者重修", service.enroll("S002", "MATH101-02", DEMO_DATE));
        show("03 过期协议的外校生", service.enroll("X001", "MATH101-02", DEMO_DATE));

        CountDownLatch ready = new CountDownLatch(2);
        CountDownLatch start = new CountDownLatch(1);
        ExecutorService pool = Executors.newFixedThreadPool(2);
        try {
            Future<EnrollmentResult> a = pool.submit(() -> race(service, ready, start, "C001"));
            Future<EnrollmentResult> b = pool.submit(() -> race(service, ready, start, "C002"));
            ready.await();
            System.out.println("04 两个请求已就绪，同时竞争 CS102-01 的最后一个座位");
            start.countDown();
            List<EnrollmentResult> results = List.of(a.get(), b.get());
            show("   C001", results.get(0));
            show("   C002", results.get(1));
            long success = results.stream().filter(EnrollmentResult::success).count();
            System.out.printf("   预期：成功 1 人；实际：成功 %d 人%n", success);
        } finally {
            pool.shutdown();
        }
    }

    private static EnrollmentResult race(EnrollmentService service, CountDownLatch ready,
                                         CountDownLatch start, String studentId) throws Exception {
        ready.countDown();
        start.await();
        return service.enroll(studentId, "CS102-01", DEMO_DATE);
    }

    private static void show(String label, EnrollmentResult result) {
        System.out.printf("%-25s -> %s / %s / %s%n", label,
            result.success() ? "PASS" : "REJECT", result.code(), result.message());
    }
}
