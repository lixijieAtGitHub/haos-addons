#!/bin/sh
echo "正在启动 FRP 客户端，初始化配置..."
mkdir -p /config/frp

# 无论旧文件是否存在，直接使用 > 强制覆盖生成全新的配置
echo "正在强制生成/更新 /config/frp/frpc.toml ..."
cat <<EOF > /config/frp/frpc.toml
serverAddr = "123.56.255.44"
serverPort = 7000
auth.method = "token"
auth.token = "Haos_Secure_Token_2026"

[[proxies]]
name = "haos_web"
type = "tcp"
localIP = "192.168.10.105"   # 完美域名直连
localPort = 80
remotePort = 8123
EOF

echo "同步配置并启动 FRP 核心程序..."
# 将强制更新后的配置复制到运行目录
cp /config/frp/frpc.toml /etc/frp/frpc.toml
exec /usr/bin/frpc -c /etc/frp/frpc.toml
