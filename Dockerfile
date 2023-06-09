FROM finchsec/kali:base as builder
# hadolint ignore=DL3005,DL3008,DL3015
RUN apt-get update && \
    echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates git gcc make libc6-dev libmicrohttpd-dev \
                    pkg-config zlib1g-dev libnl-3-dev libnl-genl-3-dev libcap-dev libpcap-dev libnm-dev \
                    libdw-dev libsqlite3-dev libprotobuf-dev libprotobuf-c-dev protobuf-compiler \
                    protobuf-c-compiler libsensors4-dev python3 python3-setuptools python3-protobuf \
                    python3-usb python3-numpy python3-dev python3-pip python3-serial librtlsdr0 \
                    libusb-1.0-0-dev rtl-433 libssl-dev libwebsockets-dev libbtbb-dev libubertooth-dev \
                    libbladerf-dev g++ libprelude-dev
RUN git clone https://github.com/kismetwireless/kismet
WORKDIR /kismet
# hadolint ignore=SC2046
RUN ./configure --enable-bladerf --enable-btgeiger --enable-prelude && \
    make -j $(nproc) && \
    make suidinstall DESTDIR=/kismet-bin && \
    make forceconfigs DESTDIR=/kismet-bin
WORKDIR /kismet-bin
RUN tar -czf ../kismet.tar.gz ./*

FROM finchsec/kali:base
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends libc6 libmicrohttpd12 zlib1g libnl-3-200 libnl-genl-3-200 \
                    libpcap0.8 libcap2 libnm0 libdw1 libsqlite3-0 libprotobuf-c1 libsensors5 python3 \
                    python3-setuptools python3-protobuf libwebsockets17 python3-usb python3-numpy \
                    python3-pip python3-serial librtlsdr0 libusb-1.0-0 rtl-433 openssl libubertooth1 \
                    libbtbb1 libbladerf2 bladerf libpreludecpp12 man-db && \
    apt-get autoclean && \
    rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*
COPY --from=builder /kismet.tar.gz /
RUN tar -zxf kismet.tar.gz && \
    rm kismet.tar.gz
EXPOSE 2501
EXPOSE 3501
CMD ["/usr/local/bin/kismet", "--no-ncurses-wrapper"]