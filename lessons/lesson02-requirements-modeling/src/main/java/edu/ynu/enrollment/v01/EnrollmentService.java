package edu.ynu.enrollment.v01;

import java.time.Clock;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.function.Supplier;

public final class EnrollmentService {
    private final EnrollmentRepository repository;
    private final Supplier<String> idGenerator;
    private final Clock clock;

    public EnrollmentService(EnrollmentRepository repository,
                             Supplier<String> idGenerator,
                             Clock clock) {
        this.repository = Objects.requireNonNull(repository, "repository");
        this.idGenerator = Objects.requireNonNull(idGenerator, "idGenerator");
        this.clock = Objects.requireNonNull(clock, "clock");
    }

    public EnrollmentResult enroll(EnrollmentRequest request) {
        Student student = request == null ? null : request.student();
        Course course = request == null ? null : request.course();

        // BR-001：学生存在且状态正常。
        if (student == null || !student.isActive()) {
            return EnrollmentResult.failure(ResultCode.STUDENT_INACTIVE);
        }

        // BR-002：课程存在且开放。
        if (course == null || !course.isOpen()) {
            return EnrollmentResult.failure(ResultCode.COURSE_CLOSED);
        }

        // BR-004：同一学生和课程不存在有效记录。
        if (repository.exists(student.studentId(), course.courseId())) {
            return EnrollmentResult.failure(ResultCode.DUPLICATE_ENROLLMENT);
        }

        // 数据保护：历史记录数超过容量，说明基础数据不一致。
        if (course.enrolledCount() > course.capacity()) {
            return EnrollmentResult.failure(ResultCode.DATA_ERROR);
        }

        // BR-003：已选人数必须小于容量。
        if (!course.hasSeat()) {
            return EnrollmentResult.failure(ResultCode.COURSE_FULL);
        }

        String enrollmentId = idGenerator.get();
        repository.add(new Enrollment(enrollmentId, student.studentId(), course.courseId(),
                LocalDateTime.now(clock)));
        course.increaseEnrollment();
        return EnrollmentResult.success(enrollmentId);
    }
}
