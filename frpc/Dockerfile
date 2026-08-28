FROM snowdreamtech/frpc:0.56.0

# 复制启动脚本并赋予执行权限
COPY run.sh /run.sh
USER root
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
