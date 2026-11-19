# 编辑器应用窗口回归

这个 macOS Cone 验证完整应用的工具栏、原生菜单、自动换行与多文档窗口。`application`、`platform` 是指向应用源码的相对符号链接，测试直接编译当前实现，不复制另一份应用逻辑。测试使用独立临时文稿和最近文件记录，退出后清理。

从仓库根执行，依赖路径与应用本身相同：

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop check markdown-editor/tests-cones/window --tests --release
~/.scoop/bin/scoop --sysroot ~/.scoop test markdown-editor/tests-cones/window --release --no-run
~/.scoop/bin/scoop --sysroot ~/.scoop bundle \
  --executable target/aarch64-apple-darwin/release/scoop.examples/markdown-application-window/tests/markdown-application-window \
  --target aarch64-apple-darwin \
  --config markdown-editor/tests-cones/window/Bundle.toml \
  --output-dir /tmp/scoop-markdown-application-app --format app
mkdir /tmp/scoop-markdown-application-events
open -n -W --env SCOOP_TEST_RUN_DIR=/tmp/scoop-markdown-application-events \
  '/tmp/scoop-markdown-application-app/aarch64-apple-darwin/prebuilt/org.scoop.tests.markdown-application/app/Scoop Markdown Application Verification.app' \
  --args --scoop-test-filter formattingMenusToolbarAndWrappingFollowTheActivePane
cat /tmp/scoop-markdown-application-events/events.jsonl
```

每个窗口用例必须在独立进程中串行运行；另一筛选器为 `openingFilesReusesOnlyUnchangedUntitledWindows`，请使用新的事件目录。核对 `begin`、`failures` 为空的 `end` 和最终 `complete`，不能只看启动命令的状态码。

格式用例通过真实无障碍 Press 操作点击标题下拉、菜单项和按钮，通过原生菜单 action 选择粗体及标题子项，并断言正文和一次撤销。它还检查双栏焦点切换时的工具栏显隐、最小窗口宽度下的控件边界，以及长代码和宽表格的实际折行、横向范围与源码保持。

普通文字换行回归另用只有段落、标题、引用或列表的独立文稿，检查关闭后真实排版高度减小、横向滚动范围出现，重新开启后范围归零；同时覆盖双栏、右侧只读预览，以及源码、选区和撤销历史保持。

窗口复用用例覆盖发起窗口优先复用、从其他窗口打开时复用现有空文档、编辑后撤销到空白不复用、同一文件去重，以及读取失败保留原窗口。
