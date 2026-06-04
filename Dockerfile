FROM debian:trixie-slim AS builder

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        lua5.1 \
        luarocks \
        wget

RUN luarocks install busted && \
    luarocks install luacov && \
    luarocks install luasrcdiet

ARG LUA_LANGUAGE_SERVER_VERSION=3.18.2
ARG TARGETOS
ARG TARGETARCH
RUN mkdir /usr/local/lua-language-server && \
    cd /usr/local/lua-language-server && \
    REAL_ARCH=$(echo ${TARGETARCH} | sed 's/^amd64/x64/') && \
    wget "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LANGUAGE_SERVER_VERSION}/lua-language-server-${LUA_LANGUAGE_SERVER_VERSION}-${TARGETOS}-${REAL_ARCH}.tar.gz" -O lua-language-server.tar.gz && \
    tar xzvf lua-language-server.tar.gz && \
    rm -f lua-language-server.tar.gz && \
    ln -s /usr/local/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server

FROM debian:trixie-slim
LABEL org.opencontainers.image.description="WoW Lua 5.1 test environment"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/shiftclack/docker-lua-wow"

COPY --chown=root --from=builder /usr/local/bin/busted /usr/local/bin/busted
COPY --chown=root --from=builder /usr/local/bin/luacov /usr/local/bin/luacov
COPY --chown=root --from=builder /usr/local/bin/luasrcdiet /usr/local/bin/luasrcdiet
COPY --chown=root --from=builder /usr/local/lib/lua/5.1 /usr/local/lib/lua/5.1
COPY --chown=root --from=builder /usr/local/lib/luarocks /usr/local/lib/luarocks
COPY --chown=root --from=builder /usr/local/share/lua/5.1 /usr/local/share/lua/5.1
COPY --chown=root --from=builder /usr/local/lua-language-server /usr/local/lua-language-server
COPY --chown=root --chmod=0755 ./wrapper.sh /usr/local/bin/lua-language-server

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        lua-check \
        lua5.1 \
        make \
        unzip \
        zip \
    && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --home-dir /lua --create-home --system --shell /bin/bash lua && \
    mkdir /usr/local/lua-language-server/log && \
    chmod 777 /usr/local/lua-language-server/log

WORKDIR /lua
ENV PATH=${PATH}:/usr/local/lua-language-server/bin

# in other dockerfiles made FROM this one, you can add `USER lua` if you like
# but note: gha writes files to nonstandard locations
USER root
