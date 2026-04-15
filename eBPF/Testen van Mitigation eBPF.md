```shell
sudo add-apt-repository ppa:cappelikan/ppa
sudo apt update
sudo apt install mainline
wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
chmod +x ubuntu-mainline-kernel.sh
sudo mv ubuntu-mainline-kernel.sh /usr/local/bin/mainline
mainline list | grep 5.17
sudo mainline -i 5.17.15
sudo vim /etc/default/grub
GRUB_DEFAULT="gnulinux-advanced-69d14de9-ac46-4827-b7fd-4ffb0d1bd196>gnulinux-5.17.15-051715-generic-advanced-69d14de9-ac46-4827-b7fd-4ffb0d1bd196"
sudo update-grub
sudo reboot
```
### https://github.com/krisnova/boopkit
```bash
sudo apt update sudo apt install -y git make clang llvm libelf-dev libpcap-dev \ libbpf-dev zlib1g-dev gcc-multilib libxdp-dev \ linux-tools-common linux-tools-generic linux-cloud-tools-generic
sudo ln -sf /usr/lib/linux-tools/$(uname -r)/bpftool /usr/local/bin/bpftool
wget https://github.com/kris-nova/boopkit/archive/refs/tags/v1.3.0.tar.gz
tar -xzf v1.3.0.tar.gz 
cd boopkit-1.3.0/
bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h
make
sudo make
boopkit -q &
```

