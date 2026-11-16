@echo off
chcp 65001 >nul
setlocal
set "ROOT=%~dp0.."
set "APK=%ROOT%\dist\JianshiTV-v1.0.0.apk"

if "%~1"=="" (
  echo 用法: install_adb.bat 电视IP地址
  echo 示例: install_adb.bat 192.168.1.100
  echo.
  echo 前置步骤: 电视 设置 ^> 关于本机 ^> 连按确认键 7 次开启开发者选项 ^> 开启 ADB 调试
  echo          电视与电脑需处于同一局域网
  pause
  exit /b 1
)
set "TVIP=%~1"

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
if not exist "%APK%" (
  echo [错误] 未找到 APK: %APK%
  pause
  exit /b 1
)

echo [1/4] 连接电视 %TVIP%:5555 ...
adb disconnect >nul 2>nul
adb connect %TVIP%:5555
echo [2/4] 安装应用（覆盖安装）...
adb install -r "%APK%"
if errorlevel 1 (
  echo [错误] 安装失败，请确认已开启「允许安装未知来源应用」与 ADB 调试
  pause
  exit /b 1
)
echo [3/4] 启动 简视TV ...
adb shell am start -n com.jianshi.tv/.MainActivity
echo [4/4] 完成。若桌面无图标，请到「我的应用」查看，或重启电视桌面。
pause
