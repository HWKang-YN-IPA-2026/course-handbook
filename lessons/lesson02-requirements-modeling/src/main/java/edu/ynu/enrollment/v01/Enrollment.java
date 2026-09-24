package edu.ynu.enrollment.v01;

import java.time.LocalDateTime;

public record Enrollment(String enrollmentId, String studentId, String courseId,
                         LocalDateTime createdAt) {
}
