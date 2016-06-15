Introductie
-----------
Zolang Albelli haar klanten niet de mogelijkheid biedt om hun werk
te backuppen op een Albelli onafhankelijke manier, zoals een PDF,
zullen we hier plezier hebben met het ontfutselen van die backup.

Technische achtergrond
----------------------
De Albelli software maakt tijdens het bestelprocess een PDF bestand om deze
vervolgens in een versleuteld zip bestand naar hun website te uploaden.

Het doel van dit programma is om voor het PDF bestand tijdens dit bestelprocess er tussenuit te halen.

Historie
--------
Het eerste script staat gepubliceerd in [een blog post](http://bneijt.nl/blog/post/albelli-fotoboeken-als-pdf/).

Versie 10.0.0.1189 introduceerde twee technische rariteiten die de werking
tegen ging:

 - Een exclusive file lock
 - Een enkele byte XOR versleuteling van de tijdelijke PDF

De eerste is technische onzin omdat het om een tijdelijk bestand gaat
in een random directory gemaakt door het Albelli programma zelf.

De XOR versleuteling is technisch onzinnig omdat het geen enkele vorm van bescherming biedt
en dus niets anders is dan een onzinnige verdoezeling die bij programmeer lessen van de middelbare school hoort.

De read lock is het makkelijkst op te lossen door Albelli halverwegen het bestelprocess geforceerd af te sluiten. De versleuteling is kinderachtig en ook makkelijk op te lossen (maar niet in een BATCH script).


