package edu.ynu.p1.v04;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public final class Course1JoinQuery {
    private static final String SQL = """
        SELECT s.student_id, s.student_name, c.course_name,
               t.term_name, e.final_score, e.passed
        FROM student s
        JOIN enrollment e ON e.student_id = s.student_id
        JOIN course c ON c.course_id = e.course_id
        JOIN academic_term t ON t.term_id = e.term_id
        WHERE s.student_id = ?
        ORDER BY t.start_date, c.course_id
        """;

    public static void main(String[] args) throws Exception {
        String studentId = args.length == 0 ? "S002" : args[0];
        ConnectionFactory factory = new ConnectionFactory(DbConfig.load());
        try (Connection connection = factory.open();
             PreparedStatement statement = connection.prepareStatement(SQL)) {
            statement.setString(1, studentId);
            try (ResultSet rows = statement.executeQuery()) {
                System.out.println("student_id | student_name | course_name | term_name | score | passed");
                int count = 0;
                while (rows.next()) {
                    count++;
                    System.out.printf("%s | %s | %s | %s | %s | %s%n",
                        rows.getString("student_id"), rows.getString("student_name"),
                        rows.getString("course_name"), rows.getString("term_name"),
                        rows.getObject("final_score"), rows.getObject("passed"));
                }
                System.out.println("ROWS=" + count);
            }
        }
    }
}
