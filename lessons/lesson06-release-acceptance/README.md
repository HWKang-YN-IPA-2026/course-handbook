# 第06次课教师演示：验收、追溯与版本发布

本目录公开第06次课教师展示代码和预期结果。学生可以在线阅读或Clone本仓库，但不需要、也不应向本公共仓库提交修改。小组作业应在各组私有仓库完成。

本课不维护另一套应用代码，而是从空数据库重放第04、05次课正式演化链，并对同一候选提交执行AC-01至AC-11以及可靠性、安全发布门检查。

## 环境

- macOS或Linux；
- PostgreSQL 10+；
- JDK 17+；
- Maven 3.9+；
- `psql`、`createdb`和`pg_isready`已在`PATH`。

## 下载并进入目录

```bash
git clone https://github.com/HWKang-YN-IPA-2026/course-handbook.git
cd course-handbook/lessons/lesson06-release-acceptance
```

## 运行

```bash
./verify_environment.sh
createdb -h localhost lesson06_acceptance
./run_acceptance.sh lesson06_acceptance
```

如果数据库已经存在，请先删除或换一个专用数据库名。脚本会重建`public`下的课程表，不能对保存其他数据的数据库运行。

预期末行：

```text
LESSON-06 RELEASE ACCEPTANCE PASSED (AC-01..AC-11)
```

完整输出解释见[预期结果](预期结果.md)。

## 验收层次

- AC-01..AC-10：结构、约束、测试数据、回滚和索引的 PostgreSQL 证据。
- AC-11：复用第05次课 JDBC 集成检查，覆盖规则、事务和最后一席并发。
- RG-01：演示异常处理、try-with-resources资源释放和SQL注入对照。
- RG-02：检查凭据、忽略文件和PreparedStatement证据。
- AC-12：教师课堂发布的现场变化题，只记录题目、提交和复验结果，不提前写入自动脚本。

## 发布

先在`release-candidate.md`记录RC1提交。现场变化产生RC2后，必须重新运行全部检查。发布检查、追溯和独立复核均通过后，方可创建指向RC2的`practice-1-v1.0`标签。

## 关键文件

| 文件 | 用途 |
|---|---|
| `verify_environment.sh` | 检查PostgreSQL、Java和Maven环境 |
| `prepare_release_database.sh` | 调用第05次课正式脚本，从空基线重建到v0.4 |
| `database/acceptance_checks.sql` | AC-01至AC-10数据库验收 |
| `run_acceptance.sh` | 第06次课唯一完整验收入口 |
| `examples/ReliabilitySecurityDemo.java` | 异常、资源释放和SQL注入对照 |
| `security_check.sh` | 凭据和参数化SQL检查 |
| `release-candidate.md` | RC1、RC2和最终发布提交记录 |
| `现场验收记录.md` | 记录课堂AC-12和全量回归结果 |

## 安全说明

- 不提交真实数据库口令；
- 不修改第05次课公开基线来“配合”验收；
- SQL注入示例只打印不安全SQL和安全参数绑定的差异，不执行恶意语句；
- AC-12由教师课堂公布，本目录不预置答案。
