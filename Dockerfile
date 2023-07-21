FROM python:3
ARG USER=worker
ARG USER_UID=1000
ARG USER_GID=1000
ENV TZ=Asia/Tokyo
RUN apt-get update && \
    apt-get install -y tzdata && \
    echo "${TZ}" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata
RUN apt-get update && \
    apt-get install -y locales && \
    echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV LC_ALL=ja_JP.UTF-8

# create user
RUN groupadd -g ${USER_GID} ${USER} && \
    useradd -m -s /bin/bash -u ${USER_UID} -g ${USER_GID} ${USER}

USER ${USER}

