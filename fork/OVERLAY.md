# Overlay

活清单。每次改 fork 相关代码，或跟 `upstream/main` 同步之后，更新本表。

用法见 [README.md](README.md)。决策正文在 [adr/](adr/)。

## 列含义

- **ADR**：`fork/adr/` 里的编号。没有 ADR 就先不要合代码。
- **路径**：具体文件或目录。越窄越好。
- **策略**：冲突时怎么处理。常见值：`保留我们的 hunk`、`新文件（上游无）`、`改完再应用`、`准备删除`。
- **状态**：`仍需要` / `上游已合入` / `准备删补丁`。
- **备注**：上游 PR、最后一次核对的日期。

## 当前补丁

| ADR | 路径 | 策略 | 状态 | 备注 |
|-----|------|------|------|------|
| 0001 | `.github/workflows/fork-release.yml` | 新文件（上游无） | 仍需要 | 2026-08-31 |
| 0001 | `fork/scripts/stamp-workspace-version.py` | 新文件（上游无） | 仍需要 | 发布时改 0.0.0，不提交 |
| 0002 | `.github/workflows/fork-ci.yml` | 新文件（上游无） | 仍需要 | required 名 Fork CI |
| 0002 | `fork/scripts/disable-upstream-workflows.ps1` | 新文件（上游无） | 仍需要 | 远端禁用上游 workflow |

同步核对时从上一行往下走。不要凭记忆决定留哪边。
