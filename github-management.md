# 《编程能力提升》GitHub课程仓库建设与制品管理方案

> 版本：v1.0.0  
> 适用课程：《编程能力提升》48学时教学方案  
> 适用学期：学期第3—18周  
> 班级规模：55人，原则上3人一组，共18—19组  
> 关联基线：《编程能力提升》48学时教学周历 v1.0.0

## 一、建设目标

GitHub不仅用于提交最终代码，还用于保留“需求—设计—任务—实现—评审—测试—发布”的完整证据链。仓库应同时支持：

1. 五次实践的过程管理与成绩核验；
2. A、B、C三个岗位的三轮轮换；
3. 期末大作业报告与可运行版本归档；
4. 学生个人工作陈述的证据定位；
5. 抄袭、代做和“使用AI但不理解”的复查；
6. 教师对约19个小组的批量管理。

本方案不采用GitHub Classroom。GitHub官方已于2026年8月28日停止该应用，因此课程直接使用GitHub Organization、Team、Repository、Issue、Pull Request、Project、Actions和Release等常规功能。

## 二、总体架构

### 1. 推荐的GitHub组织

建议教师创建一个独立的GitHub Organization，示例名称为：

```text
ipa-course-2026
```

`ipa`表示Improvement of Programming Ability。实际名称应包含学校或课程缩写及学年，避免与个人项目混用。每学年新建组织或在同一教学组织下使用新的仓库前缀均可。

### 2. 仓库组成

| 仓库 | 可见性 | 用途 | 学生权限 |
|---|---|---|---|
| `course-handbook` | 建议公开；受校内要求限制时设为私有 | 课程说明、周历、考核规则、提交规范、常见问题 | Read |
| `demo-code` | 建议私有，按教学进度开放 | 教师课堂演示代码和分阶段参考代码 | Read |
| `starter-project` | 私有模板仓库 | 小组项目的统一目录、Issue/PR模板、CI和初始代码 | 无直接写权限 |
| `team-01-project`—`team-19-project` | 私有 | 各组贯穿全学期的课程项目 | 本组Write，其他组无权限 |
| `teacher-admin` | 私有 | 成绩、名单、账号映射、检查记录和异常处理 | 仅教师/助教 |

不建议为每次实践分别建仓库。每组使用一个持续演进的项目仓库，五次实践分别用Tag和Release冻结，能够完整保留三轮岗位交接和个人贡献历史。

### 3. Team与权限

| GitHub Team | 成员 | 组织/仓库权限 |
|---|---|---|
| `teachers` | 主讲教师 | Organization Owner；所有仓库Admin |
| `assistants` | 助教 | 课程仓库Maintain；`teacher-admin`按需授权 |
| `team-01`—`team-19` | 每组3名学生 | 仅对应小组仓库Write；公共仓库Read |

安全原则：

- Organization默认仓库权限设为`None`；
- 学生不授予Admin，不能删除仓库、修改保护规则或改变可见性；
- 每个小组只能访问本组私有仓库，不能浏览其他组代码；
- 禁止共享GitHub账号，每名学生使用自己的账号提交和评审；
- 学号、成绩、手机号等个人信息不得放入公开仓库；
- 教师账号应启用双重身份验证。

## 三、小组仓库标准结构

```text
team-01-project/
├── README.md
├── CONTRIBUTING.md
├── pom.xml
├── backend/
│   ├── pom.xml
│   └── src/
├── frontend/
│   ├── package.json
│   └── src/
├── database/
│   ├── schema.sql
│   ├── data.sql
│   └── migrations/
├── docs/
│   ├── requirements/
│   │   ├── feature-list.md
│   │   ├── user-stories.md
│   │   └── acceptance-criteria.md
│   ├── design/
│   │   ├── data-model.md
│   │   ├── architecture.md
│   │   ├── api-contract.md
│   │   └── decisions/
│   ├── testing/
│   │   ├── test-plan.md
│   │   ├── test-cases.md
│   │   ├── traceability.md
│   │   └── test-report.md
│   ├── handovers/
│   │   ├── rotation-1-to-2.md
│   │   └── rotation-2-to-3.md
│   ├── role-evidence/
│   │   ├── rotation-1.md
│   │   ├── rotation-2.md
│   │   └── rotation-3.md
│   ├── personal-evidence/
│   │   ├── 学号1.md
│   │   ├── 学号2.md
│   │   └── 学号3.md
│   ├── ai-usage/
│   │   └── disclosure.md
│   ├── final-report.md
│   └── operation-manual.md
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── feature.yml
│   │   ├── bug.yml
│   │   └── task.yml
│   ├── pull_request_template.md
│   └── workflows/
│       └── verify.yml
├── .env.example
└── .gitignore
```

