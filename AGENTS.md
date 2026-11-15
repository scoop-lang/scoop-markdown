# Scoop Markdown 开发约定

- 输出和思考使用中文；代码标识符与注释使用英文。
- 本仓库负责 Markdown 文档模型、核心编辑与展示以及 inline／block 扩展框架。`scoop.markdown` 保持无 UI 依赖；编辑器应用位于 `markdown-editor`。
- 公共行为变更先更新 `docs/specs/SCOOP-MARKDOWN-SPEC.md` 或 `docs/specs/SCOOP-UI-MARKDOWN-SPEC.md`，再同步库 README、`docs/API-GUIDE.md`、实现与测试。已有设计及验证记录见 `docs/README.md`。
- 使用用户指定的 Scoop 工具链；本机默认入口为 `~/.scoop/bin/scoop --sysroot ~/.scoop`。消费已安装的基础库，不为本仓库开发自动重建编译器或整个 sysroot。
- 一批修改完成后先执行 Scoop 格式化及相关 `check --tests --release`，再运行所属 Cone 测试。普通 API 测试放在库内，真实窗口行为放在 `scoop.ui.markdown/tests-cones`。
- `test-support` 中的原生探针、私有窗口头文件及字体只用于测试，来源和同步规则见其 README。性能语料是固定快照，不作为 Scoop 语言规范维护。
- 原始日志及临时测量结果保存在仓库外；只提交简明验证结论和必要限制。
