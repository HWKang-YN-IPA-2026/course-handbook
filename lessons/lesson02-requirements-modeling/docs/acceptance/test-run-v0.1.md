# v0.1测试运行记录

- 运行日期：2026-09-12
- Java：OpenJDK 21.0.12.1
- 编译：成功
- 验收检查：5/5通过
- 容量边界检查：2/2通过

## 验收输出

```text
PASS AC-001 正常选课
PASS AC-002 课程满员
PASS AC-003 课程关闭
PASS AC-004 重复选课
PASS AC-005 学生状态异常
5/5 scenarios passed
```

## 边界输出

```text
PASS capacity=2, enrolled=3 -> DATA_ERROR
PASS capacity=-1 -> INVALID_CAPACITY
2/2 boundary checks passed
```

测试代码固定时钟和编号生成器，因此运行结果可重复。失败场景同时检查仓库记录数不变。
