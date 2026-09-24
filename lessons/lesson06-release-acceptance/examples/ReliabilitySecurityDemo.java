public final class ReliabilitySecurityDemo {
    private static final class TracedResource implements AutoCloseable {
        @Override public void close() { System.out.println("RESOURCE_CLOSED"); }
    }

    public static void main(String[] args) {
        String input = "S002' OR '1'='1";
        String unsafe = "SELECT * FROM student WHERE student_id='" + input + "'";
        System.out.println("UNSAFE_SQL=" + unsafe);
        System.out.println("SAFE_SQL=SELECT * FROM student WHERE student_id=?");
        System.out.println("BOUND_VALUE=" + input);

        try (TracedResource ignored = new TracedResource()) {
            throw new IllegalStateException("simulated failure");
        } catch (IllegalStateException problem) {
            System.out.println("EXCEPTION_HANDLED=" + problem.getMessage());
        }
    }
}
