# 第04次课教师演示：SQL数据操作

本目录发布第04次课教师展示代码和预期结果。学生可以在线阅读或Clone本仓库，但不需要、也不应向本公共仓库提交修改。小组作业请在各组私有仓库完成。

## 实验目标

在选课系统v0.3固定数据库上完成：

- SELECT、WHERE和ORDER BY；
- COUNT、MIN、MAX、AVG和GROUP BY；
- INSERT以及唯一约束拒绝重复数据；
- UPDATE前确认范围并检查影响行数；
- DELETE本次实验创建的临时数据；
- 在事务中观察无WHERE风险并使用ROLLBACK恢复基线。

## 环境检查

```bash
psql --version
pg_isready -h 127.0.0.1 -p 5432
```

创建专用演示数据库：

```bash
createdb lesson04_demo
```

也可以使用：

```bash
psql -X -d postgres -c 'CREATE DATABASE lesson04_demo;'
```

## 教师演示顺序

| 顺序 | 文件 | 课堂用途 |
|---:|---|---|
| 1 | `00a_reset_extensions.sql` | 清理上一次v0.3扩展表 |
| 2 | `00_v02_schema.sql` | 重建基础表、约束和索引 |
| 3 | `00b_reset_school.sql` | 清理旧School表 |
| 4 | `00_v02_seed.sql` | 插入基础课程、教学班和选课数据 |
| 5 | `01_sharing_migration.sql` | 迁移到v0.3结构 |
| 6 | `02_sharing_seed.sql` | 准备学校、协议和外校学生数据 |
| 7 | `03_basic_queries.sql` | SELECT、排序和聚合 |
| 8 | `04_insert_constraints.sql` | INSERT、回滚和预期约束错误 |
| 9 | `05_update_delete_safety.sql` | UPDATE、DELETE、无WHERE风险和回滚 |
| 10 | `06_acceptance_checks.sql` | AC-301至AC-306自动验收 |

## 一次运行

```bash
cd lessons/lesson04-sql-data-operations
bash verify_postgres.sh lesson04_demo
```

成功标志：

```text
PASS AC-301 v0.3 migration and backfill
PASS AC-302 fixed baseline rows
PASS AC-303 aggregate expectations
PASS AC-304 insert rollback has no residue
PASS AC-305 temporary delete is isolated
PASS AC-306 unsafe update rolled back
PostgreSQL第04次课v0.3验证完成
```

详细查询结果、事务内行数和回滚后的数据见[预期结果](预期结果.md)。

## 安全与使用要求

- 只在专用演示数据库运行，不能用于保存其他数据的数据库；
- INSERT、UPDATE、DELETE演示均核对影响范围；
- 无WHERE操作只在事务中运行，并立即ROLLBACK；
- 教师示例用于阅读、运行和比较。学生应提交本组独立完成的SQL、运行记录和版本缺口分析。
