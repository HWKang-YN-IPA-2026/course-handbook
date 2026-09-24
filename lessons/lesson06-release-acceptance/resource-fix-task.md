# 现场任务：修复资源问题

教师指定一段未可靠关闭JDBC资源的代码。学生应：

1. 指出可能泄漏的Connection、PreparedStatement或ResultSet；
2. 改为try-with-resources；
3. 保留异常路径；
4. 运行相关检查与全量回归；
5. 提交代码差异、运行日志和提交哈希。
