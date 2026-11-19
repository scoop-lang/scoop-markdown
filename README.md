# Scoop Markdown

用 Scoop 编写的 Markdown 文档库、编辑组件和桌面编辑器。`scoop.markdown` 可以在没有 UI 的程序中解析、处理和生成 Markdown；`scoop.ui.markdown` 提供源码、所见即所得与双栏编辑；`markdown-editor` 是使用这些组件的完整窗口示例。

| 目录 | 内容 |
| --- | --- |
| [scoop.markdown](scoop.markdown/README.md) | 源文档、快照、解析、结构事务、生成与语法扩展 |
| [scoop.ui.markdown](scoop.ui.markdown/README.md) | 三模式编辑、输入法、共享历史、搜索、大纲、折叠与扩展展示 |
| [markdown-editor](markdown-editor/README.md) | Finder 风格布局的桌面编辑器示例 |
| [docs](docs/README.md) | 规范、设计、API 导航与验证记录 |
| [test-support](test-support/README.md) | 原生窗口测试辅助代码、固定字体及性能语料 |

当前范围是核心 Markdown 编辑和展示，以及 inline／block 扩展框架。扩展可以在光标进入时显示可编辑源码，退出后恢复渲染。已有的图片、公式、Mermaid 与 mdBook 适配继续保留；新增扩展通过现有抽象逐步接入。外部图像工具的安装和配置见 [IMAGES.md](scoop.ui.markdown/IMAGES.md)。

## 构建与运行

使用已安装并更新的 [Scoop 工具链](https://github.com/scoop-lang/scoop)，默认位置为 `~/.scoop`。基础 UI/window 库需要包含公开文本绘制与多格式剪贴板接口，以及 `TextInputOperation.SetSelection`、`TextEditCommand.DeleteSelection`、`DragSource`／`DropTarget`、`LongPress`／`ScrollPan`、视口物理效果和 `SemanticsHandle.updateScrollBar`。仓库中的库使用本地 path 依赖，其他 Scoop 库消费工具链的预编译资源。

如果安装中的基础库尚未更新，可给 `check`／`build`／`run`／`test` 追加 `--cone-path /absolute/path/to/cones`，消费配套的新预编译基础库；不需要重建编译器。

完整编辑器还要求 `scoop.ui.component` 包含 Resizable 末尾把手的挂载修复：只有相邻面板之间创建把手。缺少该修复的基础库会在单栏／双栏窗口初始化无障碍操作时越界退出，需更新配套组件产物。

以下命令从仓库根运行：

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop check . --release
~/.scoop/bin/scoop --sysroot ~/.scoop build markdown-editor --release
~/.scoop/bin/scoop --sysroot ~/.scoop run markdown-editor --release -- /absolute/path/document.md
```

原生上下文菜单、拖放、Touch／Pen、系统滚动条、回弹与无障碍操作说明见[交互验证](docs/INTERACTIONS.md)，三个 UI 示例可共用[演示文稿](examples/interactions.md)。

编辑器不传文件参数时创建空白文档，打开文件会复用未保存、未修改的空窗口。所见即所得活动时提供格式工具栏、标题级别下拉及带“标题”子菜单的原生右键菜单；“显示”菜单可切换自动换行。原生文件菜单支持新建、打开、最近文件、保存、另存为与关闭，未保存的文档在关闭前确认。macOS app 打包和窗口操作见[编辑器说明](markdown-editor/README.md)。

无 UI 文件处理示例可以独立运行：

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop run scoop.markdown/examples/source --release -- input.md expanded.md
```

## 开发与验证

根 `Cone.toml` 组织两个库、编辑器、示例和测试辅助 Cone；默认选择两个库与编辑器。独立消费者可通过 path 依赖这两个库的目录。

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop fmt . --workspace --check
~/.scoop/bin/scoop --sysroot ~/.scoop check scoop.markdown --tests --release
~/.scoop/bin/scoop --sysroot ~/.scoop check scoop.ui.markdown --tests --release
~/.scoop/bin/scoop --sysroot ~/.scoop test scoop.markdown --release
~/.scoop/bin/scoop --sysroot ~/.scoop test scoop.ui.markdown --release
~/.scoop/bin/scoop --sysroot ~/.scoop test scoop.markdown/examples/source --release
```

库的原生交互测试在 `scoop.ui.markdown/tests-cones/`，完整应用的窗口测试在 `markdown-editor/tests-cones/window/`，需要桌面会话及窗口焦点，运行方法见[测试说明](test-support/README.md)。大文档测试使用仓库自带的固定语料。所有构建产物留在被忽略的 `target/`；原始测试日志保存在仓库外。

## 来源与许可

本仓库从 [scoop-lang/scoop](https://github.com/scoop-lang/scoop) 的 Markdown 开发分支抽取，保留两个库、编辑器、相关示例、测试和文档；迁移基线及依赖说明见[迁移记录](docs/MIGRATION.md)。

代码与文档沿用原项目的 [MIT](LICENSE-MIT) 或 [Apache-2.0](LICENSE-APACHE) 双许可。解析语料、实体表、代码高亮规则与测试字体的第三方许可分别随文件保留，见 [Markdown 许可说明](scoop.markdown/licenses/README.md)、[Prism 许可](scoop.ui.markdown/licenses/prism.txt)和[字体说明](test-support/text-fonts/FONTS.md)。
