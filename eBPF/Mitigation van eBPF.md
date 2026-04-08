1. Hardening
De eerste stap die genomen moet worden is uitzetten dat `unprivileged` gebruikt kan gemaakt worden van bpf. Het commando hiervoor is `kernel.unprivileged_bpf_disabled = 1.`[^1] Om eBPF volledig uit te zetten, moet je het besturingssysteem opnieuw compileren en configuratie-opties zoals `CONFIG_BPF` en alle gerelateerde flags (zoals `CONFIG_BPF_SYSCALL` of `CONFIG_NET_ACT_BPF`) uit te schakelen .[^2]
**Granulaire rechten:** Vervang de brede bevoegdheid `CAP_SYS_ADMIN` door meer specifieke privileges zoals `CAP_BPF` (voor het inladen van code), `CAP_NET_ADMIN` (voor netwerkgerelateerde hooks) en `CAP_PERFMON` (voor tracepoints) om misbruik bij een gedeeltelijk gecompromitteerd systeem te beperken[^3]

2. Monitoring tools
Gebruik open-source tools zoals **Tracee** of **Falco**,,. [[Falco]] kan verdacht gebruik van de `bpf()` systeemaanroep[^2]

3. **Integriteitscontroles en actieve verdediging**
**Linux Kernel Runtime Guard ([LKRG])**

4. Geheugenforensisch onderzoek
Het is mogelijk dat de rootkit zichtzelf verstopt waardoor systemen die voor de detectie moeten zorgen gesaboteerd zijn. Door een betrouwbare momentopname (snapshot) van het RAM-geheugen te maken via een hypervisor omzeil je dit probleem. Tools zoals [[Volatility framework]] kunnen offline analyses maken van het RAM-geheugen. [^2][^4]

[^1]: [[eBPF]] Escapes: When Your Monitoring Tool Becomes the Ultimate Rootkit
[^2]: Detection Frameworks and Latest Methodologies for eBPF-Based Backdoors
[^3]: Analyzing eBPF Rootkits through the MITRE ATT&CK Framework
[^4]:  Detecting eBPF Rootkits Using Virtualization and Memory Forensics

https://redcanary.com/blog/threat-detection/ebpf-malware/