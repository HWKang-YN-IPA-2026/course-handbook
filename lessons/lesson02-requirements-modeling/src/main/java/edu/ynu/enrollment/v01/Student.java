package edu.ynu.enrollment.v01;

import java.util.Objects;

public record Student(String studentId, StudentStatus status) {
    public Student {
        Objects.requireNonNull(studentId, "studentId");
        Objects.requireNonNull(status, "status");
    }

    public boolean isActive() {
        return status == StudentStatus.ACTIVE;
    }
}
