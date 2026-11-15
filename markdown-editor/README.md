# 三模式 Markdown 编辑器

本应用不带参数启动时新建空白文档，也可以在命令行提供一个已有文件，默认进入所见即所得模式。窗口参考 Finder 的布局：保留系统窗口按钮，紧凑顶部工具栏显示文件名、导航、模式分段控件、格式菜单、查找、保存和更多操作；浅灰侧栏展示当前文稿与虚拟大纲，底部状态栏显示路径、保存状态、行列位置和文件大小。空文稿的大纲区有提示。原生菜单提供文件、编辑、显示和窗口操作；工具栏图标有悬浮说明。

源码、所见即所得和双栏模式支持右侧只读、源码锚点滚动同步、可调栏宽、共享撤销／重做，以及保存按钮／Cmd-S。保存接受当前组合后写出同一份源码快照；纯模式切换和预览不重排 Markdown。Cmd-Alt-1／2／3 切换模式；更多菜单集中撤销／重做、替换、行列定位、折叠和双栏设置。查找栏只在使用时出现，行列定位使用小型对话框。

“文件”菜单提供新建、打开、最近打开的文件、清除菜单、保存、另存为和关闭。新建／打开使用独立窗口，各自保留编辑状态和撤销历史；重复打开同一路径时激活已有窗口。未命名文档首次保存、以及“另存为”使用系统保存面板；取消或写入失败保留原路径与未保存内容。“窗口”菜单可最小化、缩放及切换文档。

| 操作 | macOS 快捷键 | Windows／Linux 快捷键 |
| --- | --- | --- |
| 新建 | Cmd-N | Ctrl-N |
| 打开 | Cmd-O | Ctrl-O |
| 保存 | Cmd-S | Ctrl-S |
| 另存为 | Cmd-Shift-S | Ctrl-Shift-S |
| 关闭文档 | Cmd-W | Ctrl-W |
| 退出应用 | Cmd-Q | Ctrl-Q |

关闭或退出前若有未保存修改，会询问保存、不保存或取消；取消或保存失败中止关闭。退出时逐一处理文档窗口。macOS 关闭最后一个窗口后仍可通过应用菜单新建、打开或退出；Windows／Linux 关闭最后一个文档窗口后退出。

最近文件保留十个成功打开或保存的路径，去重后按最近使用排序，重启后仍可使用。清除菜单只清除记录。记录位置分别为 macOS 的 `~/Library/Application Support/Scoop Markdown Editor/recent-files.json`、Windows 的 `%LOCALAPPDATA%/Scoop Markdown Editor/recent-files.json`、Linux 的 `$XDG_STATE_HOME/scoop-markdown-editor/recent-files.json`（默认 `~/.local/state`）。

文件面板或读写失败会显示错误并保留当前文档，编辑菜单的可恢复错误也留在所属窗口。不可恢复的 UI／应用错误会按正常退出流程释放资源，向标准错误报告原因和可用的异常栈，以非零状态结束；操作和清理同时失败时保留两者。需要排查堆栈时可用 `scoop run markdown-editor --release --enable-stack-trace` 启动。

源码栏显示物理行号及 Markdown 标记高亮，代码 token 沿用语言高亮。Enter 保留空格／Tab 缩进；在已识别、尚无正文的未闭合围栏首行末尾补出结束围栏。输入括号可包裹选区或自动配对，键入自动补出的右括号会越过它，空配对可一次退格删除。辅助操作可撤销；粘贴和输入法组合保持原文。宿主通过 MarkdownSourceOptions 分别控制 lineNumbers、autoIndent、autoPairs、autoFences。

顶部 Aa 菜单通过公开的编辑命令提供粗体、斜体、删除线与行内代码；对应快捷键为 Cmd-B、Cmd-I、Cmd-Shift-X、Cmd-E。格式操作支持跨块选区；无选区时控制后续键入，不产生空标记。菜单显示混合状态，纯源码模式或右侧只读时禁用。链接／图片打开文字／替代文字、地址和标题面板，可插入、修改或移除当前目标；取消不改变文档。图片 URI 相对当前文件解析，编辑器沿用本地图片适配展示，文件保存／上传由宿主应用提供。

Cmd-V 在富文本栏优先使用剪贴板 Markdown，其次把 HTML 转成 Markdown，最后按普通文字插入；段落、文字格式、链接、列表和普通表格可转换，无法表示的结构保留原 HTML。一次粘贴可独立撤销，组合文字先提交。源码栏默认原样粘贴 Markdown／普通文本；应用菜单可通过 viewState.executeClipboard(MarkdownClipboardCommand.PasteHtml) 显式导入 HTML。此示例沿用默认快捷键，没有额外的粘贴菜单。

Aa 菜单中的段落与标题、列表、表格子菜单可转换标题／段落，增减引用，改变列表类型和层级，插入代码块、分隔线与表格，并增删表格行列、设置列对齐。Cmd-0／1…6 对应段落／标题；菜单关闭后执行命令并返回编辑器，修改使用同一撤销历史。新增代码块直接进入局部源码编辑。

