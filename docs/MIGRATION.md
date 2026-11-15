# 独立仓库迁移

2026-11-15，从 `scoop-lang/scoop` 的 `codex/markdown-editor` 分支提交 [`5611938b4419ee3502145b8f8ca65e8d13d7b530`](https://github.com/scoop-lang/scoop/commit/5611938b4419ee3502145b8f8ca65e8d13d7b530) 抽取。基础 UI/window 改动已由 [PR #135](https://github.com/scoop-lang/scoop/pull/135) 合入 Scoop `main`，对应提交为 `1f7b75bb8a0936f30faf200f7caaa64d494a02e0`。

| 主仓库原位置 | 独立仓库位置 |
| --- | --- |
| `sysroot/src/scoop.markdown` | `scoop.markdown` |
| `sysroot/src/scoop.ui.markdown` | `scoop.ui.markdown` |
| `sysroot/src/scoop.ui.markdown/examples/editor` | `markdown-editor` |
| 两份 Markdown spec、`docs/markdown`、`docs/ui/markdown` | 保留原有 `docs` 下的位置 |
| 编程 skill 的 Markdown API 条目 | `docs/API-GUIDE.md` |
| 原生探针、测试字体与大型文档语料 | `test-support` |

迁移保留现有 Markdown 能力与测试；修改集中于 Cone 依赖、文档链接、测试头文件和性能语料路径。生产库与应用通过安装的 Scoop 工具链消费基础 UI、window、graphics 等库。根 workspace 统一列出库、应用、示例与测试 Cone，构建产物不进入 Git。

实际命令行验收修正了无 UI 文件示例的参数索引：Scoop 的 `args[0L]` 是程序路径，输入和输出分别从 `args[1L]`、`args[2L]` 读取。无用户参数时继续运行源码事务演示；两个库与桌面编辑器的功能实现保持迁移前内容。

`test-support/performance` 保存原性能测试所用两份大型规范的相同字节，供独立复现原混合文档测试。`SCOOP_MARKDOWN_PERF_REPOSITORY` 现在指向本仓库根目录。主仓库语言规范继续独立演进，这些测试快照只在明确更新语料时修改。

## 迁移验证

使用 `~/.scoop` 的 `scoop 0.0.0-dev (6289e706e3+unit-statements)`，在 macOS aarch64 完成以下验证：

- workspace 的 421 个 Scoop 文件通过格式检查，调整过的原生文件通过 clang-format 检查；Git 空白检查和文档相对链接检查通过。
- 两个库与编辑器通过生产检查；两个库、无 UI 示例及五个原生测试 Cone 通过 `check --tests --release`。测试辅助 Cone 从本仓库编译，依赖图中没有主仓库 checkout 路径。
- `scoop.markdown` 的 292 项、`scoop.ui.markdown` 的 176 项、无 UI 示例的 23 项测试通过，共 491 项。参数入口修正后重新运行无 UI 示例测试，23 项仍通过。
- 真实 CLI 验证无参数的源码事务演示，以及两个路径参数下的文件读取、mdBook include 展开、生成文件和原文件保持不变。
- 完整编辑器、独立预览、源码编辑器与无 UI 文件示例完成 release 构建；完整编辑器和三模式原生测试程序完成 macOS app 打包。
- 两份固定语料与提取前字节相同，原生测量入口成功读取合计 1,188,002 字节。窗口输入复验未通过：本次宿主启动环境下窗口未获得 macOS 焦点，停在 `phase=0`、`focused=false`、`input=false`，60 秒后超时。没有开始文档输入测量，不把构建成功计作交互验收通过；历史性能结果仍对应[原记录](ui/markdown/PERFORMANCE.md)中的版本。

本次只验证 macOS 主机，保留其他平台的源码和构建条件。
