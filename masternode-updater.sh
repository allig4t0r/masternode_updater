#!/bin/bash

echo Huuymas

echo Tuning .bashrc
echo -e "alias k=kubectl\nalias ll=\"ls -la\"" >> /root/.bashrc

echo HUY

echo Updating the /etc/apt/sources.list
echo -e "deb http://mirror.yandex.ru/debian sid main contrib non-free\ndeb-src http://mirror.yandex.ru/debian sid main contrib non-free" >> /etc/apt/sources.list

echo Enable br_netfilter
modprobe br_netfilter
echo br_netfilter | tee -a /etc/modules

echo Enable ip_forward
echo '1' > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

echo Updating apt
apt update
echo Upgrading apt
apt upgrade -y

echo Installing google gpg key
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo Adding k8s official repo
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

echo Updating apt
apt update
echo Upgrading apt
apt upgrade -y

echo Installing kubelet kubeadm kubectl containerd netcat
apt-get install -y kubelet kubeadm kubectl containerd netcat
echo Placing hold on some packages
apt-mark hold kubelet kubeadm kubectl

echo Reload bash
exec bash