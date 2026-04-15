eXpress Data Path
Dit zijn programma's draait op het laagste punt van de netwerkstack (direct op de NIC), nog voordat de firewall of de kernel ze kunnen zien [^1]. Dit geeft de mogelijkheid om elk netwerkverkeer voor de gebruiker te verbergen. Aanvallers gebruiken dit om te luisteren naar "magic packets". Zodra een XDP-programma zo'n commando herkent, voert het de taak uit en overschrijft het pakket direct met onschuldige data (zoals een HTTP health check). Hierdoor merken het besturingssysteem en de netwerkmonitoringstools helemaal niets van de kwaadaardige communicatie[^1].. Dit kan gebruikt worden om C2 ([[Command and Control]]) Op te zetten.

[^1]:2026-analyzing-ebpf-rootkits-through-the-mitre-attck-framework.pdf
[^2]: