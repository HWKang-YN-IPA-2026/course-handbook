package edu.ynu.p1.v04;

public record EnrollmentResult(boolean success, String code, String message) {
    public static EnrollmentResult accepted() {
        return new EnrollmentResult(true, "ENROLLED", "选课成功");
    }
    public static EnrollmentResult rejected(String code, String message) {
        return new EnrollmentResult(false, code, message);
    }
}
