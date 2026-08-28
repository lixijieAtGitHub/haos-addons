#!/bin/sh
echo "正在检查 FRP 配置文件..."

# 如果 HAOS 的 /config 目录下没有 frpc.toml，则自动创建一个
if [ ! -f /config/frpc.toml ]; then
    echo "未找到配置文件，正在自动生成 /config/frpc.toml ..."
    cat <<EOF > /config/frpc.toml
serverAddr = "123.56.255.44"
serverPort = 7000
auth.method = "token"
auth.token = "Haos_Secure_Token_2026"

[[proxies]]
name = "haos_web"
type = "tcp"
localIP = "127.0.0.1"
localPort = 80          # 必须修改！对应您 HAOS 实际运行的 80 端口
remotePort = 8123
EOF
fi

echo "启动 FRP 客户端..."
# 启动 snowdreamtech 镜像内置的 frpc [citation:1]
exec /usr/bin/frpc -c /config/frpc.toml
