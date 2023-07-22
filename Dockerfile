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
# git and github
RUN apt-get update && apt-get install -y git
RUN type -p curl >/dev/null || (apt update && apt install curl -y); \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y \
    && ln -s $(which gh) /usr/local/bin/
# create user
RUN groupadd -g ${USER_GID} ${USER} && \
    useradd -m -s /bin/bash -u ${USER_UID} -g ${USER_GID} ${USER}

USER ${USER}

