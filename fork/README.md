# Fork 文档

本目录只服务 [WAcry/codex](https://github.com/WAcry/codex) 相对上游的二次开发。上游仓库是 [openai/codex](https://github.com/openai/codex)。

不要往仓库根目录的 `docs/`、`README.md`、`AGENTS.md` 加 fork 说明。那些文件上游改得勤，写进去每次同步都会冲突，也可能被 agent 按上游规则清掉。

本目录文档只写中文。

## 目标

改动要小、要精炼。能新建文件就不要改热点；能配置或适配层解决就不要分叉业务逻辑。每一处补丁都要能说清：少了它哪条原则或功能会坏。补丁越少，以后和上游合并时冲突越少。

## 原则

这个 fork 不只攒功能。功能可以等，原则用来判断上游新代码要不要动。

当前的初心：让 Codex 能好好接多种 LLM，而不是只围绕 GPT / OpenAI 官方接口来写。

查看 `origin/upstream` 或采用新的上游 Release 时，除了按 [OVERLAY.md](OVERLAY.md) 保住已有补丁，还要扫一眼上游新增的模型、鉴权、协议、provider 相关代码。如果它把行为写死在单一厂商上（硬编码模型名、只认一种 API、把 ChatGPT 登录当成唯一路径），先记到 `backlog.md`。决定处理时再修改现有 ADR，或为独立决策新建 ADR。原则和现有功能冲突时，优先保住原则，再决定功能要不要跟。

原则变化时直接修改对应 ADR。没有对应 ADR 的独立决策才新建一篇。

保持简单。默认维护者会按文档操作。LLM agent 很容易为假想风险叠加保护，这是本项目不接受的默认行为。只有已经发生的问题，或明确要求拦住的行为，才值得增加 gate、ruleset 和重复校验。

代码采用进攻式编程。调用方违反约定就尽早报错，错误不要静默降级。契约已经写清时，直接依赖契约。

## 文件

| 文件 | 用途 |
|------|------|
| [README.md](README.md) | 怎么维护这个 fork、怎么同步 |
| [OVERLAY.md](OVERLAY.md) | 活清单：改过哪些路径、同步时留哪边 |
| [adr/0000-template.md](adr/0000-template.md) | 新 ADR 的模板 |
| [adr/](adr/) | 当前生效的决策，一篇一个文件 |
| [backlog.md](backlog.md) | 尚未成为决策的想法 |
| [scripts/](scripts/) | 禁用上游 Actions、发版时盖 workspace 版本 |

ADR 只描述当前决策，历史由 Git 保存。ADR 不设状态字段。计划中的事只放 `backlog.md`；开始写 ADR，决策就立即生效。讨论产生变化时直接改原 ADR。决策失效时删除 ADR、相关补丁和 overlay 条目。

当前 ADR：

- [0001 版本与发布](adr/0001-fork-版本与发布.md)
- [0002 main 与 CI](adr/0002-main-分支与持续集成.md)
- [0003 安装与升级检测](adr/0003-安装与升级检测.md)
- [0004 fork 历史 item ID](adr/0004-fork-历史-item-ID.md)
- [0005 工具参数统一明文](adr/0005-工具参数统一明文.md)
- [0006 工具语法放入描述](adr/0006-工具语法放入描述.md)

## Git remote

```text
origin    https://github.com/WAcry/codex
upstream  https://github.com/openai/codex
```

本地若还没有 `upstream`：

```
git remote add upstream https://github.com/openai/codex.git
git fetch upstream
```

不要混淆两个同名概念：

- 本地 remote `upstream` 指向 `openai/codex`
- 远端分支 `origin/upstream` 镜像 `openai/codex main`
- 远端分支 `origin/main` 只采用已经发布的 `rust-v*` tag，包括 alpha / beta，再叠加 fork overlay

`fork-sync-upstream.yml` 每天 fast-forward `origin/upstream`，也可在 Actions 手动触发。`main` 不直接合入 `origin/upstream`。普通改动走 PR 并 squash；发布基线同步先用临时 PR 跑 CI，再把 rebased 分支更新到 `main`。规则见 [ADR 0002](adr/0002-main-分支与持续集成.md)。

## 改代码时

1. 能新建文件就新建，少改热点文件。
2. 准备让决策生效时，从 `backlog.md` 删除对应想法，再写或更新 ADR（`fork/adr/NNNN-标题.md`）。独立的新决策才使用下一个四位编号。
3. 在 `OVERLAY.md` 加一行：ADR 编号、路径、冲突时的策略。
4. commit message 带 `Fork-ADR: NNNN`，方便以后 `git log --grep=Fork-ADR`。

## 版本与发布

规则见 [ADR 0001](adr/0001-fork-版本与发布.md)。

- 版本：`{上游完整版本}.wa.{N}`，标签 `wa-v` 加版本，例如 `wa-v0.152.0-alpha.6.wa.1`
- `main` 上 `codex-rs` workspace 版本等于当前采用的上游 release tag；发布任务临时改成完整 fork 版本
- 在 `origin/main` 的提交上推 annotated tag，由 `fork-release.yml` 构建 Windows x64 ZIP 和 Linux x64 GNU tar.gz，挂到 GitHub Releases
- 不发 npm / R2 / WinGet，不签名

```
git tag -a wa-v0.152.0-alpha.6.wa.1 -m "wa 0.152.0-alpha.6.wa.1"
git push origin wa-v0.152.0-alpha.6.wa.1
```

## 安装

规则见 [ADR 0003](adr/0003-安装与升级检测.md)。

从 [Releases](https://github.com/WAcry/codex/releases) 下载：

- Windows x64：`codex-package-x86_64-pc-windows-msvc.zip`
- Linux x64：`codex-package-x86_64-unknown-linux-gnu.tar.gz`（glibc 2.35 或更新）

解压到固定目录，把包里的 `bin/` 加进 PATH。不要只复制 `codex`，同级的 `codex-resources/`、`codex-path/` 也要保留。不要用官方 `install.sh`、`npm i -g @openai/codex` 或 Homebrew cask 来装这个 fork，那些会装 openai 的包。

TUI/CLI 不检查、不提示升级。换版本就下载新包，整体替换旧目录。

## 验证

本节的 fork 验证规则优先于上游 `AGENTS.md` 中关于测试执行范围与时机的要求。

本 fork 通常只做小补丁，验证按阶段分配：本地只做格式与静态检查；PR 由 `fork-ci.yml` 做格式、Clippy 和 Linux / Windows release 编译检查；合并后的 `main` 再执行完整 fork 测试集，范围见 [ADR 0002](adr/0002-main-分支与持续集成.md)。手动重跑测试也选择 `main`。

Release commit 的真实 workspace 版本会在 CI 临时 checkout 中恢复为 `0.0.0`，以匹配上游锁文件和 snapshots。发布包只在 `fork-release.yml` 中构建和验证。

## 跟上游同步

`origin/upstream` 只镜像开发主线。手动同步一次：

```
git fetch upstream main
git push origin upstream/main:upstream
```

不要因为 `origin/upstream` 有新 commit 就更新 `main`。先等上游发布要采用的 `rust-v*` tag。`main` 采用 rebase，不 merge 上游开发分支：

```powershell
git fetch upstream --tags
git fetch origin main
$oldTag = "rust-v<当前基线>"
$newTag = "rust-v<目标版本>"
git switch --create "sync/$newTag" origin/main
git rebase --onto $newTag $oldTag
# 冲突只按 OVERLAY 重新应用 fork 补丁
git push --set-upstream origin HEAD
# 开 PR 进 main，只做审查和 CI
```

`fork-ci.yml` 会直接 checkout 同步分支的 head，不测试 GitHub 生成的临时 merge commit。PR 的 `Fork CI` 全绿后，记录当前远端 `main` SHA，临时停用 `Protect main` ruleset，再更新 `main`：

```powershell
$expected = git rev-parse origin/main
git push "--force-with-lease=refs/heads/main:$expected" origin HEAD:main
# 立即恢复 ruleset，然后关闭 PR、删除临时分支
```

不要点击同步 PR 的 merge。该分支从新 release tag 开始，和旧 `main` 分叉；三方合并会把旧基线独有的代码重新带回来。rebase 后的 `main` 始终是“上游 release commit + fork commits”的线性历史。

重新应用完成后：

1. 打开 `OVERLAY.md`，每一行看一遍：这块补丁还要不要。
2. 对照上面的原则，看上游这轮有没有把多模型支持收窄。暂不处理就记到 `backlog.md`；决定处理就更新现有 ADR，或为独立决策新建 ADR。
3. 上游已经合入等价功能的，删除重复补丁和 overlay 条目。ADR 还有现行内容就直接修改，否则删除。
4. 跑各 ADR 里的「如何确认」；没写测试的，按手册检查点做一遍。
5. 改过 overlay 或 ADR 就一并提交。

同步把行为弄丢，多半是 overlay 没更新，或 ADR 里没有可执行的确认步骤。

## 给 agent 的约束

改这个仓库时：

- fork 专属文档只写在 `fork/`。
- 不要为了 fork 去改上游 `docs/`。
- 动代码前先看 `OVERLAY.md`、相关 ADR，以及本文「目标」「原则」。
- 新代码优先走适配层，避免再增加 GPT 专用分支。
- 计划只放 `backlog.md`。开始写 ADR，决策就立即生效；变化直接改原 ADR，失效就删除。
- 验证按本文「验证」执行。
- 不要主动增加 gate 或保护。默认人会遵守文档，违反契约时直接报错。
- 不要改上游 `.github/workflows/` 里已有的 yml。fork 专属 workflow 只放 `fork-ci.yml`、`fork-release.yml` 和 `fork-sync-upstream.yml`。
- 发布同步只 rebase fork commits，不 merge `origin/upstream`。
- 上游新 workflow 出现在 Actions 里时，跑 `fork/scripts/disable-upstream-workflows.ps1`。
