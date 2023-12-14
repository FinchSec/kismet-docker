FROM debian:unstable as builder
# hadolint ignore=DL3005,DL3008,DL3015,SC2046
RUN apt-get update && \
    echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates git gcc make libc6-dev libmicrohttpd-dev \
                    pkg-config zlib1g-dev libnl-3-dev libnl-genl-3-dev libcap-dev libpcap-dev libnm-dev \
                    libdw-dev libsqlite3-dev libprotobuf-dev libprotobuf-c-dev protobuf-compiler librtlsdr-dev \
                    protobuf-c-compiler libsensors-dev python3 python3-setuptools python3-protobuf \
                    python3-usb python3-numpy python3-dev python3-pip python3-serial librtlsdr2 libmosquitto-dev \
                    libusb-1.0-0-dev rtl-433 libssl-dev libwebsockets-dev libbtbb-dev g++ libprelude-dev \
                    $([ "$(dpkg --print-architecture)" != "riscv64" ] && echo libubertooth-dev) libbladerf-dev
RUN git clone https://github.com/kismetwireless/kismet
WORKDIR /kismet
# hadolint ignore=SC2046
RUN ./configure $([ "$(dpkg --print-architecture)" != "riscv64" ] && echo --enable-bladerf) --enable-btgeiger --enable-prelude && \
    make -j $(nproc) && \
    make suidinstall DESTDIR=/kismet-bin && \
    make forceconfigs DESTDIR=/kismet-bin
WORKDIR /kismet-bin
RUN tar -czf ../kismet.tar.gz ./*

FROM debian:unstable-slim
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
# hadolint ignore=DL3005,DL3008,SC2046
RUN apt-get update && \
    echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends libc6 libmicrohttpd12 zlib1g libnl-3-200 libnl-genl-3-200 \
                    libpcap0.8 libcap2 libnm0 libdw1 libsqlite3-0 libprotobuf-c1 libsensors5 python3 man-db \
                    python3-setuptools python3-protobuf libwebsockets19 python3-usb python3-numpy libbtbb1 \
                    python3-pip python3-serial librtlsdr2 libusb-1.0-0 rtl-433 openssl libpreludecpp12 libmosquitto1 \
                    $([ "$(dpkg --print-architecture)" != "riscv64" ] && echo libubertooth1 ) libbladerf2 bladerf && \
    apt-get autoclean && \
    rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*
COPY --from=builder /kismet.tar.gz /
RUN tar -zxf kismet.tar.gz && \
    rm kismet.tar.gz
# Workaround so that kismet can load librtlsdr2
RUN ln -s /usr/lib/x86_64-linux-gnu/librtlsdr.so.2 /usr/lib/x86_64-linux-gnu/librtlsdr.so.0
EXPOSE 2501
EXPOSE 3501
CMD ["/usr/local/bin/kismet", "--no-ncurses-wrapper"]