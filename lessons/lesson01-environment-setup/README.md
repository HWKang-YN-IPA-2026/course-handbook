# 第01次课：课程环境与首次提交

本目录用于完成课程开发环境检查和第一次个人提交。首次作业是安装与环境验证反馈，不是业务分析作业。

## 制品

- `installation-feedback-template.md`：个人安装与验证记录模板。
- `verify_environment.sh`：macOS/Linux终端环境检查脚本。
- `setup-macos-path.sh`：将Homebrew、Java和PostgreSQL常用命令加入zsh环境的参考脚本。
- `预期结果.md`：环境检查的判定方法。

## 使用

```bash
chmod +x verify_environment.sh setup-macos-path.sh
./verify_environment.sh
```

若命令未找到，先运行：

```bash
./setup-macos-path.sh
exec zsh -l
./verify_environment.sh
```

不得在提交中包含密码、令牌、私钥或其他个人敏感信息。
