# UML模型说明

四个`.puml`文件是可修改的模型源文件：

- `usecase-v0.1.puml`说明系统边界、参与者与用例。
- `activity-v0.1.puml`说明UC-001的判断顺序和失败分支。
- `sequence-v0.1.puml`说明学生、选课系统与基础数据系统的交互。
- `domain-v0.1.puml`说明Student、Course与Enrollment的关系。

同名`.svg`文件用于在GitHub和浏览器中直接查看。修改`.puml`后应重新生成图片，不得只改图片。

若本机安装了PlantUML，可在本目录执行：

```bash
plantuml -tsvg *.puml
```
