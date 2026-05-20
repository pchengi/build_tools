FROM ubuntu:24.04

ENV TZ=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo 'keyboard-configuration keyboard-configuration/layoutcode string us' | debconf-set-selections && \
    echo 'keyboard-configuration keyboard-configuration/modelcode string pc105' | debconf-set-selections

RUN apt-get -y update && \
    apt-get -y install sudo \
                       git \
                       git-lfs \
                       curl \
                       wget \
                       p7zip-full \
                       python-is-python3 \
                       debhelper \
                       pkg-config

WORKDIR /mnt
ADD . build_tools
WORKDIR build_tools
# Install local Python
RUN cd tools/linux && \
    ./python.sh

# Fetch Qt binaries
RUN cd tools/linux && \
    ./python3/bin/python3 ./qt_binary_fetch.py amd64

# Install system dependencies
RUN cd tools/linux && \
    ./python3/bin/python3 ./deps.py

# Install CMake
RUN cd tools/linux && \
    ./cmake.sh

# Fetch sysroot
RUN cd tools/linux/sysroot && \
    ../python3/bin/python3 ./fetch.py amd64


# Fetch sysroot
ARG BRANCH=master
ENV BRANCH=${BRANCH}
WORKDIR /mnt/build_tools/tools/linux

CMD ["sh", "-c", "./python3/bin/python3  ../../configure.py --clean \"0\" --sysroot \"1\" --update \"1\" --update-light \"1\" --module \"server\" --branch \"${BRANCH}\" && ./python3/bin/python3 ../../make.py"]
