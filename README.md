Met de nieuwe versie van Albelli is er een overstap gemaakt
van het versleutelen van de bestanden om zo zoveel mogelijk
het behouden van een PDF voor eigen doeleinden tegen te gaan.

Omdat Albelli de klant geen mogelijkheid geeft om een handige
backup te maken die niet afhankelijk is van hun software
is dit stukje software gemaakt om een PDF uit het bestelprocess
te grijpen.

Technische achtergrond
----------------------
De PDF wordt tijdelijk opgeslagen als `ORDER.$$$` en met een simpel
XOR met een enkele byte ge-encrypt. Deze encryptie is door de standaard
PDF header makkelijk ongedaan te maken (het bestand begint immers met `%PDF`).

Tevens gebruikt Albelli een exclusive read lock op het bestand om te zorgen dan andere processen en scripts niet bij het bestand kunnen komen.

Daarom is het tegenwoordig van belang om het Albelli process
halverwegen het bestellen geforceerd te beeindigen.

Allemaal erg kinderachtig en jammer, maar het is niet anders.

00100101  00101011 = 00001110  
01010000  01011110 = 00001110
01000100  01001010 = 00001110
01000110  01001000 = .......0


xor 14 decimal
