package edu.ynu.enrollment.v01;

import java.util.Objects;

public final class Course {
    private final String courseId;
    private final String name;
    private final boolean open;
    private final int capacity;
    private int enrolledCount;

    public Course(String courseId, String name, boolean open, int capacity, int enrolledCount) {
        this.courseId = Objects.requireNonNull(courseId, "courseId");
        this.name = Objects.requireNonNull(name, "name");
        if (capacity < 0) throw new IllegalArgumentException("INVALID_CAPACITY");
        if (enrolledCount < 0) throw new IllegalArgumentException("INVALID_ENROLLED_COUNT");
        this.open = open;
        this.capacity = capacity;
        this.enrolledCount = enrolledCount;
    }

    public String courseId() { return courseId; }
    public String name() { return name; }
    public boolean isOpen() { return open; }
    public int capacity() { return capacity; }
    public int enrolledCount() { return enrolledCount; }
    public boolean hasSeat() { return enrolledCount < capacity; }
    public void increaseEnrollment() { enrolledCount++; }
}
