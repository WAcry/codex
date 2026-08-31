# 禁用 WAcry/codex 上除 fork-ci / fork-release 以外的 GitHub Actions。
# 上游 YAML 留在树里，只改远端启用状态。需要 gh 已登录。
#
# 用法：在仓库根目录 pwsh -File fork/scripts/disable-upstream-workflows.ps1

$ErrorActionPreference = "Stop"
$repo = "WAcry/codex"
$keep = @(
    ".github/workflows/fork-ci.yml",
    ".github/workflows/fork-release.yml"
)

$workflows = gh workflow list --all --repo $repo --json path, state, id, name | ConvertFrom-Json
if (-not $workflows) {
    Write-Host "没有列出任何 workflow。先把 fork-ci.yml 合进 main，并在仓库 Settings > Actions 里打开 Actions。"
    exit 1
}

foreach ($wf in $workflows) {
    $path = $wf.path
    if ($keep -contains $path) {
        if ($wf.state -ne "active") {
            Write-Host "enable $path"
            gh workflow enable --repo $repo $wf.id
        }
        else {
            Write-Host "keep $path"
        }
        continue
    }

    if ($wf.state -eq "active") {
        Write-Host "disable $path"
        gh workflow disable --repo $repo $wf.id
    }
    else {
        Write-Host "already disabled $path"
    }
}
