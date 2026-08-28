#!/bin/sh
echo "正在启动 FRP 客户端，初始化配置..."
mkdir -p /config/frp

# 🎯 新增逻辑：读取 HAOS 网页端的配置
# 使用 jq 提取 /data/options.json 里面的 custom_config 字段内容
CUSTOM_CONFIG=$(jq -r '.custom_config // empty' /data/options.json 2>/dev/null)

# 如果网页配置不为空，则使用自定义配置覆盖；否则走原有的默认配置逻辑
if [ -n "$CUSTOM_CONFIG" ] && [ "$CUSTOM_CONFIG" != "null" ]; then
    echo "检测到网页端自定义配置，正在覆盖生成 /config/frp/frpc.toml ..."
    echo "$CUSTOM_CONFIG" > /config/frp/frpc.toml
else
    # ================= 以下为你原封不动的默认代码 =================
    # 无论旧文件是否存在，直接使用 > 强制覆盖生成全新的配置
    echo "未检测到自定义配置，正在强制生成默认的 /config/frp/frpc.toml ..."
    cat <<EOF > /config/frp/frpc.toml
serverAddr = "123.56.255.44"
serverPort = 7000
auth.method = "token"
auth.token = "Haos_Secure_Token_2026"

[[proxies]]
name = "haos_web"
type = "tcp"
localIP = "homeassistant"   # 完美域名直连
localPort = 80
remotePort = 8123
EOF
    # ==============================================================
fi

echo "同步配置并启动 FRP 核心程序..."
# 将强制更新后的配置复制到运行目录
cp /config/frp/frpc.toml /etc/frp/frpc.toml


# =======================================================
# 以下为替换原 exec 指令的新增逻辑：平滑停机 (Graceful Shutdown)
# =======================================================

# 1. 定义停机处理函数
stop_handler() {
    echo "收到 HAOS 停止信号，正在平滑关闭 FRP..."
    if [ -n "$FRPC_PID" ]; then
        kill -TERM "$FRPC_PID" 2>/dev/null
        wait "$FRPC_PID" 2>/dev/null
    fi
    echo "FRP 客户端已安全停止 (Exit Code: 0)。"
    exit 0
}

# 2. 拦截 SIGTERM 和 SIGINT 信号
trap 'stop_handler' TERM INT

# 3. 将 FRP 放在后台启动（注意末尾的 & 号，不再使用 exec）
/usr/bin/frpc -c /etc/frp/frpc.toml &

# 4. 记录后台 FRP 的进程号
FRPC_PID=$!

# 5. 挂起主脚本，等待 FRP 进程，防止容器直接退出
wait "$FRPC_PID"
