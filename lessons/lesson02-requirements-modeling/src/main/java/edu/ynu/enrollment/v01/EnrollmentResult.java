package edu.ynu.enrollment.v01;

public record EnrollmentResult(ResultCode code, String enrollmentId) {
    public static EnrollmentResult success(String enrollmentId) {
        return new EnrollmentResult(ResultCode.SUCCESS, enrollmentId);
    }

    public static EnrollmentResult failure(ResultCode code) {
        if (code == ResultCode.SUCCESS) throw new IllegalArgumentException("failure code required");
        return new EnrollmentResult(code, null);
    }

    public boolean accepted() {
        return code == ResultCode.SUCCESS;
    }
}
