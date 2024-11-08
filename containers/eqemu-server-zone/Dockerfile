FROM debian:12-slim as builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
    bash \
    build-essential \
    cmake \
    cpp \
    debconf-utils \
    g++ \
    gcc \
    libboost-dev \
    libcurl4-openssl-dev \
    liblua5.1-dev \
    libmariadb-dev \
    libsodium-dev \
    libssl-dev \
    lua5.1 \
    lua-bitop \
    make \
    mariadb-client \
    uuid-dev

COPY Server/client_files /source/client_files
COPY Server/cmake /source/cmake
COPY Server/common /source/common
COPY Server/dependencies /source/dependencies
COPY Server/eqlaunch /source/eqlaunch
COPY Server/libs /source/libs
COPY Server/submodules /source/submodules
COPY Server/tests /source/tests
COPY Server/utils /source/utils
COPY Server/zone /source/zone
COPY Server/CMakeLists.txt /source/CMakeLists.txt

WORKDIR /source

# Pass the EQEMU_BUILD_LOGIN option to cmake to disable building the login server
RUN mkdir -p build && \
    cd build && \
    cmake -G 'Unix Makefiles' -DEQEMU_BUILD_LOGIN=OFF -DEQEMU_BUILD_ZONE_ONLY=ON .. && \
    make -j `grep -P '^core id\t' /proc/cpuinfo | sort -u | wc -l`

FROM debian:12-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
    bash \
    gdb \
    gettext-base \
    git \
    liblua5.1-0 \
    lua5.1 \
    lua-bitop \
    mariadb-client \
    nano

RUN mkdir -p /app/logs
RUN mkdir -p /app/shared

WORKDIR /app

COPY --from=ghcr.io/ufoscout/docker-compose-wait:latest /wait /wait
COPY --from=builder /source/build/bin /app

ADD Server/loginserver/login_util/*.conf /app/
ADD Server/utils/patches/*.conf /app/

ADD Maps /app/Maps
# Quests directory is mapped via docker compose volume, just need to make sure the directory exists
RUN mkdir -p /app/quests

ADD containers/eqemu-server/login.template.json /app/
ADD containers/eqemu-server/eqemu_config.template.json /app/

ADD containers/eqemu-server/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
