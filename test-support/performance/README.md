# 固定性能语料

本目录保存 Scoop 提交 [`5611938b4419ee3502145b8f8ca65e8d13d7b530`](https://github.com/scoop-lang/scoop/commit/5611938b4419ee3502145b8f8ca65e8d13d7b530) 中以下文件的原始字节：

| 文件 | 原位置 | UTF-8 字节数 |
| --- | --- | ---: |
| `SCOOP-IMPL-SPEC.md` | `docs/specs/SCOOP-IMPL-SPEC.md` | 641,186 |
| `SCOOP-SPEC.md` | `docs/specs/SCOOP-SPEC.md` | 546,814 |

这些文件用于保留真实大型文档的块分布、嵌套、表格、代码和中英文内容。它们是测试数据；内部链接及表述保持原样，当前语言规范以 [Scoop 主仓库](https://github.com/scoop-lang/scoop/tree/main/docs/specs)为准。许可沿用根目录的 MIT／Apache-2.0。

原生性能测试从 `SCOOP_MARKDOWN_PERF_REPOSITORY` 指定的本仓库根目录读取本目录；未指定时以测试进程当前目录为根。之后构造约 1／5／20 MiB 混合文档。指标、复现步骤和历史结果见[交互测量记录](../../docs/ui/markdown/PERFORMANCE.md)。
