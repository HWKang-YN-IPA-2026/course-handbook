# 验收条件 v0.1

## AC-001 正常选课

```gherkin
Given 学生S001状态正常
And 课程C001开放、容量为2且当前已选1人
And S001没有选择C001
When S001提交C001的选课请求
Then 系统返回SUCCESS和选课记录编号
And 新增1条选课记录
And 当前已选人数变为2
```

## AC-002 课程满员

```gherkin
Given 学生S001状态正常
And 课程C001开放、容量为2且当前已选2人
And S001没有选择C001
When S001提交C001的选课请求
Then 系统返回COURSE_FULL
And 不新增选课记录
```

## AC-003 课程关闭

```gherkin
Given 学生S001状态正常
And 课程C001处于关闭状态
When S001提交C001的选课请求
Then 系统返回COURSE_CLOSED
And 不新增选课记录
```

## AC-004 重复选课

```gherkin
Given 学生S001状态正常
And 课程C001开放且有容量
And 已存在S001选择C001的记录
When S001再次提交C001的选课请求
Then 系统返回DUPLICATE_ENROLLMENT
And 记录数不变
```

## AC-005 学生状态异常

```gherkin
Given 学生S002状态为INACTIVE
And 课程C001开放且有容量
When S002提交C001的选课请求
Then 系统返回STUDENT_INACTIVE
And 不新增选课记录
```

AC-005用于覆盖BR-001，并补齐课件追溯矩阵中列出的学籍异常场景。
