# 简视TV · 小米 REDMI 智能电视 A65 专用看电视应用

一个可以直接安装到 **REDMI 智能电视 A65（L65RB-RAE）** 上的 Android TV 应用：全屏播放 + 左侧频道列表 + 纯遥控器操作。暗灰 / 翠绿大屏 UI，无广告、无后台常驻、无联网统计。

## 0. 当前交付状态（2026-11-16）

| 项目 | 值 |
| --- | --- |
| 成品 APK | `dist\JianshiTV-v1.0.0.apk` |
| 大小 / SHA256 | 4,912,918 B / `7adb6bcf7242913d6f19217a03dbc262fb24d88d8a747b7c9f8027cbe7964e93` |
| 签名校验 | `apksigner verify` 通过（v1 + v2 均已验证），可直接安装 |
| 包名 / 版本 | `com.jianshi.tv` / `1.0.0`，应用名「简视TV」 |
| minSdk / targetSdk | 23 / 34（覆盖澎湃 OS 的 Android 内核） |
| 桌面入口 | `LEANBACK_LAUNCHER` 与 `LAUNCHER` 均已声明，带 320×180 电视横幅 |
| 构建环境 | 本机便携环境 `..\.build-env\`（JDK 17 + Gradle 8.7 + Android SDK 34），可随时删除释放空间 |

构建命令已验证：`gradle assembleDebug` → **BUILD SUCCESSFUL**。本机 `tools\build_local.bat` 可复现。

> 关于「小程序」：**微信小程序不能安装到小米电视上**。小米澎湃 OS 的应用形态是 Android APK（不是微信小程序宿主）。因此本交付物是 **Android TV APK**，在电视桌面有独立图标与横幅（LEANBACK_LAUNCHER），装完用遥控器即可使用。若需要手机端小程序做「遥控器 / 选台」，可以作为第二阶段单独开发，通过局域网与本应用通信。

---

## 1. 设备适配（依据商品详情截图）

| 电视参数 | 截图中的值 | 应用侧对应设计 |
| --- | --- | --- |
| 型号 / 系统 | L65RB-RAE / 小米澎湃 OS | `minSdk 23`、`targetSdk 34`、compileSdk 34，兼容 Android 内核 |
| CPU / 内存 | 四核 A35 / 2GB RAM | 纯 Java + 单 ExoPlayer 实例，无动画、无多进程，保守缓冲 1.5s~8s |
| 分辨率 / 刷新率 | 超高清 4K / 144Hz / 16:9 | 横屏全屏、10-foot UI（22~34sp）、SurfaceView 硬解 |
| 网络 | 2.4G WiFi / 有线 | 起播缓冲 1s，最大缓冲 8s，避免弱网长时间转圈 |
| 接口 | HDMI2.0 ×2、USB2.0 ×2、无 USB3.0 | 支持 U 盘安装 APK 与 ADB 调试安装 |
| 无摄像头 | 无摄像头 | 不依赖扫码 / 视觉交互，全部靠遥控器按键 |
| 语音 | 人工智能语音（蓝牙遥控器） | 不占用语音通道，按键映射完整 |

---

## 2. 功能

- **全屏播放**：Media3 ExoPlayer，支持 HLS(m3u8)、DASH(mpd)、MP4、RTSP；硬件解码优先。
- **频道列表**：左侧 420dp 大卡片列表，显示频道号 / 名称 / 分组 / 正在播放标记，D-pad 焦点高亮。
- **换台**：上下键直接换台；数字键输入频道号（1.5 秒自动跳转）；频道上/下键同样可用。
- **源管理**：网络 URL 导入、本地文件（SAF）导入、ADB 推送、一键恢复内置演示源；支持标准 m3u（`tvg-name` / `group-title` / `tvg-logo`）和 JSON 频道表。
- **画面比例**：适应 / 裁切铺满 / 拉伸铺满，设置持久化。
- **记忆**：记住上次观看的频道，重启自动回到该频道。
- **弱网容错**：播放失败自动提示并弹出频道列表，不会黑屏卡死。

### 遥控器按键表

| 按键 | 功能 |
| --- | --- |
| 上 / 下 | 列表显示时移动焦点；全屏播放时上一个 / 下一个频道 |
| 左 | 呼出频道列表 |
| 右 | 收起列表，进入纯净全屏 |
| 确认 / OK | 列表内播放选中频道；全屏时显示频道信息条 |
| 0~9 | 输入频道号，1.5 秒后自动跳转 |
| 菜单 / 指南 / 信息 | 打开源管理与设置 / 切换列表显隐 |
| 播放暂停 | 暂停 / 继续 |
| 返回 | 先收起列表，再连按两次退出（防误触） |

---

## 3. 安装到电视（三种方式，按推荐顺序）

### 方式 A：ADB 无线安装（最稳，推荐）

1. 电视与电脑连**同一个局域网**。
2. 电视：`设置 → 关于本机 → 用遥控器连续按「确认」7 次` 打开开发者选项，开启 **ADB 调试 / 网络调试**。
3. 电视：`设置 → 网络` 查看电视 IP（如 `192.168.1.100`）。
4. 电脑上运行：

```bat
tools\install_adb.bat 192.168.1.100
```

脚本会自动 `adb connect` → `adb install -r` → 启动应用。**本机已随构建环境附带 `adb.exe`（`..\.build-env\android-sdk\platform-tools\`），脚本会自动找到它，无需另装 Android Studio**；若把便携环境删掉了，脚本会提示你补装 platform-tools。

### 方式 B：U 盘安装（不用电脑命令行）

1. 把 `dist\JianshiTV-v1.0.0.apk` 拷到 U 盘根目录（FAT32 最稳，插电视 USB2.0 口）。
2. 电视：`设置 → 账号与安全 → 允许安装未知来源应用`（部分版本需同时关闭「纯净模式」）。
3. 打开电视上的「电视管家 / 文件管理器 / 高清播放器」找到 U 盘中的 APK，按确认安装。
4. 安装后在「我的应用」里找到 **简视TV**（横幅图标）。

### 方式 C：小米电视助手 / 手机推送

手机与电视同网，用「小米电视助手」或任意「电视应用推送」工具把 APK 推送到电视安装；前提同样是开启未知来源。

---

## 4. 导入你自己的频道源（重要）

**本应用不内置、不提供、不分发任何电视直播频道或直播源。** 内置的是 W3C / MDN / Mux / Apple / Google 等机构公开提供的官方测试视频流，只用来验证播放器和遥控器是否正常。要看真实电视台，请使用你**已获合法授权**的源（例如运营商 IPTV、自有内容服务器、官方公开直播流），自行导入：

| 方式 | 操作 | 适用场景 |
| --- | --- | --- |
| ① 网络 URL | 按菜单键 → 输入 m3u / json 地址 → 「导入网络源」 | 自建或已授权的订阅地址 |
| ② 本地文件 | 菜单键 → 「选择本地文件」→ 选 U 盘里的 `.m3u` | 电视能识别 U 盘文件时 |
| ③ ADB 推送（最稳） | `tools\push_channels.bat 192.168.1.100 channels.m3u` | 电视没有文件选择器时 |

ADB 推送的目标路径（APP 私有目录，不需要存储权限）：

```
/sdcard/Android/data/com.jianshi.tv/files/channels.m3u
```

推送后回到应用，列表会自动刷新。频道源格式示例见 `tools\channels_example.m3u`；JSON 格式见 `app/src/main/assets/channels.json`。

> 提示：电视只有 2.4G WiFi，若直播源码率高（4K 原码），建议走有线网络；应用已在 Manifest 中允许 `http://` 明文，以兼容家庭内网 / 运营商局域网的单播源。