`README.md`至少写明项目目标、三名成员及当前岗位、技术栈、功能清单、运行步骤、测试命令、当前Release和已知问题。只写项目简介而不能复现运行的README不合格。

## 四、统一命名规则

### 1. Issue标题

```text
[P1][R1][A] 编写学生查询验收条件
[P3][R2][C] 实现课程实体关联映射
[P5][R3][B] 定义前后端错误响应结构
```

其中：

- `P1`—`P5`表示五次实践；`FINAL`表示期末大作业；
- `R1`—`R3`表示三轮岗位；
- `A`、`B`、`C`表示该任务的主责岗位。

### 2. 分支

```text
feature/23-student-query
fix/41-invalid-status-code
test/52-course-api-boundary
docs/60-final-report
```

分支名中的数字必须是对应Issue编号。禁止使用`student1`、`new`、`final-final`等无法识别任务的名称。

### 3. Commit

```text
feat(student): implement paged query (#23)
test(course): add duplicate enrollment case (#52)
docs(requirement): refine acceptance criteria (#18)
fix(api): return 404 for missing student (#41)
```

一次Commit只完成一个逻辑变更。提交信息说明“改变了什么”，Issue和PR说明“为什么改变、如何验证”。

### 4. 标签

每个小组仓库统一创建以下Labels：

| 分类 | Labels |
|---|---|
| 实践 | `practice:P1`—`practice:P5`、`practice:FINAL` |
| 岗位 | `role:A`、`role:B`、`role:C` |
| 轮次 | `rotation:R1`、`rotation:R2`、`rotation:R3` |
| 类型 | `type:requirement`、`type:design`、`type:code`、`type:test`、`type:defect`、`type:docs` |
| 优先级 | `priority:high`、`priority:medium`、`priority:low` |
| 核查 | `check:classroom`、`check:teacher-reviewed`、`check:rework` |

## 五、标准工作流与证据链

每一项可计分工作必须走完以下链路：

```text
需求或缺陷 → Issue → 指定负责人和岗位 → 功能分支 → Commit
           → Pull Request → 同伴评审 → 自动检查 → 合并main → Tag/Release
```

具体要求：

1. 岗位A建立功能范围、验收条件、测试任务或缺陷Issue；
2. 岗位B补充业务规则、数据/模块/接口设计及设计决策；
3. 岗位C维护里程碑、任务状态并完成主要代码实现；
4. 每名学生每轮至少主责一个Issue、形成有效Commit或PR，并评审其他成员的一项成果；
5. PR必须关联Issue，例如在说明中写`Closes #23`；
6. PR必须写明变更、测试方法、测试结果、风险和外部帮助；
7. PR由另一名组员评审后才能合并；不得自己批准自己的PR；
8. 自动测试通过后才能合并到`main`；
9. 教师按课堂验收时的Tag或Commit SHA评分，不按截止后修改的`main`评分。

## 六、三轮岗位轮换在GitHub中的实现

| 轮次 | 课次/学期周 | 工作范围 | 冻结与交接 |
|---|---|---|---|
| R1 | 第1—6次/第3—6周 | 需求、数据库、SQL、JDBC | 第6次完成P1并准备交接 |
| R2 | 第7—13次/第7—11周 | Maven、Git、JPA、JUnit | 第7次接手；第13次完成P3并准备交接 |
| R3 | 第14—23次/第11—17周 | Spring Boot、API、Vue、联调和归档 | 第14次接手；第23次完成岗位档案 |

每次交接必须创建一个Issue，例如：

```text
[HANDOVER][R1→R2] 第一轮岗位交接
```

交接材料`docs/handovers/rotation-1-to-2.md`必须包含：

