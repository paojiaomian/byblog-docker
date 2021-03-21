FROM frolvlad/alpine-python3:latest
ARG pip_url=http://mirrors.aliyun.com/pypi/simple/
ARG pip_host=mirrors.aliyun.com
ARG work_home=/opt/cloud/blog
ENV PYTHONUNBUFFERED=1

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN mkdir -p ${work_home}
WORKDIR ${work_home}
COPY ./blog .
COPY ./blog/requirements.txt requirements.txt
RUN cp -a /etc/apk/repositories /etc/apk/repositories.bak && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories && apk add -U jpeg-dev zlib-dev gcc python3-dev lib-dev tzdata
RUN pip install --user --upgrade pip
RUN pip3 install -r requirements.txt -i ${pip_url} --trusted-host ${pip_host}
# 修改django框架下的文件
# COPY ./operations.py /usr/lib/python3.8/site-packages/django/db/backends/mysql/