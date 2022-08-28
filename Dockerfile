FROM ubuntu:latest as build
RUN apt-get update && \
    apt-get install -y python3-pip git cmake gcc-arm-none-eabi gcc g++ pkg-config gdb-multiarch automake autoconf build-essential texinfo libtool libftdi-dev libusb-1.0-0-dev

WORKDIR pico

RUN git clone https://github.com/raspberrypi/openocd.git -b rp2040 --depth=1
WORKDIR /pico/openocd
RUN ./bootstrap
RUN ./configure --enable-ftdi --enable-sysfsgpio --enable-bcm2835gpio
RUN make -j4 && make install

WORKDIR /pico
RUN git clone https://github.com/raspberrypi/pico-sdk.git && cd pico-sdk && git submodule update --init
RUN echo "export PICO_SDK_PATH=/pico/pico-sdk" >> ~/.bashrc
ENV PICO_SDK_PATH /pico/pico-sdk

WORKDIR /pico
RUN git clone https://github.com/raspberrypi/picoprobe.git
WORKDIR /pico/picoprobe/build
RUN cmake ../
RUN make -j4

WORKDIR /pico
RUN git clone https://github.com/raspberrypi/picotool.git
WORKDIR /pico/picotool/build
RUN cmake ../
RUN make -j4 && make install

FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y python3-pip git cmake gcc-arm-none-eabi gcc g++ gdb-multiarch libusb-1.0-0-dev libftdi-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR pico

COPY --from=build /usr/local/bin/openocd  /usr/local/bin/openocd
COPY --from=build /usr/local/bin/picotool /usr/local/bin/picotool

RUN git clone https://github.com/raspberrypi/pico-sdk.git && cd pico-sdk && git submodule update --init
RUN echo "export PICO_SDK_PATH=/pico/pico-sdk" >> ~/.bashrc

RUN git clone https://github.com/raspberrypi/pico-examples.git && cd pico-examples && git submodule update --init
RUN echo "export PICO_EXAMPLES_PATH=/pico/pico-examples" >> ~/.bashrc

RUN git clone https://github.com/raspberrypi/pico-extras.git && cd pico-extras && git submodule update --init
RUN echo "export PICO_EXTRAS_PATH=/pico/pico-extras" >> ~/.bashrc

RUN git clone https://github.com/raspberrypi/pico-playground.git && cd pico-playground && git submodule update --init
RUN echo "export PICO_PLAYGROUND_PATH=/pico/pico-playground" >> ~/.bashrc

COPY vscode-config/launch.json /pico/pico-examples/.vscode/launch.json
