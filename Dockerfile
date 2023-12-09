
FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

RUN apt update && \
	apt install -y git wget python3-dev 

RUN wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py


RUN pip3 install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip3 install torch-scatter -f https://data.pyg.org/whl/torch-1.12.1+cu113.html
RUN pip3 install 'git+https://github.com/facebookresearch/detectron2.git@710e7795d0eeadf9def0e7ef957eea13532e34cf' --no-deps


RUN git clone "https://github.com/ewfuentes/Mask3D.git"
WORKDIR /Mask3D/third_party

RUN apt install -y ninja-build libblas-dev libopenblas-dev
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 6.2 7.0 7.2 7.5 8.0 8.6"
RUN git clone --recursive "https://github.com/NVIDIA/MinkowskiEngine"
WORKDIR /Mask3D/third_party/MinkowskiEngine 
RUN git checkout 02fc608bea4c0549b0a7b00ca1bf15dee4a0b228
RUN pip3 install -C force_cuda=True -C blas=openblas .

WORKDIR /Mask3D/third_party
RUN git clone https://github.com/ScanNet/ScanNet.git
WORKDIR /Mask3D/third_party/ScanNet/Segmentator
RUN git checkout 3e5726500896748521a6ceb81271b0f5b2c0e7d2
RUN make

WORKDIR /Mask3D/third_party/pointnet2
RUN pip install . 

WORKDIR /Mask3D/checkpoints
RUN wget https://omnomnom.vision.rwth-aachen.de/data/mask3d/checkpoints/scannet/scannet_benchmark.ckpt
WORKDIR /Mask3D
RUN pip3 install -e .
WORKDIR /host/final_project
RUN pip3 install hydra-core==1.0.5 loguru==0.6.0 albumentations==1.2.1 open3d==0.17.0
RUN apt install -y libgl1-mesa-glx

# RUN pip3 install pytorch-lightning==1.7.2
