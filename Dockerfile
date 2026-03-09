FROM i386/ubuntu:16.04

# Set environment to non-interactive to avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    g++ \
    gcc \
    git \
    wget \
    libx11-dev \
    libxpm-dev \
    libxft-dev \
    libxext-dev \
    cernlib-base-dev \
    cernlib-core-dev \
    libpacklib1-dev \
    libpawlib2-dev \
    geant321 \
    libgraflib1-dev \
#    libgrafX11-1-dev \
    libkernlib1-dev \
    libmathlib2-dev \
    emacs-nox \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

# Clone DRAGON simulation
RUN git clone https://github.com/padsley/G3_DRAGON.git
WORKDIR /opt/G3_DRAGON

# Set environment variables for CERN libraries
ENV CERN=/opt/cern
ENV CERN_LEVEL=2006
ENV CERN_ROOT=$CERN/$CERN_LEVEL
ENV PATH=$CERN_ROOT/bin:$PATH
ENV LD_LIBRARY_PATH=$CERN_ROOT/lib

# Create CERN directory structure
RUN mkdir -p $CERN_ROOT

# Download and install CERNLIB (32-bit) - version 2006
RUN cd /opt && \
    wget http://cernlib.web.cern.ch/cernlib/download/2006_source/tar/2006_src.tar.gz && \
    tar -xzf 2006_src.tar.gz && \
    rm 2006_src.tar.gz

# Set up build environment for CERNLIB
WORKDIR /opt/2006/src
RUN ./Install_cernlib_and_lapack && \
    cp -r /cern/$CERN_LEVEL/* $CERN_ROOT/ || true

# Return to DRAGON directory
WORKDIR /opt/G3_DRAGON

CMD ["/bin/bash"]