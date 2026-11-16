@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0.."

echo ============================================================
echo   推送 简视TV 全量工程到 GitHub
echo   https://github.com/HenryYe2026/jianshi-tv-android
echo ============================================================
echo.
echo 当前远端只有 7 个根目录文件，本脚本会补上 app\、tools\、
echo dist\ APK、.github\workflows\ 等全部内容（共 33 个文件）。
echo.
echo 首次推送会弹出 GitHub 登录窗口，请在浏览器里完成授权（只需一次）。
echo 若要求输入密码：GitHub 已停用账号密码，请用 Personal Access Token 当密码。
echo.

echo [1/3] 同步远端最新提交 ...
git fetch origin main
if errorlevel 1 (
  echo [提示] fetch 失败，直接尝试推送本地已有历史。
) else (
  git merge --no-edit -X ours origin/main >nul 2>nul
)

echo [2/3] 推送（使用 OpenSSL 后端，避开 schannel/代理兼容问题）...
git -c http.sslBackend=openssl -c http.version=HTTP/1.1 -c http.postBuffer=524288000 push -u origin main
if errorlevel 1 (
  echo.
  echo [推送失败] 常见原因与对应处理：
  echo   1) 浏览器授权未完成 / 已取消 ： 重新运行本脚本并完成授权
  echo   2) 报 CONNECT tunnel failed / 502 ： 本机代理拦截 github.com，
  echo      改用 REST API 通道：生成 PAT 存入 ..\.build-env\github_pat.txt，
  echo      然后让 WorkBuddy 运行 upload_with_pat.py 代推（只需 api.github.com）
  echo   3) 权限不足 ： PAT 需要 Contents: Read and write + Workflows: Read and write
  echo.
  pause
  exit /b 1
)

echo [3/3] 完成
echo 仓库已更新: https://github.com/HenryYe2026/jianshi-tv-android
echo 源码 + APK 均已上传；Actions 会自动构建并发布 Release。
pause
