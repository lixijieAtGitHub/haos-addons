# Home Assistant Add-on: FRP Client (Custom)
*Home Assistant 社区插件：FRP 客户端 (自定义增强版)*

[![Home Assistant Add-on](https://img.shields.io/badge/Home%20Assistant-Add--on-blue.svg)](https://www.home-assistant.io/)
[![FRP Version](https://img.shields.io/badge/frpc-v0.56.0-brightgreen.svg)](https://github.com/fatedier/frp)

A robust, gracefully-shutting-down FRP client built specifically for Home Assistant OS. Easily expose your local Home Assistant instance to the public internet.
专为 Home Assistant OS 打造的 FRP 客户端，支持平滑停机与 Web 界面配置，轻松将你的内网 HA 暴露至公网。

---

## ⚠️ Version Compatibility / 版本兼容性说明 (CRITICAL / 必读)

**This add-on is built on `FRP v0.56.0`.** 
Due to breaking changes in FRP's configuration format (switching from `.ini` to `.toml`) and protocol updates, **your Server-side (`frps`) MUST run a compatible version (v0.56.x is strictly recommended)**. Using an outdated server version will result in connection refused or protocol mismatch errors.

**本插件底层核心基于 `FRP v0.56.0` 构建。**
由于 FRP 官方在近期版本中进行了巨大的底层重构（全面弃用 `.ini`，改用 `.toml` 格式），**请务必确保您的云端服务端（`frps`）版本与本客户端保持兼容（强烈建议服务端也更新至 v0.56.x）**。如果服务端版本过低，将直接导致“连接被拒绝”或协议不匹配等报错！

---

## 🌟 Features / 核心特性

- **Built for v0.56+ (TOML):** Fully utilizes the new `.toml` configuration format for FRP.
- **Zero-Config Option:** Works out of the box with built-in default configurations.
- **Graceful Shutdown:** Implements proper `SIGTERM` handling. Say goodbye to Supervisor's `Exit Code 143` warnings!
- **UI Configurable:** Supports overriding configurations directly from the HA Add-on Web UI (YAML mode).

- **全面拥抱 TOML：** 采用 FRP 0.56+ 最新版本的 `.toml` 配置协议。
- **开箱即用：** 内置默认配置，新手小白也能一键启动。
- **平滑停机机制：** 完美拦截系统关机信号，彻底告别 Supervisor 日志中的 `143` 报错。
- **UI 界面配置：** 支持直接在 HA 网页端覆盖自定义配置，告别繁琐的 SSH 文件修改。

---

## 📦 Installation / 安装指南

### English
1. Navigate to your Home Assistant instance.
2. Go to **Settings** -> **Add-ons** -> **Add-on Store**.
3. Click the three dots (menu) in the top right corner and select **Repositories**.
4. Add this GitHub repository URL.
5. Search for "FRP Client (Custom)" and click **Install**.

### 中文
1. 登录你的 Home Assistant 面板。
2. 进入 **配置 (Settings)** -> **加载项 (Add-ons)** -> **加载项商店 (Add-on Store)**。
3. 点击右上角的三个点，选择 **仓库 (Repositories)**。
4. 将本 GitHub 仓库的 URL 地址添加进去。
5. 在商店中搜索 "FRP Client (Custom)" 并点击 **安装**。

---

## ⚙️ Configuration / 配置说明

By default, the add-on runs with a built-in configuration. However, you can completely override it using the HA UI.
默认情况下，插件会使用内置的配置运行。如果你需要修改服务器 IP、端口或 Token，可以直接在网页端覆盖。

### How to use Custom Config / 如何使用自定义配置：
1. Go to the Add-on's **Configuration** tab. / 进入插件的 **配置 (Configuration)** 页面。
2. Click the three dots in the top right and select **Edit in YAML**. / 点击右上角的三个点，选择 **在 YAML 中编辑**。
3. Paste your valid FRP TOML configuration under `custom_config:` (Make sure to keep the `|` symbol for multiline string). / 在 `custom_config:` 下方粘贴你的 TOML 配置（请务必保留 `|` 符号以支持多行文本）。

**Example / 配置示例：**

```yaml
custom_config: |
  serverAddr = "YOUR_SERVER_IP"
  serverPort = 7000
  auth.method = "token"
  auth.token = "Your_Secure_Token"

  [[proxies]]
  name = "haos_web"
  type = "tcp"
  localIP = "homeassistant"
  localPort = 8123
  remotePort = 8123
