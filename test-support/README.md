# 测试辅助文件

这些文件供 `scoop.ui.markdown/tests-cones` 使用，使原生交互与性能测试可在本仓库运行。生产库和 `markdown-editor` 不依赖这些辅助 Cone。

| 目录 | 用途与来源 |
| --- | --- |
| `window-native` | Scoop 窗口的原生输入、焦点、剪贴板和快照探针；来自 `scoop.window/test-native` |
| `window-native/headers` | 探针所需的 `scoop.window/native` 私有结构声明 |
| `surface-native` | 原生 surface、绘制提交与滚动探针；来自 `scoop.surface/test-native` |
| `graphics-native` | 像素和 GPU 测试辅助；来自 `scoop.graphics/test-native` |
| [text-fonts](text-fonts/FONTS.md) | 固定字体及许可证；来自 `scoop.graphics.text/tests/data` |
| [performance](performance/README.md) | 原性能测量使用的两份大型 Markdown 文档 |

原生辅助代码与头文件来自 Scoop 提交 [`5611938b4419ee3502145b8f8ca65e8d13d7b530`](https://github.com/scoop-lang/scoop/commit/5611938b4419ee3502145b8f8ca65e8d13d7b530)，改动为本地路径和必要格式化。更新 Scoop 工具链时，如窗口私有结构或探针接口变化，应同时同步对应探针与头文件。字体有独立许可，其余辅助代码沿用根目录的 MIT／Apache-2.0 双许可。

本仓库另在 `window-native` 的编辑探针中增加 AppKit 光标读取，用于验证 Markdown 正文和滚动条之间的光标切换；不改变窗口私有结构声明或生产库接口。

普通状态和文档测试通过两个库的 `scoop test` 执行。真实窗口测试按各自 README 运行：

- [源码输入](../scoop.ui.markdown/tests-cones/source/README.md)
- [富文本与原位源码](../scoop.ui.markdown/tests-cones/rich/README.md)
- [三模式、剪贴板与性能](../scoop.ui.markdown/tests-cones/editor/README.md)
- [扩展图像与像素](../scoop.ui.markdown/tests-cones/images/README.md)

窗口测试需要桌面会话；原生输入测试还需要窗口获得焦点。测试剪贴板时保存并恢复系统原有内容。每个窗口 filter 单独启动测试进程，以满足单次 Application 生命周期。构建命令使用 `~/.scoop`，不需要另一个 Scoop 源码 checkout。
