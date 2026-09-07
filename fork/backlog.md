# Backlog

尚未成为决策的想法放在这里。条目短，一条一件事。决定采用时，按 [adr/0000-template.md](adr/0000-template.md) 写 ADR，并删掉对应条目。

| 日期 | 想法 | 备注 |
|------|------|------|
| 2026-08-31 | 从 WAcry/codex Releases 做内置升级（检测 + 可选替换完整包） | 被 0003 推迟。重做时要改仓库 URL、`wa-v` 标签、`.wa.N` 比较、prerelease 与 `/latest`、不能再跑官方 install.sh |
| 2026-08-31 | 去掉全部 Responses `encrypted: true` / `with_encrypted()` | GPT 和开源模型一视同仁，不要按 provider 分叉。加密收益不大，开源模型也不支持。生产用法：v2 `spawn_agent` / `send_message` / `followup_task` 的 `message`；`history.search_contents.query`、`notes.search_contents.query`、`notes.append_to_file.text`、`notes.write_file.text`。改法：删掉 schema 标记；v2 投递一律明文 `InterAgentCommunication::new()`，不要再走 `new_encrypted` / `encrypted_content`。 |
