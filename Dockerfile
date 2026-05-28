FROM ubuntu:24.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && \
    apt-get -y install sudo \
                       python3 \
                       tar \
                       wget \
                       curl
ADD . /build_tools
WORKDIR /build_tools
ARG BRANCH=master
ARG MODULE=server
ENV MODULE=${MODULE}
ENV BRANCH=${BRANCH}

CMD ["sh", "-c", "cd tools/linux && python3 ./automate.py ${MODULE} --clean=\"0\" --sysroot=\"0\" --update=\"1\" --update-light=\"1\" --branch=\"${BRANCH}\""]
