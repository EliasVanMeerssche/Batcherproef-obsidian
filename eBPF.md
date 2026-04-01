extended Berkeley Packet Filter
de c code wordt gecompileerd naar eBPF-bytecode
Dit wordt ingeladen door de bpf() syscall  

https://medium.com/@instatunnel/ebpf-escapes-when-your-monitoring-tool-becomes-the-ultimate-rootkit-%EF%B8%8F-224d097e0109

Het is gemaakt om [[LKM]] te vervangen, als je een fout schrijf gaat de kernel in “Kernel Panic”. eBPF geef een sandbox envirment waar er gechecked wordt of de code geen loops bevat of crashed. 

eBPF hebben de mogelijkheid om aan te blijven acter een reboot. eBPF programs live in the kernel’s memory space wat ervoor zorgt dat het moeilijk is om te detecteren. Andere security tools zoals Falco of Datadog gebruiken dit ook, waardoor het makelijker verstopt zit tussen rest. 
Een veel gebruikt syscall sys_getdents64 kan gebruikt worden door eBPF om folders en bestanden te verstoppen. 