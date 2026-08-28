FROM snowdreamtech/frpc:0.56.0

# 提前获取 root 权限，确保后续软件安装和文件操作无权限问题
USER root

# 安装 jq 工具，用于提取网页端传来的多行文本配置
RUN apk add --no-cache jq

# 复制启动脚本并赋予执行权限
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# 强制覆盖原镜像的启动入口，确保脚本执行
ENTRYPOINT [ "/run.sh" ]
