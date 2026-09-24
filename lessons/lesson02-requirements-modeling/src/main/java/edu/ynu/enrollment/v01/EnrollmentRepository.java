package edu.ynu.enrollment.v01;

import java.util.ArrayList;
import java.util.List;

public final class EnrollmentRepository {
    private final List<Enrollment> records = new ArrayList<>();

    public boolean exists(String studentId, String courseId) {
        return records.stream().anyMatch(record ->
                record.studentId().equals(studentId) && record.courseId().equals(courseId));
    }

    public void add(Enrollment enrollment) {
        records.add(enrollment);
    }

    public int count() {
        return records.size();
    }
}
