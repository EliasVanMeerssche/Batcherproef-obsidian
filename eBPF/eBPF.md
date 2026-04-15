Extended Berkeley Packet Filter, dit is een nieuwe manier om kleine, veilige programma's binnen de Linux-kernel uit te voeren zonder de broncode van de kernel aan te moeten passen. Het heeft de mogelijkheid om op zowel elke interne kernelfunctie in te haken zoals [[XDP]] of systeemoproep (kprobes). Dit is anders dan een [[LKM]], die getoond worden in /proc/modules. Studenten moeten ook zoeken naar eBPF-hooksporen, wat minder eenvoudig is (`bpftool`). Ook hoe de grens tussen userland en kernel space wordt overschreden.

Het is gemaakt als een alternatief voor [[LKM]]; als je een fout schrijft, gaat de kernel in “Kernel Panic”. eBPF geeft een sandbox environment waarin wordt gecontroleerd of de code geen loops bevat of crasht.

eBPF heeft de mogelijkheid om te blijven bestaan na een reboot. eBPF-programma's leven in het geheugen van de kernel, wat ervoor zorgt dat het moeilijk is om te detecteren. Andere securitytools zoals Falco of Datadog gebruiken dit ook, waardoor het makkelijker verstopt zit tussen de rest. Een veelgebruikte syscall, `sys_getdents64`, kan door eBPF gebruikt worden om folders en bestanden te verstoppen. 


- https://medium.com/@instatunnel/ebpf-escapes-when-your-monitoring-tool-becomes-the-ultimate-rootkit-%EF%B8%8F-224d097e0109