- 原岗位负责人和新岗位负责人；
- 已完成Issue、PR和当前Release；
- 当前版本的启动和测试方法；
- 未完成任务和已知缺陷；
- 重要设计决策与不能随意改变的约束；
- 新负责人复现结果和至少一个问题；
- 双方在交接Issue中的确认记录。

新负责人须在接手后一周内完成一个与新岗位直接相关的小任务，以证明不是名义轮换。

## 七、五次实践与期末版本冻结

| 考核项目 | 实施课次 | Git标签 | Release名称 | 主要制品 |
|---|---:|---|---|---|
| 实践一 | 第6次 | `practice-1-v1.0` | P1 数据库与JDBC | 需求、数据模型、SQL、JDBC、测试、R1岗位证据 |
| 实践二 | 第9次 | `practice-2-v1.0` | P2 Maven、Git与协作 | Maven工程、Issue、分支、PR、冲突处理、交接记录 |
| 实践三 | 第13次 | `practice-3-v1.0` | P3 JPA与JUnit | 实体映射、DAO、JPQL、JUnit、R2岗位证据 |
| 实践四 | 第18次 | `practice-4-v1.0` | P4 Spring Boot与API | 分层、接口契约、OpenAPI、校验、异常与接口测试 |
| 实践五 | 第22次 | `practice-5-v1.0` | P5 Vue与联调 | Vue页面、路由、Axios、联调、测试与R3岗位证据 |
| 期末大作业 | 第23次 | `final-v1.0.0` | Final Course Project | 完整源码、数据库脚本、最终报告、操作手册、三岗位档案 |

冻结操作：

1. 小组确认`main`上的目标Commit可运行且测试通过；
2. 更新README、测试报告和Release说明；
3. 创建规定名称的Tag和Release；
4. 在Release说明中列出功能、已知问题、测试结果、三人贡献和AI/外部帮助；
5. 向教师提交仓库地址、Tag、Commit SHA和课堂验收预约信息；
6. 教师在`teacher-admin`登记SHA。迟交修订创建`-rev1`，不得移动或覆盖原Tag。

## 八、GitHub Project看板

建议在Organization建立一个教师总览Project，各组仓库的Issue和PR均可加入。字段设置如下：

| 字段 | 可选值/用途 |
|---|---|
| Status | Backlog、Ready、In progress、Review、Done |
| Team | 01—19 |
| Practice | P1—P5、FINAL |
| Rotation | R1、R2、R3 |
| Role | A、B、C |
| Type | Requirement、Design、Code、Test、Defect、Docs |
| Priority | High、Medium、Low |
| Due date | 任务截止日期 |
| Evidence check | Not checked、Passed、Rework |

至少建立四个视图：

- `当前实践`：按Practice筛选，按Status分组；
- `小组进度`：按Team分组；
- `岗位工作量`：按Role分组；
- `待课堂核查`：筛选`Evidence check = Not checked`。

若教师不希望维护跨仓库Project，也可让每组使用仓库内Project；但教师总览效率会降低。

## 九、模板内容

### 1. Issue任务模板核心字段

```markdown
## 所属实践与轮次
- 实践：P1/P2/P3/P4/P5/FINAL
- 轮次：R1/R2/R3
- 主责岗位：A/B/C
- 负责人：@GitHub账号

## 任务背景
说明为什么需要此任务。

## 完成条件
- [ ] 可观察的成果一
- [ ] 对应文档或代码已提交
- [ ] 测试或验收条件通过
- [ ] PR已关联本Issue

## 验证方法
写出命令、输入、预期结果或界面操作。

## 外部帮助
列出教师示例、资料、同伴或AI辅助；没有则写“无”。
```

### 2. Pull Request模板

```markdown
## 关联任务
Closes #Issue编号

## 变更内容
- 

## 验证方法与结果
- 命令/步骤：
- 实际结果：

## 影响范围与风险
- 

## 作者自检
- [ ] 没有提交密码、密钥、真实个人数据或`.env`
- [ ] 已更新相关需求、设计或测试文档
- [ ] 自动测试通过
- [ ] 本人能够解释并现场修改关键代码
- [ ] 已披露复制、改写、同伴、教师示例或AI帮助

## 外部帮助说明
- 来源/工具：
- 使用目的：
- 采用和修改的内容：
- 本人验证方法：
```

