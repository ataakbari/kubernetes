FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

LABEL maintainer="Ata Akbari Asanjan <aakbaria@uci.edu>"

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=ata \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod +x /usr/local/bin/fix-permissions

ENV DEBIAN_FRONTEND noninteractive
RUN set -x \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        redis-tools \
        netcat \
        net-tools \
        openssh-client \
        openconnect \
        openvpn \
        wget \
        bzip2 \
        ca-certificates \
        sudo \
        locales \
        fonts-liberation \
        build-essential \
        emacs \
        git \
        inkscape \
        jed \
        libsm6 \
        libxext-dev \
        libxrender1 \
        lmodern \
        pandoc \
        python-dev \      
        vim \
        curl \
        wget \
        unzip \
        software-properties-common \
    && add-apt-repository ppa:nextgis/dev -y \
    && apt-get update -y \
    && apt-get install -y gdal-bin libgdal-dev python3-gdal \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://blink.ucsd.edu/_files/technology-tab/network/vpn_install-4.6.01098.sh \
    && wget https://downloads.rclone.org/rclone-current-linux-amd64.deb -O /tmp/rclone-current-linux-amd64.deb \
    && apt install /tmp/rclone-current-linux-amd64.deb \
    && rm -f /tmp/rclone-current-linux-amd64.deb

RUN set -x \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

RUN set -x \
    && wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini \
    && echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - \
    && mv tini /usr/local/bin/tini \
    && chmod +x /usr/local/bin/tini

RUN set -x \
    && useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
    && mkdir -p $CONDA_DIR \
    && chown $NB_USER:$NB_GID $CONDA_DIR \
    && fix-permissions $HOME \
    && fix-permissions $CONDA_DIR

USER $NB_USER

RUN set -x \
    && mkdir /home/$NB_USER/work \
    && fix-permissions /home/$NB_USER

ENV MINICONDA_VERSION 4.5.11
RUN set -x \
    && cd /tmp \
    && wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && echo "e1045ee415162f944b6aebfe560b8fee *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - \
    && /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR \
    && rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && $CONDA_DIR/bin/conda config --system --prepend channels conda-forge \
    && $CONDA_DIR/bin/conda config --system --set auto_update_conda false \
    && $CONDA_DIR/bin/conda config --system --set show_channel_urls true \
    && $CONDA_DIR/bin/conda update --all --quiet --yes \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

RUN set -x \
    &&conda install --quiet --yes \
        'notebook=5.7.*' \
        'jupyterhub=0.9.*' \
        'jupyterlab=0.35.*' \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

RUN set -x \
    && conda install --quiet --yes -c pytorch  \
        'nomkl' \
        'ipywidgets=7.4*' \
        'pandas=0.23*' \
        'numexpr=2.6*' \
        'matplotlib=2.2*' \
        'scipy=1.1*' \
        'seaborn=0.9*' \
        'scikit-learn=0.19*' \
        'scikit-image=0.14*' \
        'sympy=1.2*' \
        'cython=0.28*' \
        'patsy=0.5*' \
        'statsmodels=0.9*' \
        'cloudpickle=0.5*' \
        'dill=0.2*' \
        'numba=0.39*' \
        'bokeh=0.13*' \
        'sqlalchemy=1.2*' \
        'hdf5=1.10.2' \
        'h5py=2.8*' \
        'vincent=0.4.*' \
        'beautifulsoup4=4.6.*' \
        'protobuf=3.*' \
        'jupyter_contrib_nbextensions' \
        'xlrd' \
        'astropy' \
        'numpy' \
        'r-irkernel' \
    && conda remove --quiet --yes --force qt pyqt \
    && conda clean -tipsy \
    && pip install \
        argparse \
        imutils \
        keras==2.2.4 \
        nbgitpuller \
        opencv-python \
        requests \
        tensorflow-gpu==1.13.1 \
        torch \
        torchvision \
        visualdl==0.0.2 \
        tqdm \
        click \
        pygdal \
        git+https://github.com/veeresht/CommPy.git \
        tensorflow-probability-gpu \
        bash_kernel \
        matlab_kernel \

    && python -m bash_kernel.install \
    && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    && jupyter labextension install @jupyterlab/hub-extension \
    && jupyter serverextension enable --py nbgitpuller --sys-prefix \
    && fix-permissions $CONDA_DIR
