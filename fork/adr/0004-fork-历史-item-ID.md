# 0004. fork 历史 item ID

- **日期：** 2026-09-07
- **Fork-ADR：** 0004

## 背景

[openai/codex#33329](https://github.com/openai/codex/issues/33329)：子代理继承历史时，上游丢弃 reasoning，却保留最终回答的父线程 `msg_*` ID；服务端可能要求同时提供对应的 `rs_*`，从而拒绝请求。当前基线即使使用 `store=false` 也会保留带前缀的 ID。

## 决策与重应用

在 `codex-rs/core/src/agent/control/spawn.rs` 的 `retain_forked_item` 中，取得 `response_item` 后调用 `set_id(/*new_id*/ None)`，放在可能提前返回的分支之前。普通历史与压缩后的 `replacement_history` 共用此处理，覆盖完整历史与最近 N 轮 fork。

统一清空继承项的父线程 ID，后续流程可分配新 ID。内容、`call_id`、元数据和 reasoning 保留策略继续跟随上游。补丁只作用于子代理 fork，不按 provider 分叉。

## 如何确认

由 `fork-ci.yml` 运行回归测试：父线程的最终回答保留原 ID，子线程请求保留回答内容，但不引用父线程 ID。检查普通历史及压缩历史、完整历史及最近 N 轮 fork。

- `core/src/agent/control_tests.rs`：`spawn_agent_fork_strips_parent_usage_hints_from_compacted_history`、`spawn_agent_fork_last_n_turns_keeps_only_recent_turns`。
- `core/tests/suite/subagent_notifications.rs`：`spawned_full_history_v2_child_uses_model_precedence_without_dropping_context`；CI 用 `just test -p codex-core --test all spawned_full_history_v2_child_uses_model_precedence_without_dropping_context` 运行。

## 上游修复后清理

同步上游时检查该 issue 和 fork 历史构建逻辑。上游已有等价修复，或其历史保留策略已解决引用缺失时，先撤下补丁验证回归用例；通过后删除 fork 专属回归断言、对应 CI 命令和 ADR 0002 中的说明、本 ADR、README 索引和 OVERLAY 条目。
