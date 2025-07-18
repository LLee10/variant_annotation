FROM ubuntu:22.04

RUN apt-get -y update && apt-get install -y curl wget software-properties-common git

# Install dependencies
RUN add-apt-repository -y 'ppa:deadsnakes/ppa' && \
    apt-get update && \
    apt install -y python3.12 python3-pip

# Make python3.12 the default installation
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100
WORKDIR /root