### 3. 个人证据索引模板

文件名：`docs/personal-evidence/学号.md`。

```markdown
# 个人课程工作证据

## 基本信息
- 姓名：
- 学号：
- GitHub账号：
- 小组：

## 三轮岗位
| 轮次 | 岗位 | 代表性工作 | Issue | PR | Commit/文件 | 测试证据 |
|---|---|---|---|---|---|---|
| R1 |  |  |  |  |  |  |
| R2 |  |  |  |  |  |  |
| R3 |  |  |  |  |  |  |

## 最能代表本人能力的一项成果
说明需求、设计、实现、测试及个人决策。

## 缺陷与改进
说明本人发现或修复的一个问题，以及如何验证修复。

## 外部帮助与AI使用
列出使用的资料、代码来源、同伴/教师帮助或AI工具，以及本人如何核验。
```

### 4. AI和外部帮助记录模板

```markdown
| 日期 | Issue/PR | 工具或来源 | 目的 | 采用内容 | 本人修改 | 验证方法 | 记录人 |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |
```

无需粘贴冗长的完整对话；应保留足以判断来源、用途、修改和验证的摘要。AI使用本身不扣分，隐瞒关键来源、不能解释或不能验证才触发复查。

## 十、main分支保护与自动检查

### 1. 最低保护要求

对所有`team-*-project`仓库的`main`设置：

- 禁止直接Push，必须通过Pull Request；
- 至少需要1名其他组员批准；
- 新Commit提交后撤销旧批准；
- 必须通过自动测试后才能合并；
- 合并前分支必须解决冲突；
- 禁止Force Push；
- 禁止删除`main`；
- 仅教师保留紧急绕过权限，绕过时必须写明原因。

GitHub Free组织的私有仓库对部分Ruleset能力可能有限；若无法应用组织级Ruleset，则逐仓库使用可用的Branch protection，并把保护设置纳入教师建库验收。

### 2. Java/Maven自动检查示例

`.github/workflows/verify.yml`：

```yaml
name: verify

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  backend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
          cache: maven
      - name: Test backend
        run: mvn -B test
```

若项目在后期采用`backend/pom.xml`，将命令改为：

```yaml
run: mvn -B -f backend/pom.xml test
```

数据库账号、密码通过测试配置或Repository Secrets提供，严禁写入源码、Workflow或提交记录。提交过真实密钥后，仅删除文件不足以消除泄露风险，必须立即撤销并更换密钥。

## 十一、考核映射

### 1. 第一维度：教学环节

| 成绩类别 | 项目 | 比例 |
|---|---|---:|
| 平时 | 实践一 | 10% |
| 平时 | 实践二 | 10% |
| 平时 | 实践三 | 12% |
| 平时 | 实践四 | 14% |
| 平时 | 实践五 | 14% |
| 期末 | 期末大作业 | 20% |
| 期末 | 个人课程工作陈述 | 20% |
| **合计** |  | **100%** |

### 2. 第二维度：证据形态

| 项目 | GitHub制品 | 课堂检查/个人陈述 | 合计 |
|---|---:|---:|---:|
| 实践一 | 7% | 3% | 10% |
| 实践二 | 7% | 3% | 10% |
| 实践三 | 8% | 4% | 12% |
| 实践四 | 10% | 4% | 14% |
| 实践五 | 8% | 6% | 14% |
| 期末大作业 | 20% | 0% | 20% |
| 个人课程工作陈述 | 0% | 20% | 20% |
| **合计** | **60%** | **40%** | **100%** |

GitHub制品成绩由冻结Release中的需求、设计、代码、测试、Issue、PR、README和报告等共同支撑。课堂成绩以运行验证、随机解释、现场修改/故障分析和个人陈述为依据。仓库署名与课堂理解不一致时进入复查，不自动把小组成果等同于个人成果。

## 十二、防抄袭与真实性核验

