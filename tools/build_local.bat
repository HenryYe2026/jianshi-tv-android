@echo off
chcp 65001 >nul
setlocal
set "ROOT=%~dp0.."
cd /d "%ROOT%"

echo ==== 简视TV 本地构建 ====
echo [1/5] 检查 JDK ...
where java >nul 2>nul
if errorlevel 1 (
  echo [错误] 未找到 java。请安装 JDK 17（Temurin / Android Studio 自带 JBR 均可）
  pause
  exit /b 1
)
java -version 2>&1 | findstr /C:"17" >nul
if errorlevel 1 echo [警告] 当前 JDK 可能不是 17，AGP 8.5.2 要求 JDK 17

echo [2/5] 检查 Android SDK ...
if "%ANDROID_HOME%"=="" if "%ANDROID_SDK_ROOT%"=="" (
  echo [错误] 未设置 ANDROID_HOME / ANDROID_SDK_ROOT
  echo        请安装 Android Studio 或 Android cmdline-tools，并安装：
  echo          sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools"
  pause
  exit /b 1
)

echo [3/5] 检查 Gradle 8.7 ...
set "GRADLE_CMD=%ROOT%\tools\.gradle\gradle-8.7\bin\gradle.bat"
if not exist "%GRADLE_CMD%" (
  echo        正在下载 Gradle 8.7（约 130MB）...
  curl -fsSL https://services.gradle.org/distributions/gradle-8.7-bin.zip -o "%TEMP%\gradle-8.7-bin.zip"
  if errorlevel 1 (
    echo [错误] Gradle 下载失败，请手动下载并解压到 tools\.gradle
    pause
    exit /b 1
  )
  powershell -NoProfile -Command "Expand-Archive -Force '%TEMP%\gradle-8.7-bin.zip' '%ROOT%\tools\.gradle'"
)

echo [4/5] 编译 assembleDebug ...
call "%GRADLE_CMD%" assembleDebug --no-daemon --stacktrace
if errorlevel 1 (
  echo [错误] 编译失败，请查看上方日志
  pause
  exit /b 1
)

echo [5/5] 收集 APK ...
if not exist "%ROOT%\dist" mkdir "%ROOT%\dist"
copy /Y "%ROOT%\app\build\outputs\apk\debug\app-debug.apk" "%ROOT%\dist\JianshiTV-v1.0.0.apk" >nul
echo 完成: %ROOT%\dist\JianshiTV-v1.0.0.apk
echo 安装: tools\install_adb.bat 电视IP
pause
