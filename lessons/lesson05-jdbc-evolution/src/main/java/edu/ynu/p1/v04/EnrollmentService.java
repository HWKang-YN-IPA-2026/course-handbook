package edu.ynu.p1.v04;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

public final class EnrollmentService {
    private final ConnectionFactory connections;

    public EnrollmentService(ConnectionFactory connections) {
        this.connections = connections;
    }

    public EnrollmentResult enroll(String studentId, String classId, LocalDate asOf) throws SQLException {
        try (Connection connection = connections.open()) {
            connection.setAutoCommit(false);
            try {
                ClassInfo target = lockClass(connection, classId);
                StudentInfo student = activeStudent(connection, studentId);
                rejectForbiddenRetake(connection, studentId, target);
                rejectSameTermDuplicate(connection, studentId, target);
                if (!student.schoolId().equals(target.hostSchoolId())) {
                    checkExternalEligibilityAndQuota(connection, student, target, asOf);
                }
                rejectFullClass(connection, target);
                insertEnrollment(connection, studentId, target);
                connection.commit();
                return EnrollmentResult.accepted();
            } catch (RuleViolation problem) {
                connection.rollback();
                return EnrollmentResult.rejected(problem.code(), problem.getMessage());
            } catch (SQLException problem) {
                connection.rollback();
                throw problem;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    private ClassInfo lockClass(Connection connection, String classId) throws SQLException, RuleViolation {
        String sql = """
            SELECT tc.class_id, tc.course_id, tc.term_id, tc.capacity,
                   tc.external_capacity, tc.status, c.host_school_id, c.retake_policy
            FROM teaching_class tc JOIN course c ON c.course_id=tc.course_id
            WHERE tc.class_id=? FOR UPDATE OF tc
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new RuleViolation("CLASS_NOT_FOUND", "教学班不存在");
                if (!"OPEN".equals(rs.getString("status")))
                    throw new RuleViolation("CLASS_CLOSED", "教学班未开放");
                return new ClassInfo(
                    rs.getString("class_id"), rs.getString("course_id"), rs.getString("term_id"),
                    rs.getInt("capacity"), rs.getInt("external_capacity"),
                    rs.getString("host_school_id"), rs.getString("retake_policy"));
            }
        }
    }

    private StudentInfo activeStudent(Connection connection, String studentId)
            throws SQLException, RuleViolation {
        String sql = "SELECT school_id, status FROM student WHERE student_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new RuleViolation("STUDENT_NOT_FOUND", "学生不存在");
                if (!"ACTIVE".equals(rs.getString("status")))
                    throw new RuleViolation("STUDENT_INACTIVE", "学生状态不是 ACTIVE");
                return new StudentInfo(studentId, rs.getString("school_id"));
            }
        }
    }

    private void rejectSameTermDuplicate(Connection connection, String studentId, ClassInfo target)
            throws SQLException, RuleViolation {
        String sql = "SELECT 1 FROM enrollment WHERE student_id=? AND course_id=? AND term_id=?";
        if (exists(connection, sql, studentId, target.courseId(), target.termId()))
            throw new RuleViolation("DUPLICATE_TERM_COURSE", "同一学期不能重复选同一门课程");
    }

    private void rejectForbiddenRetake(Connection connection, String studentId, ClassInfo target)
            throws SQLException, RuleViolation {
        if (!"FAILED_ONLY".equals(target.retakePolicy())) return;
        String sql = "SELECT 1 FROM enrollment WHERE student_id=? AND course_id=? AND passed IS TRUE";
        if (exists(connection, sql, studentId, target.courseId()))
            throw new RuleViolation("RETAKE_NOT_ALLOWED", "课程策略只允许未通过者重修");
    }

    private void checkExternalEligibilityAndQuota(Connection connection, StudentInfo student,
                                                   ClassInfo target, LocalDate asOf)
            throws SQLException, RuleViolation {
        String agreementSql = """
            SELECT quota FROM course_sharing
            WHERE course_id=? AND host_school_id=? AND partner_school_id=? AND term_id=?
              AND ? BETWEEN valid_from AND valid_to
            """;
        int quota;
        try (PreparedStatement ps = connection.prepareStatement(agreementSql)) {
            ps.setString(1, target.courseId());
            ps.setString(2, target.hostSchoolId());
            ps.setString(3, student.schoolId());
            ps.setString(4, target.termId());
            ps.setDate(5, Date.valueOf(asOf));
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    throw new RuleViolation("NO_ACTIVE_AGREEMENT", "没有生效中的校际共享协议");
                quota = rs.getInt("quota");
            }
        }

        String countSql = """
            SELECT count(*)
            FROM enrollment e JOIN student s ON s.student_id=e.student_id
            WHERE e.class_id=? AND s.school_id=?
            """;
        int used = count(connection, countSql, target.classId(), student.schoolId());
        int allowed = Math.min(target.externalCapacity(), quota);
        if (used >= allowed)
            throw new RuleViolation("EXTERNAL_QUOTA_FULL", "该合作学校的外校名额已满");
    }

    private void rejectFullClass(Connection connection, ClassInfo target)
            throws SQLException, RuleViolation {
        int used = count(connection, "SELECT count(*) FROM enrollment WHERE class_id=?", target.classId());
        if (used >= target.capacity())
            throw new RuleViolation("CLASS_FULL", "教学班总容量已满");
    }

    private void insertEnrollment(Connection connection, String studentId, ClassInfo target)
            throws SQLException {
        String sql = "INSERT INTO enrollment(student_id,class_id,course_id,term_id) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ps.setString(2, target.classId());
            ps.setString(3, target.courseId());
            ps.setString(4, target.termId());
            ps.executeUpdate();
        }
    }

    private boolean exists(Connection connection, String sql, String... values) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < values.length; i++) ps.setString(i + 1, values[i]);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    private int count(Connection connection, String sql, String... values) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < values.length; i++) ps.setString(i + 1, values[i]);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        }
    }

    private record StudentInfo(String studentId, String schoolId) {}
    private record ClassInfo(String classId, String courseId, String termId, int capacity,
                             int externalCapacity, String hostSchoolId, String retakePolicy) {}
}
