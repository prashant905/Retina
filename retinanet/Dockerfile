FROM tensorflow/tensorflow:latest-gpu

WORKDIR /notebooks

RUN apt-get update && apt-get install -y \ 
    pkg-config \
    python-dev \ 
    python-opencv \ 
    libopencv-dev \ 
    libav-tools  \ 
    libjpeg-dev \ 
    libpng-dev \ 
    libtiff-dev \ 
    libjasper-dev \ 
    python-numpy \ 
    python-pycurl \ 
    python-opencv \
    python-pip \
    build-essential \
    git

RUN pip install keras
    
    
