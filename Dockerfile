ARG ref

FROM registry.gitlab.com/minetest/minetest/server:${ref}

USER root

RUN apk add --no-cache lua5.1

COPY lsqlite3.so /usr/local/lib/lua/5.1/lsqlite3.so

USER minetest:minetest
