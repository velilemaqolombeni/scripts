sudo -i
apt update
apt -y purge docker.io;apt -y autoremove docker.io
apt -y install docker.io
systemctl start docker
systemctl enable docker
docker --version

usermod -a -G docker $USER
newgrp docker


apt -y install curl

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

apt update
apt -y install nvidia-container-toolkit
systemctl restart docker

docker run nvidia/cuda:11.0.3-base-ubuntu20.04
sleep 2
