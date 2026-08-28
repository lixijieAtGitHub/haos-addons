FROM snowdreamtech/frpc:0.56.0

# 复制启动脚本并赋予执行权限
COPY run.sh /run.sh
USER root
RUN chmod a+x /run.sh

# 【关键修改】强制覆盖原镜像的启动入口，确保脚本执行
ENTRYPOINT [ "/run.sh" ]
