Loadable kernel module
`insmod`

Een **Linux Kernel Module (LKM)** is software, zoals een driver of een rootkit, die op hetzelfde bevoegdheidsniveau draait als het besturingssysteem en daardoor onbeperkte toegang heeft tot alle systeembronnen. Zodra een LKM is geladen, maakt deze direct deel uit van de kernel.

Het grootste risico van een LKM is dat het zeer gemakkelijk kan leiden tot een systeemcrash. Omdat een LKM direct in de kernel draait, kan een simpele programmeerfout het geheugen van de kernel of de gebruiker corrumperen. Dit resulteert in een fatale fout die een _kernel panic_ wordt genoemd, wat het hele besturingssysteem laat vastlopen en een herstart vereist. Bovendien is een LKM erg gevoelig voor compatibiliteitsproblemen; zelfs kleine verschillen tussen kernelversies kunnen al een kernel panic veroorzaken, waardoor de module vaak exact moet worden aangepast voor de specifieke kernel waarop deze draait

ebpf_offensive_rootkit_tfg.pdf