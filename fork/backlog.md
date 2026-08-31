# Backlog

还没写成 ADR 的想法。条目短，一条一件事。一旦开始改代码，先按 [adr/0000-template.md](adr/0000-template.md) 开 ADR，再从本表删掉对应行。

| 日期 | 想法 | 备注 |
|------|------|------|
| 2026-08-31 | 从 WAcry/codex Releases 做内置升级（检测 + 可选替换完整包） | 被 0003 推迟。重做时要改仓库 URL、`wa-v` 标签、`.wa.N` 比较、prerelease 与 `/latest`、不能再跑官方 install.sh |
| 2026-08-31 | 去掉全部 Responses `encrypted: true` / `with_encrypted()` | GPT 和开源模型一视同仁，不要按 provider 分叉。加密收益不大，开源模型也不支持。生产用法：v2 `spawn_agent` / `send_message` / `followup_task` 的 `message`；`history.search_contents.query`、`notes.search_contents.query`、`notes.append_to_file.text`、`notes.write_file.text`。改法：删掉 schema 标记；v2 投递一律明文 `InterAgentCommunication::new()`，不要再走 `new_encrypted` / `encrypted_content`。 |
| 2026-08-31 | fork 继承历史丢 reasoning 时，要一起清掉保留项的 item id | [openai/codex#33329](https://github.com/openai/codex/issues/33329)。丢 reasoning 跟上游走：现在 `keep_forked_rollout_item` 丢 `Reasoning`、留 assistant `FinalAnswer`。上游以后若不再丢，我们也跟着留。问题只在留下来的 `msg_*` 还带着父线程服务端 id，指向已经不在请求里的 `rs_*`。Azure `store=true` 保留 id 就被拒；内置 openai `store=false` 顺手删了 id 才没报错。改法：构建 forked history 时（`retain_forked_item` 附近）把保留项的 `id` 置空。不要按 provider 特判，也不要单独改成「恢复 reasoning」。 |
