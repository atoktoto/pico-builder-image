FROM phusion/baseimage:jammy-1.0.0
RUN apt-get update && \
    apt-get install -y python3-pip git cmake gcc-arm-none-eabi gcc g++ pkg-config gdb-multiarch automake autoconf build-essential texinfo libtool libftdi-dev libusb-1.0-0-dev libstdc++-arm-none-eabi-newlib libnewlib-arm-none-eabi minicom && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# OpenOCD
WORKDIR /pico
RUN git clone https://github.com/raspberrypi/openocd.git -b rp2040 --depth=1
WORKDIR /pico/openocd
RUN ./bootstrap
RUN ./configure --enable-ftdi --enable-sysfsgpio --enable-bcm2835gpio
RUN make -j4 && make install

# pico-sdk
WORKDIR /pico
RUN git clone https://github.com/raspberrypi/pico-sdk.git && cd pico-sdk && git submodule update --init
RUN echo "export PICO_SDK_PATH=/pico/pico-sdk" >> ~/.bashrc
ENV PICO_SDK_PATH /pico/pico-sdk

# pico-examples
RUN git clone https://github.com/raspberrypi/pico-examples.git && cd pico-examples && git submodule update --init
RUN echo "export PICO_EXAMPLES_PATH=/pico/pico-examples" >> ~/.bashrc
ENV PICO_EXAMPLES_PATH /pico/pico-examples

# pico-extras
RUN git clone https://github.com/raspberrypi/pico-extras.git && cd pico-extras && git submodule update --init
RUN echo "export PICO_EXTRAS_PATH=/pico/pico-extras" >> ~/.bashrc
ENV PICO_EXTRAS_PATH /pico/pico-extras

# pico-playground
RUN git clone https://github.com/raspberrypi/pico-playground.git && cd pico-playground && git submodule update --init
RUN echo "export PICO_PLAYGROUND_PATH=/pico/pico-playground" >> ~/.bashrc
ENV PICO_PLAYGROUND_PATH /pico/pico-playground

# picoprobe
WORKDIR /pico
RUN git clone https://github.com/raspberrypi/picoprobe.git
WORKDIR /pico/picoprobe/build
RUN cmake ../
RUN make -j4

# picotool
WORKDIR /pico
RUN git clone https://github.com/raspberrypi/picotool.git
WORKDIR /pico/picotool/build
RUN cmake ../
RUN make -j4 && make install

# Example VSCode launch.json
COPY vscode-config/launch.json /pico/pico-examples/.vscode/launch.json

# baseimage init
CMD ["/sbin/my_init"]
