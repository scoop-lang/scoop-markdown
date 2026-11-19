# Markdown 源码编辑器示例

纯 Scoop 桌面程序，通过 `markdownSourceEditor(editor, options = options)` 挂载源码视图，开启行号并给无障碍节点提供名称。参数为现有 Markdown 文件；运行后点击正文即可输入，Cmd-S 接受当前输入法组合并保存当前快照。文件读写由应用负责，UI 控件只处理文档和编辑状态。

```sh
~/.scoop/bin/scoop --sysroot ~/.scoop run scoop.ui.markdown/examples/source-editor --release -- /absolute/path/to/document.md
```

视图按源码物理行虚拟排版，自动换行，使用原生选择、剪贴板和输入命令。支持中文组合输入、按 grapheme 删除、跨行选择、Tab／Shift-Tab 缩进及统一撤销／重做。关闭窗口不会自动保存，请在关闭前使用 Cmd-S。右键打开原生编辑菜单，选区可拖动／拖出，文本和 URL 可拖入；Touch／Pen、触摸滚动、触控板回弹和系统滚动条默认启用。完整富文本／双栏示例见 [markdown-editor](../../../markdown-editor/README.md)。三种视图共用的演示文稿和操作步骤见[交互验证](../../../docs/INTERACTIONS.md)。
