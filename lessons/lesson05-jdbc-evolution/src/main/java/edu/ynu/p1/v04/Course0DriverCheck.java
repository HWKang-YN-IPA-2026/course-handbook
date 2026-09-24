package edu.ynu.p1.v04;

public final class Course0DriverCheck {
    public static void main(String[] args) throws Exception {
        Class<?> driver = Class.forName("org.postgresql.Driver");
        String source = driver.getProtectionDomain().getCodeSource().getLocation().toString();
        System.out.println("DRIVER_OK " + driver.getName());
        System.out.println("JAR=" + source);
    }
}
