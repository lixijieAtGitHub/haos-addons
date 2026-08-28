#!/bin/sh
echo "正在检查 FRP 配置文件..."

# 我们把配置统一放在 HAOS 的 /config/frp 文件夹下，方便您以后用 File editor 修改
mkdir -p /config/frp

# 如果不存在配置，则自动生成
if [ ! -f /config/frp/frpc.toml ]; then
    echo "未找到配置文件，正在自动生成 /config/frp/frpc.toml ..."
    cat <<EOF > /config/frp/frpc.toml
serverAddr = "123.56.255.44"
serverPort = 7000
auth.method = "token"
auth.token = "Haos_Secure_Token_2026"

[[proxies]]
name = "haos_web"
type = "tcp"
localIP = "homeassistant"   # 【完美修复】使用 HAOS 内部域名直连主机
localPort = 80
remotePort = 8123
EOF
fi

echo "同步配置并启动 FRP 客户端..."
# 【关键修改】将您 config 里的配置复制到镜像强行要求的 etc 目录下
cp /config/frp/frpc.toml /etc/frp/frpc.toml

# 启动 FRP
exec /usr/bin/frpc -c /etc/frp/frpc.toml
