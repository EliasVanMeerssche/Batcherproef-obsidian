Standaard manier om [[LKM]] te detecteren is op zoek te gaan in /proc/modules en /sys/module/. Een eenvoudige manier is het vergeleken met elkaar, maar dit weet de aanvaller wel. Andere manier om te detecteren is een geheugenanalyse te doen om de ram met een tool zoals **Volatility**. cat /proc/sys/kernel/tainted is ook een plek waar het soms sporen achterlaat. 

**Brute-force op `/proc/`:** Tools als **unhide** proberen elk mogelijk PID (proces-ID) te benaderen via systeemoproepen zoals `kill(pid, 0)` of door direct mappen in `/proc/[PID]` te openen. Als een map bestaat maar niet in de lijst van `ps` staat, is het proces verborgen.


Nog niets gevonden om [[eBPF]] op te sporen