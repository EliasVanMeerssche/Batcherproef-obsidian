De kernel heeft een specifieke macro genaamd **`notrace`**. Als een kernelontwikkelaar dit woord voor een functie zet, vertelt dit de compiler dat deze specifieke functie absoluut niet door ftrace gevolgd (getraced) mag worden.
Het is niet mogelijk om functies zoals `sys_getdents64` notrace te maken, omdat grote bedrijven die gebruiken om hun eigen systemen te monitoren.
