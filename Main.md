**[[eBPF]]-framework** in tegenstelling tot /proc/modules
Extended Berkeley Packet Filter, dit is een nieuwe manier om kleine, veilige programma's binnen de Linux-kernel uit te voeren zonder de broncode van de kernel aan te moeten passen. Het haakt in op een netwerkpakket ([[XDP]]) of systeemoproep (kprobes). Dit is anders dan een [[LKM]], die getoond worden in /proc/modules.
Studenten moeten ook zoeken naar eBPF-hooksporen, wat minder eenvoudig is (`bpftool`). Ook hoe de grens tussen userland en kernel space wordt overschreden.

**SMEP & SMAP**
**KASLR**
Hoe zorgt de module ervoor dat het RAM gevonden kan worden?


Takenlijst:
- Basis detectie eBPF
- Aan literatuur beginnen
- Kleine rootkit met LKM en eBPF maken
- Wat kan ik er allemaal mee doen met singularity?
Vandaag
- Schrijf meer over eBPF en ftrace-hooking; kun je dit uitzetten?