1. 各组获得不同的业务规则、字段约束、查询条件或扩展功能；
2. 私有仓库隔离不同小组，关闭学生自行Fork权限（若组织设置允许）；
3. 不接受三人共用账号、集中由一人代提交或截止前一次性导入全部代码；
4. 每项个人贡献必须能够从Issue、PR、Commit和文件相互定位；
5. 教师示例、依赖库、框架生成代码和已披露的公共模板不作为抄袭判定对象；
6. 相似代码只作为核查线索，结合提交时间、演进过程、解释和现场修改认定；
7. 课堂随机指定一个Commit或文件，由作者解释设计原因并完成微修改；
8. 个人陈述时从三轮岗位随机抽查，避免只准备最后一轮；
9. 对提交历史异常、贡献极不均衡、来源未披露或技术解释矛盾者安排复查；
10. 最终处理依据开课时公布的考核规则和学校学术诚信制度。

## 十三、按课次实施

| 节点 | 教师操作 | 学生提交/操作 |
|---|---|---|
| 开课前 | 创建组织、公共仓库、模板、19个私有仓库、Teams、Ruleset和Project | 无 |
| 第1次课（第3周） | 发布课程规则；演示注册、加入组织、Clone、Issue和首次Commit | GitHub账号、账号—学号登记、小组和R1岗位表、环境自查；接受组织邀请 |
| 第2—5次 | 检查需求、数据设计、SQL/JDBC的Issue和PR | 按证据链持续提交，不在截止前集中导入 |
| 第6次 | 按`practice-1-v1.0`和SHA验收 | 创建P1 Release；提交R1岗位证据 |
| 第7次 | 检查R1→R2交接Issue和文档 | 新岗位负责人复现版本并确认接手 |
| 第9次 | 验收P2的协作过程 | 创建P2 Release和个人贡献说明 |
| 第13次 | 验收P3并检查R2证据 | 创建P3 Release；准备R2→R3交接 |
| 第14次 | 检查第二次交接 | 完成交接Issue和新岗位小任务 |
| 第18次 | 验收API和测试证据 | 创建P4 Release和安全检查表 |
| 第21次前48小时 | 锁定第一批陈述名单 | 第一批提交个人证据索引 |
| 第22次 | 检查P5制品及第二批陈述 | 创建P5 Release；按批次提交个人索引 |
| 第23次 | 冻结大作业和三岗位档案 | 创建`final-v1.0.0`；提交报告、手册和三岗位档案 |
| 第24次 | 完成剩余陈述和最终核查 | 按反馈修订；不得覆盖已冻结Tag |
| 结课后 | 导出成绩证据，仓库只读并归档 | 保留个人本地副本，按学校规则处理数据 |

## 十四、教师批量建库方案

### 1. 建库前准备

准备以下信息：

- Organization名称；
- 教师和助教GitHub账号；
- 学生的“学号、姓名、GitHub账号、小组号”名单；
- 实际小组数（18组或19组）；
- 仓库是否全部私有；
- GitHub组织套餐及其私有仓库规则保护能力。

学生名单只放在`teacher-admin`或学校批准的系统中。公共仓库用小组号和GitHub账号，不公开“姓名—学号—账号”完整映射。

### 2. 网页端创建顺序

1. 教师创建Organization并把助教加入`assistants`；
2. 将组织Base permissions设为`No permission`；
3. 创建`course-handbook`、`demo-code`、`starter-project`和`teacher-admin`；
4. 把`starter-project`设置为Template repository；
5. 建立`team-01`—`team-19`并分别邀请3名学生；
6. 从模板创建`team-01-project`—`team-19-project`，可见性设为Private；
7. 只给同号Team授予Write权限；
8. 配置`main`保护规则、Actions权限、Labels和Project；
9. 使用教师测试账号检查：能读本组、不能读其他组、不能改规则；
10. 第1次课让学生接受邀请并完成一次“Issue—分支—Commit—PR—评审—合并”演练。

### 3. GitHub CLI批量执行示例

本机需先安装GitHub CLI并完成登录：

```bash
gh auth login
gh auth status
```

以下为示例，不应在替换占位符和核对名单前直接运行：

