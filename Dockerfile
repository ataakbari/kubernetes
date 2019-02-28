FROM tensorflow/tensorflow:1.13.0rc0-gpu

MAINTAINER Ata Akbari Asanjan aakbaria@uci.edu

# # install everything
WORKDIR /root/

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN  apt update -y && \
 apt-get update --fix-missing && apt-get install -y wget texlive-xetex bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
 wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
 /bin/bash ~/anaconda.sh -b -p /opt/conda && \
 rm ~/anaconda.sh && \
 ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
 echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
 conda install pytorch && \
 conda install keras && \
 conda install nb_conda && \
 conda install netCDF4 && \
 apt install vim -y && \
 apt-get install nano && \
 apt install git -y && \
 apt install sudo -y && \
 apt install npm -y && \
 apt install redis-server -y && \
 apt install cdo -y && \
 pip install automat --upgrade && \
 pip install distributed --upgrade && \
 pip install ipywidgets --upgrade && \
 pip install jupyterhub --upgrade && \
 pip install notebook --upgrade  && \
 pip install oauthenticator --upgrade && \
 pip install tensorflow-gpu --upgrade --pre  && \
 pip install sklearn --upgrade && \
 pip install scikit-image --upgrade && \
 pip install tensorflow-hub --upgrade && \
 pip install seaborn --upgrade && \
 pip install matplotlib --upgrade && \
 pip install dateparser --upgrade && \
 pip install jupyterlab && \
 pip install bash_kernel && \
 pip install redis && \
 /opt/conda/bin/python -m bash_kernel.install && \
 pip install ipyvolume==0.4.5 && \
 pip install bqplot==0.10.2 && \
 pip install plotly==2.4.1 && \
 pip install ipyleaflet==0.7.1 && \
 pip install awscli && \
 npm cache clean -f && \
 npm install -g n && \
 npm install -g configurable-http-proxy  && \
 n stable && \
 npm i -g npm
