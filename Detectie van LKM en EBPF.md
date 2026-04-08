De standaardmanier om [[LKM]] te detecteren is door te zoeken in /proc/modules en /sys/module/. Een eenvoudige manier is om die met elkaar te vergelijken, maar dat weet de aanvaller natuurlijk ook. Een andere manier om te detecteren is een geheugenanalyse uit te voeren om het RAM te doorzoeken met een tool zoals **Volatility**. `cat /proc/sys/kernel/tainted` is ook een plek waar het soms sporen achterlaat.

**Brute-force op `/proc/`:** Tools als **unhide** proberen elk mogelijk PID (proces-ID) te benaderen via systeemoproepen zoals `kill(pid, 0)` of door direct mappen in `/proc/[PID]` te openen. Als een map bestaat maar niet in de lijst van `ps` staat, is het proces verborgen.


Nog niets gevonden om [[eBPF]] mee op te sporen.

https://redcanary.com/blog/threat-detection/ebpf-malware/