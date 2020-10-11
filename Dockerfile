FROM alpine:3.11

ARG ref

WORKDIR /usr/src/

RUN apk add --no-cache git build-base irrlicht-dev cmake bzip2-dev libpng-dev \
		jpeg-dev libxxf86vm-dev mesa-dev sqlite-dev libogg-dev \
		libvorbis-dev openal-soft-dev curl-dev freetype-dev zlib-dev \
		gmp-dev jsoncpp-dev postgresql-dev luajit-dev lua5.1-dev ca-certificates && \
	git clone -b ${ref} https://github.com/minetest/minetest && cd minetest && \
	git clone --depth=1 -b ${ref} https://github.com/minetest/minetest_game.git ./games/minetest_game && \
	rm -fr ./games/minetest_game/.git

WORKDIR /usr/src/
RUN git clone --recursive https://github.com/jupp0r/prometheus-cpp/ && \
	mkdir prometheus-cpp/build && \
	cd prometheus-cpp/build && \
	cmake .. \
		-DCMAKE_INSTALL_PREFIX=/usr/local \
		-DCMAKE_BUILD_TYPE=Release \
		-DENABLE_TESTING=0 && \
	make -j2 && \
	make install

WORKDIR /usr/src/minetest
RUN mkdir -p build && \
	cd build && \
	cmake .. \
		-DCMAKE_INSTALL_PREFIX=/usr/local \
		-DCMAKE_BUILD_TYPE=Release \
		-DBUILD_SERVER=TRUE \
		-DENABLE_PROMETHEUS=TRUE \
		-DBUILD_UNITTESTS=FALSE \
		-DBUILD_CLIENT=FALSE && \
	make -j2 && \
	make install

WORKDIR /usr/src/
RUN git clone https://github.com/LuaDist/lsqlite3 && \
	cd lsqlite3 && cmake . && \
	make -j2 && \
	make install

FROM alpine:3.11

RUN apk add --no-cache sqlite-libs curl gmp libstdc++ libgcc libpq luajit lua5.1 && \
	adduser -D minetest --uid 30000 -h /var/lib/minetest && \
	chown -R minetest:minetest /var/lib/minetest

WORKDIR /var/lib/minetest

COPY --from=0 /usr/local/share/minetest /usr/local/share/minetest
COPY --from=0 /usr/local/bin/minetestserver /usr/local/bin/minetestserver
COPY --from=0 /usr/local/share/doc/minetest/minetest.conf.example /etc/minetest/minetest.conf

COPY --from=0 /usr/local/lib/lua/lsqlite3.so /usr/local/lib/lua/5.1/lsqlite3.so

USER minetest:minetest

EXPOSE 30000/udp 30000/tcp

CMD ["/usr/local/bin/minetestserver", "--config", "/etc/minetest/minetest.conf"]
