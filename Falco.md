Falco is een open-source **Host Intrusion Detection System (HIDS)** dat zélf gebruikmaakt van eBPF-technologie om besturingssystemen en cloud-native (container)omgevingen in real-time te monitoren

### eBPF
Door monitoring te doen van de bpf() systeemoproep kan falco onmiddelijk zien of deze functie gebruikt wordt. De manier om eBPF rootkits te detecteren is om het op te storen voordat het hun eige sporen begint uit te wissen.  [^1]

### LKM


### Install
```shell
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | \
sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | \
sudo tee -a /etc/apt/sources.list.d/falcosecurity.list
sudo apt-get update -y
sudo apt install -y dkms make linux-headers-$(uname -r)
sudo apt install -y clang llvm
sudo apt install -y dialog
sudo apt-get install -y falco
```
Selecteer Moderm eBPF



[^1]:Detection Frameworks and Latest Methodologies for eBPF-Based Backdoors