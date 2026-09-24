# 第03次课教师演示：课程、教学班与学期

配套PlantUML模型位于[`models/`](models/)，学生空白提交结构位于[`student-templates/`](student-templates/README.md)。

本目录发布课堂教师演示代码和预期结果。学生可以在线阅读或Clone本仓库，但不需要、也不应向本公共仓库提交修改。小组作业请在各组私有仓库完成。

## 实验目标

用可复现的数据库实验展示以下演化过程：

```text
v0.1只能记录课程
→ 一门课程在同一学期出现两个教学班
→ 增加TeachingClass与AcademicTerm
→ Enrollment选择具体教学班
→ 使用唯一约束和复合外键保护业务规则
```

## 运行环境

- PostgreSQL；
- 已创建专用数据库`course_demo`；
- 终端能够执行`psql`。

检查环境：

```bash
psql --version
pg_isready
```

## 教师演示顺序

| 顺序 | 文件 | 课堂用途 | 预期 |
| --- | --- | --- | --- |
| 1 | `00_v01_counterexample.sql` | 复现旧模型缺少教学班信息 | 只能查到课程 |
| 2 | `01_schema.sql` | 建立v0.2五张表、约束和索引 | 建表成功 |
| 3 | `02_seed.sql` | 准备一门课程、同学期两个教学班 | 插入成功 |
| 4 | `03_checks.sql` | 查询教学班和正常选课 | AC-001通过 |
| 5 | `04_negative_same_class.sql` | 再次选择同一班 | AC-004，SQLSTATE 23505 |
| 6 | `05_negative_cross_class.sql` | 选择同课程同学期另一班 | AC-005，SQLSTATE 23505 |
| 7 | `06_negative_fk.sql` | 写入与教学班不一致的课程 | AC-006，SQLSTATE 23503 |
| 8 | `07_query_plan.sql` | 查看两个常用查询的执行计划 | 可观察索引用途 |

详细输出见[预期结果](预期结果.md)。

## 逐步执行

```bash
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 00_v01_counterexample.sql
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 01_schema.sql
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 02_seed.sql
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 03_checks.sql
```

`04`—`06`包含预期失败语句，应逐个运行。数据库返回错误且记录数保持不变，表示约束生效。为了得到统一的初始状态，每项负向实验前可重新运行`01_schema.sql`和`02_seed.sql`。

```bash
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 04_negative_same_class.sql
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 05_negative_cross_class.sql
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 06_negative_fk.sql
psql -X -v ON_ERROR_STOP=1 -d course_demo -f 07_query_plan.sql
```

课前可以执行完整检查：

```bash
bash verify_postgres.sh
```

成功标志：

```text
PASS AC-001 normal count = 1
PASS AC-004 SQLSTATE 23505
PASS AC-005 SQLSTATE 23505
PASS AC-006 SQLSTATE 23503
PostgreSQL课堂演示验证完成
```

AC-002满班和AC-003关闭班需要应用服务根据当前人数、容量和状态作出判断，不属于本目录的数据库自动约束实验。

## 使用要求

教师示例用于阅读、运行和比较。学生应根据本组需求重新完成需求、模型、SQL和验证记录，不得把教师示例直接作为本组成果提交。