顶部查找按钮、更多菜单中的替换，或 Cmd-F／Cmd-Alt-F 打开原生全文查找栏，提供大小写、整词和正则选项。查询字段 Enter／Shift-Enter、Cmd-G／Cmd-Shift-G 前后跳转；Escape 在组合结束后返回编辑区域。Replace 修改当前匹配，Replace all 一次修改所有匹配并共用文档撤销；只读栏禁用替换。正则替换支持 `$1`、`${name}`、`$$`。搜索包含原始 Markdown 的标记和目标 URI，不展开外部 include；高亮与滚动使用同一源码映射。

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop run markdown-editor --release
~/.scoop/bin/scoop --sysroot ~/.scoop run markdown-editor --release -- /absolute/path/document.md
```

可选参数与预览示例相同：`--mermaid /path/to/mmdc`；`--mathjax /path/to/node /path/to/@mathjax/src /path/to/rsvg-convert`。工具由用户预先配置；Mermaid 以扩展图像块显示，源码围栏保留。普通本地 PNG／JPEG 使用文件 URI 解析。

源码、预览和所见即所得栏在内容溢出时显示可拖动的滚动条，点击轨道可翻页；源码关闭自动换行后也支持横向滚动条。正文区域显示系统 I 型鼠标光标，滚动条及正文外恢复缺省光标。

`Cone.toml` 已通过 `[bundle].config` 引用 `Bundle.toml`，其中包含应用标识、显示名称、版本、描述、项目地址、图标、双许可文件和发布者。图标源文件为 `packaging/icon.svg`，修改后用 `rsvg-convert -w 1024 -h 1024 markdown-editor/packaging/icon.svg -o markdown-editor/packaging/icon.png` 更新供各平台打包使用的 PNG。以下命令从仓库根运行，自动构建 release 程序并生成 macOS app；示例目标为 Apple Silicon：

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop bundle markdown-editor --format app --output-dir target/app
open -n 'target/app/aarch64-apple-darwin/release/org.scoop.examples.markdown-editor/app/Scoop Markdown Editor.app' \
  --args /absolute/path/document.md
```

也可以打包已有的可执行文件：

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop build markdown-editor --release
~/.scoop/bin/scoop --sysroot ~/.scoop bundle \
  --executable target/aarch64-apple-darwin/release/scoop.examples/markdown-editor/markdown-editor \
  --target aarch64-apple-darwin \
  --config markdown-editor/Bundle.toml \
  --output-dir target/app --format app
open -n 'target/app/aarch64-apple-darwin/prebuilt/org.scoop.examples.markdown-editor/app/Scoop Markdown Editor.app' \
  --args /absolute/path/document.md
```

在对应目标和宿主上，同一项目配置支持 `--format deb`、`--format rpm`、`--format appimage`、`--format nsis` 和 `--format msi`。Linux 声明 GTK 4.18／libadwaita 1.4 运行依赖及 TextEditor 分类；Windows 使用 GUI subsystem、Per-Monitor V2 DPI manifest、每用户安装和固定 MSI upgrade-code。打包工具依赖由用户预先安装，参见 [scoop-bundle 说明](https://github.com/scoop-lang/scoop/blob/main/tooling/scoop-bundle/README.md)。macOS 默认采用 ad-hoc 签名；正式分发所需证书在 Bundle.toml 中另行配置。

应用参数仍传入同一 main；直接双击 app 或不传文件参数会打开未命名空白文档，通过“打开…”选择已有文件。上面的 `open` 命令也可省略 `--args` 及文件路径。应用不自动安装图像工具。

普通段落、标题和表格单元格支持富文本输入、跨块替换与格式操作，Enter／Tab 可操作列表和表格。点击代码、公式、Mermaid 或自定义指令可在当前栏打开局部源码面，Done／Escape 返回。代码面额外提供 Language / info、Apply 和 Copy code；Enter 也可提交完整信息字段，语言与属性均可编辑，复制只取代码正文，修改和撤销仍共享文档历史。代码高亮覆盖预览、源码和局部源码，未知语言显示原文；公式与 Mermaid 继续沿图像扩展展示。

其余功能与性能验收见[实施记录](../docs/markdown/PROGRESS.md)；源码栏可以编辑所有内容。本文件锚点由编辑器定位，其他链接由示例显示目标，实际打开行为由宿主决定。

侧栏按钮显示／隐藏虚拟标题列表，顶部左右箭头提供后退／前进。Cmd-L 或更多菜单的“前往行”打开定位对话框，输入 `12:3` 后 Enter 跳转，Escape 返回编辑栏。大纲、[TOC] 和本文件锚点共用源码导航历史，切换模式或只读不会改变原文；[TOC] 内容由预览派生，保存继续保留原指令。

标题和 front matter 首行旁的三角按钮同步折叠两栏；代码围栏只在源码栏折叠。更多菜单提供当前区域及全部折叠／展开，可用键盘访问。展开父标题保留子标题的折叠；搜索和导航会展开目标。正在组合的文字不能被收起，边界删除先展开隐藏内容，所有折叠操作都保留原文件与撤销历史。

界面已用 `~/.scoop` 工具链完成格式化、release 检查、构建及 macOS app 打包，并在原生窗口验证三种模式、空文稿输入、大纲显隐、查找高亮、定位、格式与链接面板，以及撤销／重做和保存。定位与链接面板快速关闭后立即打开查找，焦点仍进入查询框；侧栏显隐后可以继续输入。交互验证使用独立文稿，保存后确认源码内容恢复。

文件管理补充验证包括 7 项参数、文档保存与最近记录测试，以及 macOS app 的无参数启动、菜单新建／打开、另存为、最近文件重开与清除、窗口切换、保存后关闭及退出确认。不存在的启动文件会提示错误并保留可用的空白窗口，随后仍可打开其他文稿；非法参数以状态码 1 结束。Windows／Linux 的本次原生交互尚未实测。