---

## 5. 合规声明

- 本项目只提供**播放器框架与频道管理界面**，不含任何未授权的电视台直播流、破解源、聚合爬取或解密逻辑。
- 内置演示流均为各机构公开发布、允许用于测试的样例视频。
- 频道内容的合法授权、版权与传播责任由导入该源的使用人自行承担。
- 应用无广告、无用户数据上传、无后台服务、无自启动。

---

## 6. 本地二次开发 / 构建

工程为标准 Gradle 结构，可直接用 **Android Studio（Ladybug 及以上）** 打开根目录编译，或执行 `tools\build_local.bat`（会自动检查 Java 17 / Gradle 8.7 / Android SDK 34）。

| 组件 | 版本 |
| --- | --- |
| Android Gradle Plugin | 8.5.2 |
| Gradle | 8.7 |
| JDK | 17 |
| compileSdk / build-tools | 34 / 34.0.0 |
| Media3 ExoPlayer | 1.4.1 |
| minSdk / targetSdk | 23 / 34 |

主要源码：

```
app/src/main/java/com/jianshi/tv/
  MainActivity.java       遥控器按键、播放、UI 状态机
  ChannelSource.java      m3u/JSON 解析、网络导入、私有目录读写
  ChannelAdapter.java     频道列表与 D-pad 焦点
  SettingsActivity.java   源管理 / 画面比例
  Channel.java            频道数据模型
app/src/main/assets/channels.json   内置演示源
```

APK 默认用 Gradle debug 签名，**可直接安装**；若要上架或长期分发，建议换成自己的正式签名（`app/build.gradle` 中配置 signingConfigs）。

---

## 7. 常见问题

| 现象 | 处理 |
| --- | --- |
| 桌面找不到图标 | 部分小米桌面只显示「我的应用」，或需重启桌面；ADB 用 `adb shell am start -n com.jianshi.tv/.MainActivity` 直接启动验证 |
| 安装被拦截 | 开启「允许安装未知来源应用」并关闭「纯净模式」 |
| 演示频道播不出来 | 多为网络可达性问题，用方式 ③ 换成自己的合法源 |
| 频道号输入无效 | 检查 m3u 中是否有 `#EXTINF`；无编号时应用按列表顺序从 1 自动编号 |
| 画面变形 | 菜单键 → 画面比例 → 切换「适应 / 裁切 / 拉伸」 |
| 遥控器菜单键无反应 | 部分遥控器把菜单键映射为「指南 / 信息」，两者都已适配 |

---

## 8. GitHub 仓库与自动构建

源码仓库：<https://github.com/HenryYe2026/jianshi-tv-android>

仓库内置 `.github/workflows/build.yml`：每次推送到 `main`（或在 Actions 页手动触发 `workflow_dispatch`），CI 会自动安装 JDK 17 / Gradle 8.7 / Android SDK 34，执行 `gradle assembleDebug`，并把编译好的 `JianshiTV-v1.0.0.apk` 发布为 Release 附件（tag `v1.0.0`），可直接下载安装到电视。

仓库同时收录 `dist\JianshiTV-v1.0.0.apk`（4.9 MB，可直接下载装电视）；CI 的 Release 附件会持续产出最新构建。本机专属的 `local.properties`（含 SDK 绝对路径）已在 `.gitignore` 中排除，不进仓库。

> 推送工程：本机 `tools\push_to_github.bat` 走 git + 浏览器 OAuth 一键推送；若网络代理拦截了 `github.com` 的 git 端点，可改用 PAT + `api.github.com` 的 REST 通道（`.build-env\upload_with_pat.py`），不需要 GitHub 应用写权限。
