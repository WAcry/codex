# 禁用 WAcry/codex 上除 fork-ci / fork-release / fork-sync-upstream 以外的 GitHub Actions。
# 上游 YAML 留在树里，只改远端启用状态。需要 gh 已登录。
#
# 用法：在仓库根目录 pwsh -File fork/scripts/disable-upstream-workflows.ps1

$ErrorActionPreference = "Stop"
$repo = "WAcry/codex"
$keep = @(
    ".github/workflows/fork-ci.yml",
    ".github/workflows/fork-release.yml",
    ".github/workflows/fork-sync-upstream.yml"
)

$workflowJson = gh workflow list --all --limit 1000 --repo $repo --json path,state,id,name
if ($LASTEXITCODE -ne 0) {
    throw "读取 $repo 的 workflow 失败。"
}
$workflows = $workflowJson | ConvertFrom-Json
if (-not $workflows) {
    Write-Host "没有列出任何 workflow。先把 fork-ci.yml 合进 main，并在仓库 Settings > Actions 里打开 Actions。"
    exit 1
}

foreach ($wf in $workflows) {
    $path = $wf.path
    if ($keep -contains $path) {
        if ($wf.state -ne "active") {
            Write-Host "启用 $path"
            gh workflow enable --repo $repo $wf.id
            if ($LASTEXITCODE -ne 0) {
                throw "启用 $path 失败。"
            }
        }
        else {
            Write-Host "保留 $path"
        }
        continue
    }

    if ($wf.state -eq "active") {
        Write-Host "禁用 $path"
        gh workflow disable --repo $repo $wf.id
        if ($LASTEXITCODE -ne 0) {
            throw "禁用 $path 失败。"
        }
    }
    else {
        Write-Host "已经禁用 $path"
    }
}

$activeJson = gh workflow list --all --limit 1000 --repo $repo --json path,state
if ($LASTEXITCODE -ne 0) {
    throw "复核 $repo 的 workflow 失败。"
}
$unexpected = $activeJson |
    ConvertFrom-Json |
    Where-Object { $_.state -eq "active" -and $keep -notcontains $_.path }
if ($unexpected) {
    throw "仍有上游 workflow 处于启用状态：$($unexpected.path -join ', ')"
}
