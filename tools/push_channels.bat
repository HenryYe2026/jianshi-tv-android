@echo off
chcp 65001 >nul
setlocal
if "%~2"=="" (
  echo 用法: push_channels.bat 电视IP地址 频道源文件.m3u
  echo 示例: push_channels.bat 192.168.1.100 tools\channels_example.m3u
  echo.
  echo 目标路径: /sdcard/Android/data/com.jianshi.tv/files/channels.m3u
  pause
  exit /b 1
)
set "TVIP=%~1"
set "SRC=%~2"
if not exist "%SRC%" (
  echo [错误] 找不到频道源文件: %SRC%
  pause
  exit /b 1
)
set "LOCAL_ADB=%~dp0..\..\.build-env\android-sdk\platform-tools"
where adb >nul 2>nul
if errorlevel 1 (
  if exist "%LOCAL_ADB%\adb.exe" set "PATH=%LOCAL_ADB%;%PATH%"
)
where adb >nul 2>nul
if errorlevel 1 (
  echo [错误] 未找到 adb.exe，请安装 Android SDK platform-tools 并加入 PATH
  pause
  exit /b 1
)
echo [1/4] 连接电视 ...
adb connect %TVIP%:5555
echo [2/4] 创建 APP 私有目录 ...
adb shell mkdir -p /sdcard/Android/data/com.jianshi.tv/files/
echo [3/4] 推送频道源 ...
adb push "%SRC%" /sdcard/Android/data/com.jianshi.tv/files/channels.m3u
if errorlevel 1 (
  echo [错误] 推送失败
  pause
  exit /b 1
)
echo [4/4] 重启应用使列表刷新 ...
adb shell am force-stop com.jianshi.tv
adb shell am start -n com.jianshi.tv/.MainActivity
echo 完成。请使用你已获合法授权的频道源。
pause
