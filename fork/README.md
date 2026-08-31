# Fork 文档

本目录只服务 [WAcry/codex](https://github.com/WAcry/codex) 相对上游的二次开发。上游仓库是 [openai/codex](https://github.com/openai/codex)。

不要往仓库根目录的 `docs/`、`README.md`、`AGENTS.md` 加 fork 说明。那些文件上游改得勤，写进去每次同步都会冲突，也可能被 agent 按上游规则清掉。

本目录文档只写中文。

## 目标

改动要小、要精炼。能新建文件就不要改热点；能配置或适配层解决就不要分叉业务逻辑。每一处补丁都要能说清：少了它哪条原则或功能会坏。补丁越少，以后和上游合并时冲突越少。

## 原则

这个 fork 不只攒功能。功能可以等，原则用来判断上游新代码要不要动。

当前的初心：让 Codex 能好好接多种 LLM，而不是只围绕 GPT / OpenAI 官方接口来写。

同步 `upstream/main` 时，除了按 [OVERLAY.md](OVERLAY.md) 保住已有补丁，还要扫一眼上游新增的模型、鉴权、协议、provider 相关代码。如果它把行为写死在单一厂商上（硬编码模型名、只认一种 API、把 ChatGPT 登录当成唯一路径），即使我们还没做对应功能，也要开 ADR 评估：忽略、加适配，还是改一刀。原则和现有功能冲突时，优先保住原则，再决定功能要不要跟。

原则本身若要改，先写 ADR，不要在同步时口头改口径。

## 文件

| 文件 | 用途 |
|------|------|
| [README.md](README.md) | 怎么维护这个 fork、怎么同步 |
| [OVERLAY.md](OVERLAY.md) | 活清单：改过哪些路径、同步时留哪边 |
| [adr/0000-template.md](adr/0000-template.md) | 新 ADR 的模板 |
| [adr/](adr/) | 已落地或拟议的决策，一篇一个文件 |
| [backlog.md](backlog.md) | 还没写成 ADR 的想法 |
| [scripts/](scripts/) | 禁用上游 Actions、发版时盖 workspace 版本 |

ADR 写完并 Accepted 之后，正文不要改。只改 Status。计划中的事放 `backlog.md`，不要和已接受的决策混在一篇里。

已接受：

- [0001 版本与发布](adr/0001-fork-版本与发布.md)
- [0002 main 与 CI](adr/0002-main-分支与持续集成.md)
- [0003 安装与升级检测](adr/0003-安装与升级检测.md)

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

`main` 尽量跟上游，但不要直接 `git push origin main`。改动和上游同步都走 PR，CI 绿了之后 squash。规则见 [ADR 0002](adr/0002-main-分支与持续集成.md)。

## 改代码时

1. 能新建文件就新建，少改热点文件。
2. 先写或更新 ADR（`fork/adr/NNNN-标题.md`），编号四位、递增。
3. 在 `OVERLAY.md` 加一行：ADR 编号、路径、冲突时的策略、是否还需要。
4. commit message 带 `Fork-ADR: NNNN`，方便以后 `git log --grep=Fork-ADR`。

## 版本与发布

规则见 [ADR 0001](adr/0001-fork-版本与发布.md)。

- 版本：`{上游完整版本}.wa.{N}`，标签 `wa-v` 加版本，例如 `wa-v0.152.0-alpha.6.wa.1`
- `main` 上 `codex-rs` workspace 版本保持 `0.0.0`
- 推标签后由 `fork-release.yml` 编 Windows x64 和 Linux x64 GNU，挂到 GitHub Releases
- 不发 npm / R2 / WinGet，不签名

```
git tag -a wa-v0.152.0-alpha.6.wa.1 -m "wa 0.152.0-alpha.6.wa.1"
git push origin wa-v0.152.0-alpha.6.wa.1
```

## 安装

规则见 [ADR 0003](adr/0003-安装与升级检测.md)。

从 [Releases](https://github.com/WAcry/codex/releases) 下载：

- Windows x64：`codex-x86_64-pc-windows-msvc.exe`，改名为 `codex.exe`
- Linux x64：`codex-x86_64-unknown-linux-gnu`，改名为 `codex`，`chmod +x`

放到已在 PATH 里的目录。不要用官方 `install.sh`、`npm i -g @openai/codex` 或 Homebrew cask 来装这个 fork，那些会装 openai 的包。

TUI/CLI 不检查、不提示升级。换版本就再下一份覆盖。

## 跟上游同步

```
git fetch upstream
git checkout -b sync/upstream-$(Get-Date -Format yyyy-MM-dd)
git merge upstream/main
# 冲突按 OVERLAY 处理，然后开 PR 进 main
```

冲突解开之后：

1. 打开 `OVERLAY.md`，每一行看一遍：这块补丁还要不要。
2. 对照上面的原则，看上游这轮有没有把多模型支持收窄。有的话记到 `backlog.md` 或直接开 ADR，不要合进去就不管了。
3. 上游已经合入等价功能的，删掉我们的补丁，把对应 ADR 标成 `Dropped` 或 `Superseded`，并写上上游 PR/issue。
4. 跑各 ADR 里的「如何确认」；没写测试的，按手册检查点做一遍。
5. 改过 overlay 或 ADR 状态就一并提交。

同步把行为弄丢，多半是 overlay 没更新，或 ADR 里没有可执行的确认步骤。

## 给 agent 的约束

改这个仓库时：

- fork 专属文档只写在 `fork/`。
- 不要为了 fork 去改上游 `docs/`。
- 动代码前先看 `OVERLAY.md`、相关 ADR，以及本文「目标」「原则」。
- 新代码优先走适配层，避免再增加 GPT 专用分支。
- 新决策用 `adr/0000-template.md` 开篇，中文写。
- 不要改上游 `.github/workflows/` 里已有的 yml。fork 的 CI/发布只放 `fork-ci.yml` 和 `fork-release.yml`。
- 上游新 workflow 出现在 Actions 里时，跑 `fork/scripts/disable-upstream-workflows.ps1`。
