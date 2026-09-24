# 需求追溯矩阵 v0.1

| 来源 | 用例 | 规则 | 验收 | UML | 代码 | 可执行检查 |
| --- | --- | --- | --- | --- | --- | --- |
| US-001 | UC-001步骤1 | — | AC-001 | 用例图、时序图 | `EnrollmentRequest` | `normalEnrollment` |
| 学籍要求 | UC-001步骤2 | BR-001 | AC-005 | 用例图、活动图 | `EnrollmentService` | `inactiveStudent` |
| 课程开放 | UC-001步骤3 | BR-002 | AC-003 | 活动图 | `EnrollmentService` | `closedCourse` |
| 不得重复 | UC-001步骤4 | BR-004 | AC-004 | 活动图、领域类图 | `EnrollmentRepository.exists` | `duplicateEnrollment` |
| DEC-001 | UC-001步骤5 | BR-003 | AC-001、AC-002 | 活动图、失败时序图 | `Course.hasSeat` | `normalEnrollment`、`fullCourse` |
| 成功产生记录 | UC-001步骤6 | — | AC-001 | 成功时序图、领域类图 | `EnrollmentRepository.add` | `normalEnrollment` |
| 最低保证 | UC-001扩展场景 | 所有失败规则 | AC-002至AC-005 | 失败分支 | `EnrollmentService` | 每个失败检查的记录数断言 |

## 使用方法

需求发生变化时，从“来源”所在行横向检查所有列。例如满员后改为候补，需要同时重审DEC-001、UC-001步骤5、BR-003、AC-002、活动图、失败时序图、领域类图、代码和测试。
