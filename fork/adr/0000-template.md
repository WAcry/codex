# NNNN. 标题

- **Status：** Proposed | Accepted | Superseded | Dropped
- **日期：** YYYY-MM-DD
- **Fork-ADR：** NNNN

Status 说明：

- Proposed：还没合进我们的分支
- Accepted：已经按此改代码
- Superseded：被另一篇 ADR 替代（写明编号）
- Dropped：不再做，或上游已经有等价实现（写明 PR/issue）

Accepted 之后不要改 Context / Decision 正文。后来的变化写新 ADR，或只改本页 Status。

## Context

当时缺什么。上游现有行为为什么不够用。涉及的用户或场景。

## Decision

具体怎么改。新模块、新配置，还是打补丁。写到别人按这段能重做一遍。

## Paths

会动的文件或目录，一条一行。

```text
codex-rs/...
```

## Coupling

上游一改，哪里会炸。点名热点文件、协议字段、配置键。

## Reapply

同步冲突时按什么步骤重做。不要写「再看一下代码」。

## 如何确认

测试命令、测试名，或手动检查点。同步之后必须能跑或能勾。

```text
just test -p ...
```

## Upstream

相关上游 issue/PR。一旦上游合入等价功能，Status 改为 Dropped 或 Superseded，并更新 [OVERLAY.md](../OVERLAY.md)。

## 后果

接受这个决策之后，维护成本、对同步的影响、明确不做什么。
