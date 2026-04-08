Deze rootkit (Singularity) misbruikt het [[ftrace]]-raamwerk om zijn [[hooks]] te plaatsen. In plaats van ftrace te gebruiken om alleen maar een logboek bij te houden, gebruikt de rootkit ftrace om de uitvoering van de code te **kapen en om te leiden**.

Dit is hoe het stap-voor-stap werkt in de code die je hebt gedeeld:

1. **Doelwit bepalen:** De rootkit zoekt het geheugenadres van een belangrijke kernel-functie op. Bijvoorbeeld de functie `sys_getdents64` (die wordt gebruikt om de inhoud van een map op te vragen als je `ls` typt).
    
2. **De Hook installeren:** De rootkit gebruikt een helper-functie (in de code te zien als `fh_install_hook()`) om ftrace te vertellen: _"Als iemand `sys_getdents64` aanroept, stuur ze dan naar MIJN kwaadaardige functie (`hook_getdents64`) in plaats van naar de echte kernel-functie."_
    
3. **De Onderschepping:** Een beheerder typt `ls` om te kijken welke processen er draaien. Het OS probeert `sys_getdents64` uit te voeren.
    
4. **De Omleiding:** Ftrace grijpt in (omdat het denkt dat er gedebugd wordt) en stuurt het verzoek door naar de rootkit.
    
5. **De Manipulatie:** De rootkit-functie voert eerst stiekem de originele functie uit (om te zien wat er écht in de map staat). Vervolgens filtert de rootkit zijn eigen kwaadaardige bestanden en processen uit die lijst.
    
6. **De Leugen:** De rootkit stuurt de gemanipuleerde (schone) lijst terug naar de gebruiker. De beheerder ziet de malware niet.