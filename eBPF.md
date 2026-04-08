extended Berkeley Packet Filter
de C-code wordt gecompileerd naar eBPF-bytecode
Dit wordt ingeladen door de bpf() syscall  


Het is gemaakt om [[LKM]] te vervangen; als je een fout schrijft, gaat de kernel in “Kernel Panic”. eBPF geeft een sandbox environment waarin wordt gecontroleerd of de code geen loops bevat of crasht.

eBPF heeft de mogelijkheid om te blijven bestaan na een reboot. eBPF-programma's leven in het geheugen van de kernel, wat ervoor zorgt dat het moeilijk is om te detecteren. Andere securitytools zoals Falco of Datadog gebruiken dit ook, waardoor het makkelijker verstopt zit tussen de rest.
Een veelgebruikte syscall, `sys_getdents64`, kan door eBPF gebruikt worden om folders en bestanden te verstoppen. 


- https://medium.com/@instatunnel/ebpf-escapes-when-your-monitoring-tool-becomes-the-ultimate-rootkit-%EF%B8%8F-224d097e0109