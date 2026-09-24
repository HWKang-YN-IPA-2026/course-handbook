package edu.ynu.p1.v04;

final class RuleViolation extends Exception {
    private final String code;
    RuleViolation(String code, String message) { super(message); this.code = code; }
    String code() { return code; }
}
