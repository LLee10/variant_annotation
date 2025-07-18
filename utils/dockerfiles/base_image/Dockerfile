FROM ubuntu:22.04

LABEL base.image="annotate_base:v.0.0.1"

RUN apt-get -y update && apt-get install -y curl wget software-properties-common git

# Install dependencies
RUN add-apt-repository -y 'ppa:deadsnakes/ppa' && \
    apt-get update && \
    apt install -y python3.12 python3-pip

# Make python3.12 the default installation
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100
WORKDIR /root

# Add bcftools for indexing vcf
RUN wget https://github.com/samtools/bcftools/releases/download/$BCFTOOLS_VERSION/bcftools-$BCFTOOLS_VERSION.tar.bz2 && \
  tar --bzip2 -xf bcftools-$BCFTOOLS_VERSION.tar.bz2 && \
  make && make install

ENV PATH=/opt/bcftools_install/bin:$PATH

WORKDIR /root
