# 复杂选课系统 v0.1：第02次课完整制品示例

> 课堂教师示例使用“选课”主线。课后学生作业使用“用户登录”场景，要求见[用户登录作业要求](用户登录作业要求.md)，空白结构见[`student-templates/`](student-templates/README.md)。[冲突决策记录模板](冲突决策记录模板.md)可用于记录方案比较和最终决定。

本目录给出课件中“需求、UML、规则、验收、代码、测试、GitHub记录”证据链的完整示例。v0.1只处理本校学生选择一门课程，不引入教学班、候补、扩容审批、排课、收费和成绩。

## 制品导航

| 制品 | 文件 | 回答的问题 |
| --- | --- | --- |
| 决策记录 | `docs/decisions/DEC-001.md` | 满员时怎么办，谁作出决定 |
| 需求基线 | `docs/requirements/requirements-v0.1.md` | 系统在v0.1应做什么 |
| 业务规则 | `docs/rules/business-rules-v0.1.md` | 系统按什么顺序判断 |
| 验收条件 | `docs/acceptance/acceptance-criteria-v0.1.md` | 怎样证明需求实现正确 |
| UML模型 | `docs/models/` | 边界、流程、交互和领域对象是什么 |
| 追溯矩阵 | `docs/traceability/traceability-matrix-v0.1.md` | 决策、需求、模型、规则、测试如何对应 |
| 迭代记录 | `docs/iterations/v0.1.md` | 本轮做了什么，下一轮揭示什么 |
| Java实现 | `src/main/java/` | 规则怎样进入代码 |
| 可执行验收 | `src/test/java/` | 代码是否满足AC-001至AC-005 |

## 用 IntelliJ IDEA 运行

1. 选择“打开”，打开本目录。
2. 将`src/main/java`标记为 Sources Root，将`src/test/java`标记为 Test Sources Root。
3. 打开`src/test/java/edu/ynu/enrollment/v01/AcceptanceCheck.java`。
4. 运行`main`方法。控制台应显示5条`PASS`和汇总结果。

## 用命令行运行

需要JDK 17或更高版本。

```bash
mkdir -p out
javac -encoding UTF-8 -d out \
  src/main/java/edu/ynu/enrollment/v01/*.java \
  src/test/java/edu/ynu/enrollment/v01/*.java
java -cp out edu.ynu.enrollment.v01.AcceptanceCheck
java -cp out edu.ynu.enrollment.v01.BoundaryCheck
```

## 预期输出

```text
PASS AC-001 正常选课
PASS AC-002 课程满员
PASS AC-003 课程关闭
PASS AC-004 重复选课
PASS AC-005 学生状态异常
5/5 scenarios passed
PASS capacity=2, enrolled=3 -> DATA_ERROR
PASS capacity=-1 -> INVALID_CAPACITY
2/2 boundary checks passed
```

## 本轮不要求

Issue、分支和Pull Request不属于本轮强制制品，可作为过程加分证据。不得提交`.idea/`、`out/`、密码、令牌或本机配置。