```bash
ORG="ipa-course-2026"
GROUP_COUNT=19

for i in $(seq -w 1 "$GROUP_COUNT"); do
  gh api --method POST "orgs/$ORG/teams" \
    -f name="team-$i" \
    -f privacy="closed"

  gh repo create "$ORG/team-$i-project" \
    --private \
    --template "$ORG/starter-project" \
    --description="编程能力提升课程第${i}组项目"

  gh api --method PUT \
    "orgs/$ORG/teams/team-$i/repos/$ORG/team-$i-project" \
    -f permission="push"
done
```

学生加入Team建议依据教师核对后的CSV逐项执行，避免把错误账号加入私有仓库。批量脚本运行后仍需抽查仓库可见性、Team权限、`main`规则和自动检查；脚本执行成功不等于权限配置正确。

## 十五、教师每周管理清单

- 查看当前实践Project视图中的逾期和阻塞任务；
- 检查是否存在一名学生包办全部Commit的情况；
- 抽查新PR是否关联Issue、是否有测试和同伴评审；
- 检查Actions失败是否被长期忽略；
- 检查AI/外部帮助是否披露；
- 将课堂抽查结论标为`check:teacher-reviewed`或`check:rework`；
- 在每次验收后登记Tag、SHA、课堂得分和复查事项；
- 岗位轮换后一周核查新负责人是否完成小任务。

## 十六、异常处理

| 情况 | 处理办法 |
|---|---|
| 学生改名或更换GitHub账号 | 教师核验身份后更新私有映射；保留旧账号记录 |
| Commit作者邮箱错误 | 学生修正后续Git配置；历史证据结合PR和课堂核验，不强制重写公共历史 |
| 截止前仓库无法运行 | 按冻结SHA记录；修复后创建`-rev1`，原版本保留 |
| 误提交密码或密钥 | 立即撤销并更换；通知教师；再清理历史，不只删除当前文件 |
| 组员退出或长期缺席 | 教师记录调整日期；重新分配Issue；不伪造原成员提交 |
| GitHub临时不可用 | 保存本地Commit和时间证据；恢复后Push；由教师登记平台故障 |
| Actions额度或权限受限 | 学生本地运行测试并保存日志；教师课堂复现；不取消测试要求 |
| 仓库误删 | 学生无Admin可降低风险；由Organization Owner按平台能力恢复或使用教师备份 |

## 十七、建库验收标准

远程仓库系统满足以下条件后才算建立完成：

- [ ] 组织名称、所有者和助教权限已核对；
- [ ] 公共仓库、模板仓库、教师仓库已创建；
- [ ] 实际组数对应的私有小组仓库均已创建；
- [ ] 每组3名学生只拥有本组仓库Write权限；
- [ ] 学生不能删除仓库、修改可见性和保护规则；
- [ ] `main`必须经PR、评审和自动检查才能合并；
- [ ] Issue、PR、个人证据、交接和AI披露模板齐全；
- [ ] Labels、Release命名和Project字段统一；
- [ ] 模板工程能Clone、构建、测试和运行；
- [ ] 教师测试账号完成越权访问检查；
- [ ] 学生账号与学号映射未出现在公开仓库；
- [ ] 教师已建立每次验收的Tag/SHA登记表。

## 十八、本方案落地状态与待提供信息

本文件已经给出可直接实施的仓库结构、权限、流程、模板、冻结规则和批量命令。当前工作区尚未直接创建GitHub远程仓库，原因是本机未安装`gh`命令，且尚未明确GitHub Organization名称、所有者账号、学生分组账号名单及组织套餐。

正式执行远程建库前，教师需确认并提供：

1. GitHub Organization名称或允许新建组织的教师账号；
2. 教师/助教GitHub账号；
3. 18或19个小组的GitHub账号名单；
4. 私有仓库方案是否确认；
5. 是否允许安装GitHub CLI并授权登录。

以上信息齐备后，可按第十四节创建远程组织、Teams和仓库，并按第十七节验收。

## 十九、官方参考

- [GitHub Classroom关闭说明](https://docs.github.com/en/education/manage-coursework-with-github-classroom/teach-with-github-classroom)
- [组织仓库角色与权限](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization)
- [管理Team对仓库的访问](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/managing-team-access-to-an-organization-repository)
- [GitHub Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Rulesets说明](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [Rulesets可用规则](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets)

