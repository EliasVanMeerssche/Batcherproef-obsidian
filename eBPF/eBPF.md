Extended Berkeley Packet Filter, dit is een nieuwe manier om kleine, veilige programma's binnen de Linux-kernel uit te voeren zonder de broncode van de kernel aan te moeten passen. Het heeft de mogelijkheid om op zowel elke interne kernelfunctie in te haken zoals [[XDP]] of systeemoproep (kprobes). Dit is anders dan een [[LKM]], die getoond worden in /proc/modules. Studenten moeten ook zoeken naar eBPF-hooksporen, wat minder eenvoudig is (`bpftool`). Ook hoe de grens tussen userland en kernel space wordt overschreden.

Het is gemaakt als een alternatief voor [[LKM]]; als je een fout schrijft, gaat de kernel in “Kernel Panic”. eBPF geeft een sandbox environment waarin wordt gecontroleerd of de code geen loops bevat of crasht.

eBPF heeft de niet de mogelijkheid om te blijven bestaan na een reboot. eBPF-programma's leven in het RAM-geheugen van de kernel, aanvallers moeten traditionele methodes gebruiken om dit in te laden na een reboot. Andere securitytools zoals Falco of Datadog gebruiken dit ook, waardoor het makkelijker verstopt zit tussen de rest. Een veelgebruikte syscall, `sys_getdents64`, kan door eBPF gebruikt worden om folders en bestanden te verstoppen. 

**De** **bpf_override_return** **helper:** Met deze functie kan een kprobe (specifiek een kretprobe) de kernel dwingen om de geretourneerde waarde van een systeemaanroep te vervalsen. Een rootkit gebruikt dit bijvoorbeeld om zichzelf onschendbaar te maken: als een gebruiker of antivirusprogramma de malware probeert te stoppen met een `kill`-commando, onderschept eBPF dit commando en retourneert het de foutmelding `ESRCH` ("Proces niet gevonden"). De gebruiker denkt dat de actie gefaald is of het proces niet bestaat, terwijl de malware gewoon blijft draaien

2026-analyzing-ebpf-rootkits-through-the-mitre-attck-framework.pdf

- https://medium.com/@instatunnel/ebpf-escapes-when-your-monitoring-tool-becomes-the-ultimate-rootkit-%EF%B8%8F-224d097e0109