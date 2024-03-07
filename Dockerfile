FROM nvcr.io/nvidia/cuda:11.4.3-cudnn8-runtime-ubuntu18.04

# software-properties-common -> python 3.8
# libsm6, libxrender-dev, libxext6, libgl1 -> opencv
# libpq-dev -> psycopg2
# libzbar0 -> pyzbar
# tzdata -> time
# locales -> en_US.UTF-8
RUN apt -y update \ 
    &&  DEBIAN_FRONTEND=noninteractive apt install -y \
        build-essential \
        cmake \
        software-properties-common \
        libsm6 \
        libxrender-dev \
        libxext6 \
        libgl1 \
        libpq-dev \
        libzbar0 \
        tzdata \
        locales \
        libksba8=1.3.5-2ubuntu0.18.04.2 \
        libssl1.1=1.1.1-1ubuntu2.1~18.04.23 \
        linux-libc-dev=4.15.0-213.224 \
        openssl=1.1.1-1ubuntu2.1~18.04.23 \
        binutils=2.30-21ubuntu1~18.04.9 \
        dpkg=1.19.0.5ubuntu2.4 \
        gnupg-l10n=2.2.4-1ubuntu1.6 \
        gnupg-utils=2.2.4-1ubuntu1.6 \
        gnupg2=2.2.4-1ubuntu1.6 \
        gpg=2.2.4-1ubuntu1.6 \
        gpg-agent=2.2.4-1ubuntu1.6 \
        gpg-wks-client=2.2.4-1ubuntu1.6 \
        gpg-wks-server=2.2.4-1ubuntu1.6 \
        gpgconf=2.2.4-1ubuntu1.6 \
        gpgsm=2.2.4-1ubuntu1.6 \
        gpgv=2.2.4-1ubuntu1.6 \
        libasn1-8-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libbinutils=2.30-21ubuntu1~18.04.9 \
        libcom-err2=1.44.1-1ubuntu1.4 \
        libdpkg-perl=1.19.0.5ubuntu2.4 \
        libext2fs2=1.44.1-1ubuntu1.4 \
        libgnutls30=3.5.18-1ubuntu1.6 \
        libgssapi3-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libhcrypto4-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libheimbase1-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libheimntlm0-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libhx509-5-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libkrb5-26-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libldap-2.4-2=2.4.45+dfsg-1ubuntu1.11 \
        libncurses5=6.1-1ubuntu1.18.04.1 \
        libncursesw5=6.1-1ubuntu1.18.04.1 \
        libperl5.26=5.26.1-6ubuntu0.7 \
        libroken18-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        libsqlite3-0=3.22.0-1ubuntu0.7 \
        libss2=1.44.1-1ubuntu1.4 \
        libsystemd0=237-3ubuntu10.57 \
        libudev1=237-3ubuntu10.57 \
        libwind0-heimdal=7.5.0+dfsg-1ubuntu0.4 \
        ncurses-base=6.1-1ubuntu1.18.04.1 \
        ncurses-bin=6.1-1ubuntu1.18.04.1 \
        perl=5.26.1-6ubuntu0.7 \
        perl-base=5.26.1-6ubuntu0.7 \
        perl-modules-5.26=5.26.1-6ubuntu0.7 \
        tar=1.29b-2ubuntu0.4 \
        bash=4.4.18-2ubuntu1.3 \
        ca-certificates=20230311ubuntu0.18.04.1 \
        libgmp10=2:6.1.2+dfsg-2ubuntu0.1 \
        libpam-modules=1.1.8-3.6ubuntu2.18.04.6 \
        libpcre3=2:8.39-9ubuntu0.1 \
        libsepol1=2.7-1ubuntu0.1 \
        libpam-runtime=1.1.8-3.6ubuntu2.18.04.6 \
        libpam0g=1.1.8-3.6ubuntu2.18.04.6


# python3.8 env
RUN yes '' | add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y python3.8-dev python3-pip
RUN rm /usr/bin/python3 && ln -s /usr/bin/python3.8 /usr/bin/python3

# nccl
RUN apt install -y wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN rm -rf /usr/bin/python3
RUN ln -s /usr/bin/python3.6 /usr/bin/python3
RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
RUN rm -rf /usr/bin/python3
RUN ln -s /usr/bin/python3.8 /usr/bin/python3
RUN apt install -y libnccl2=2.11.4-1+cuda11.4 libnccl-dev=2.11.4-1+cuda11.4

RUN pip3 install pip==21.2.1

RUN TZ=Asia/Taipei \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata 

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
