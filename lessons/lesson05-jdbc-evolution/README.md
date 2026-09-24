# 第05次课教师演示：连接查询与JDBC

配套模型、版本演化与事务设计证据分别位于[`models/`](models/)和[`teacher-artifacts/`](teacher-artifacts/)，学生模板位于[`student-templates/`](student-templates/)。

本目录发布第05次课教师展示代码和预期结果。学生可以在线阅读或Clone本仓库，但不需要、也不应向本公共仓库提交修改。小组作业请在各组私有仓库完成。

## 实验目标

- 使用多表连接取得学生历史修读结果；
- 通过Course0观察驱动JAR不在classpath时的真实错误；
- 加入pgJDBC后连接PostgreSQL；
- 使用`PreparedStatement`绑定参数并读取`ResultSet`；
- 将重修、同期重复、共享资格、配额和容量检查放入同一事务；
- 使用`SELECT ... FOR UPDATE`保证最后一个座位不会超卖。

## 环境

- macOS或Linux；
- PostgreSQL 10+；
- JDK 17+；
- Maven 3.9+；
- `psql`已在`PATH`。

服务检查：

```bash
pg_isready -h localhost -p 5432
```

## 下载并进入目录

```bash
git clone https://github.com/HWKang-YN-IPA-2026/course-handbook.git
cd course-handbook/lessons/lesson05-jdbc-evolution
```

## 创建专用演示数据库

```bash
createdb -h localhost lesson05_demo
```

如果数据库已经存在，可直接复用；准备脚本会重建其中的课程表。不要对保存其他数据的数据库运行本示例。

## 演示一：Course0与Course1

```bash
./prepare_database.sh lesson05_demo
./demo_course0_course1.sh lesson05_demo
```

Course0-A故意从classpath移除pgJDBC，预期出现`ClassNotFoundException`；脚本随后加入驱动JAR并运行Course1。成功标志：

```text
EXPECTED_FAIL exit=1
DRIVER_OK org.postgresql.Driver
S002 | 李同学 | 高等数学 | 2025-2026学年春季学期 | 45.00 | false
ROWS=1
```

## 演示二：v0.4业务与并发

每次演示前重建数据：

```bash
./prepare_database.sh lesson05_demo
./run_demo.sh
```

预期观察：已通过者拒绝、未通过者成功、过期协议拒绝；两名学生竞争最后一个座位时恰好一人成功。

## 一次运行全部验收

```bash
./run_checks.sh lesson05_demo
```

预期末行：

```text
ALL LESSON-05 CHECKS PASSED
```

完整结果见[预期结果](预期结果.md)。

## 关键文件

| 文件 | 用途 |
|---|---|
| `database/04_join_query.sql` | 正确的历史修读多表连接 |
| `database/05_join_error_lab.sql` | 连接、字段和别名错误诊断 |
| `Course0DriverCheck.java` | 驱动JAR与classpath演示 |
| `Course1JoinQuery.java` | PreparedStatement多表查询 |
| `EnrollmentService.java` | v0.4事务和固定规则顺序 |
| `TeacherDemo.java` | 教师课堂演示入口 |
| `IntegrationCheck.java` | AC-404至AC-411自动验收 |

## 配置与安全

默认连接`jdbc:postgresql://localhost:5432/lesson05_demo`，默认用户为当前系统用户。也可复制`config.example.properties`为`config.properties`，或设置`DB_URL`、`DB_USER`和`DB_PASSWORD`。

- 不要提交真实口令；
- `config.properties`已被`.gitignore`排除；
- Course0-A的异常是教学设计中的预期失败；
- 并发场景的胜者不固定，但成功数必须为1。
