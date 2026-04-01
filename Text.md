
hide_module.c, 


hidden_pids.c, 
Hoofdstuk 1.5.1 en 1.5.2

[[bpf_hook.c]]
Hoofdstuk 1.6.3
[[eBPF]]-framework** tegenstelling met /proc/modules
extended Berkeley Packet Filter, dit is een nieuwe manier om kleine, veilige programma's binnen de linux kernel uit te voeren zonder de broncode van de kernel aan te moeten passen. Dit hooked zich aan een netwerkpakket ([[XDP]]) of systeemoproep (kprobes). Dit is anders dan een [[LKM]], die getoont worden in de /proc/modules
studenten moeten ook zoeken naar eBPF-hooks sporen wat minder eenvoudig is(`bpftool`). Ook hoe userland en kernel space overshreed wordt.

**SMEP & SMAP**
**KASLR**
Hoe zorgt de module ervoor dat de ram gevonden kan worden