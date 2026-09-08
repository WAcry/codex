# Overlay

活清单。每次改 fork 相关代码，或采用新的上游 Release 之后，更新本表。

用法见 [README.md](README.md)。决策正文在 [adr/](adr/)。

## 列含义

- **ADR**：`fork/adr/` 里的编号。没有 ADR 就先不要合代码。
- **路径**：具体文件或目录。越窄越好。
- **策略**：冲突时怎么处理。常见值：`保留我们的 hunk`、`新文件（上游无）`、`改完再应用`。
- **备注**：上游 PR、最后一次核对的日期。

补丁不再需要时，删除对应行。旧记录留在 Git 历史里。

## 当前补丁

| ADR | 路径 | 策略 | 备注 |
|-----|------|------|------|
| 0001 | `.github/workflows/fork-release.yml` | 新文件（上游无） | 2026-08-31 |
| 0001 | `fork/scripts/stamp-workspace-version.py` | 新文件（上游无） | CI 恢复 `0.0.0`，发布时改成 fork 版本；都不提交 |
| 0002 | `.github/workflows/fork-ci.yml` | 新文件（上游无） | PR 格式与编译检查；main 完整 fork 测试集；required 名 Fork CI |
| 0002 | `.github/workflows/fork-sync-upstream.yml` | 新文件（上游无） | 每天 fast-forward `origin/upstream` |
| 0002 | `fork/scripts/disable-upstream-workflows.ps1` | 新文件（上游无） | 远端禁用上游 workflow |
| 0003 | `codex-rs/tui/src/updates.rs` | 保留我们的 hunk | 关闭内置升级探测 |
| 0003 | `codex-rs/cli/src/doctor/updates.rs` | 保留我们的 hunk | doctor 不打官方 latest |
| 0004 | `codex-rs/core/src/agent/control/spawn.rs` | 保留我们的 hunk | 清空 fork 继承项的父线程 ID；上游修复 #33329 后清理 |
| 0004 | `codex-rs/core/src/agent/control_tests.rs`、`codex-rs/core/tests/suite/subagent_notifications.rs` | 保留我们的 hunk | fork item ID 回归断言 |
| 0004 | `.github/workflows/fork-ci.yml` | 保留我们的 hunk | 合并后运行对应的子代理集成测试 |

同步核对时从上一行往下走。不要凭记忆决定留哪边。
