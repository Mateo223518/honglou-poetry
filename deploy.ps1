# ============================================================
# 红楼梦诗词检索站 · GitHub Pages 一键部署脚本
# 用法：在项目根目录执行  powershell -ExecutionPolicy Bypass -File deploy.ps1
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "===== 红楼梦诗词检索站 · 部署脚本 =====" -ForegroundColor Cyan
Write-Host ""

# 1. 初始化 git
if (-not (Test-Path ".git")) {
    Write-Host "[1/4] 初始化 git 仓库..." -ForegroundColor Yellow
    git init
} else {
    Write-Host "[1/4] git 仓库已存在，跳过初始化" -ForegroundColor Green
}

# 2. 添加并提交
Write-Host "[2/4] 添加文件并提交..." -ForegroundColor Yellow
git add .
$status = git status --porcelain
if ($status) {
    git commit -m "红楼梦诗词检索站 · 部署 $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    Write-Host "      提交完成" -ForegroundColor Green
} else {
    Write-Host "      没有变更，跳过提交" -ForegroundColor Green
}

# 3. 设置 main 分支
Write-Host "[3/4] 切换到 main 分支..." -ForegroundColor Yellow
git branch -M main

# 4. 推送到远程
Write-Host "[4/4] 配置远程仓库..." -ForegroundColor Yellow
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Host ""
    Write-Host "请输入你的 GitHub 仓库地址，例如：" -ForegroundColor Cyan
    Write-Host "  https://github.com/你的用户名/honglou-poetry.git" -ForegroundColor Gray
    $userUrl = Read-Host "仓库地址"
    if (-not $userUrl) {
        Write-Host "未输入地址，已跳过推送。请手动执行：" -ForegroundColor Red
        Write-Host "  git remote add origin <你的仓库地址>" -ForegroundColor Gray
        Write-Host "  git push -u origin main" -ForegroundColor Gray
        exit 0
    }
    git remote add origin $userUrl
    $remoteUrl = $userUrl
}

Write-Host "      正在推送到 $remoteUrl ..." -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "===== 推送成功 =====" -ForegroundColor Green
    Write-Host ""
    Write-Host "最后一步：开启 GitHub Pages" -ForegroundColor Cyan
    Write-Host "  1. 打开仓库 Settings -> Pages" -ForegroundColor White
    Write-Host "  2. Source 选 Deploy from a branch" -ForegroundColor White
    Write-Host "  3. Branch 选 main / root，点 Save" -ForegroundColor White
    Write-Host "  4. 等 1-2 分钟访问你的公开链接" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "推送失败，常见原因：" -ForegroundColor Red
    Write-Host "  - 未配置 GitHub 凭证（用 git config --global user.email/user.name 设置）" -ForegroundColor Gray
    Write-Host "  - 仓库地址错误或仓库不存在" -ForegroundColor Gray
    Write-Host "  - 网络问题，重试 git push -u origin main" -ForegroundColor Gray
}
