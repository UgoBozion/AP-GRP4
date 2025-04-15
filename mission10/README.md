# Mission 10 – Groupe 4

## Schéma réseau

![Schéma Réseau](Schéma%20AP%20GRP4.jpg)

---

## Switch – VLAN & Réseaux

| N° VLAN | Nom            | Adresse Réseau     | Passerelle             |
|--------:|----------------|--------------------|-------------------------|
| 9       | Internet       | 192.168.110.0/24   | 192.168.110.254/24      |
| 10      | Serveur        | 192.168.110.0/24   | 192.168.110.254/24      |
| 20      | Chirurgie      | 192.168.120.0/24   | 192.168.120.254/24      |
| 30      | Neurologie     | 192.168.130.0/24   | 192.168.130.254/24      |
| 40      | Radiologie     | 192.168.140.0/24   | 192.168.140.254/24      |
| 50      | Backup         | 192.168.150.0/30   | 192.168.150.254/30      |
| 100     | Administration | 192.168.170.0/24   | 192.168.170.254/24      |
| 500     | Patients       | 192.168.250.0/24   | 192.168.250.254/24      |
| 600     | Admin réseau   | 192.168.251.0/24   | 192.168.251.254/24      |

---

## Routeur – Interfaces & Pools DHCP

### Interfaces sous VLAN

| N° sous interface | Nom VLAN        | Adresse IPv4         |
|------------------:|------------------|-----------------------|
| Giga0/0.9         | Internet         | 192.168.1.254/24      |
| Giga0/0.10        | Serveur          | 192.168.110.254/24    |
| Giga0/0.20        | Chirurgie        | 192.168.120.254/24    |
| Giga0/0.30        | Neurologie       | 192.168.130.254/24    |
| Giga0/0.40        | Radiologie       | 192.168.140.254/24    |
| Giga0/0.50        | Backup           | 192.168.150.254/30    |
| Giga0/0.100       | Administration   | 192.168.170.254/24    |
| Giga0/0.500       | Patients         | 192.168.250.254/24    |
| Giga0/0.600       | Admin réseau     | 192.168.251.254/24    |

### Pools DHCP

| VLAN            | Pool DHCP                                 |
|----------------|---------------------------------------------|
| Chirurgie      | De 192.168.120.2 à 192.168.120.253          |
| Neurologie     | De 192.168.130.2 à 192.168.130.253          |
| Radiologie     | De 192.168.140.2 à 192.168.140.253          |
| Administration | De 192.168.170.2 à 192.168.170.253          |
| Patients       | De 192.168.250.2 à 192.168.250.253          |

---

## Services

| Nom              | Adresse IPv4       | Commentaire                              |
|------------------|--------------------|-------------------------------------------|
| Serveur web test | 192.168.20.200/24  | Serveur pré-prod sur le réseau de la salle |
| Supervision ZABBIX | 192.168.110.1/24 |                                           |
| NSA              | 192.168.110.2/24   |                                           |
| WinSrv AD        | 192.168.110.4/24   |                                           |
| GLPI             | 192.168.110.6/24   |                                           |

---

## DMZ

| Nom         | Adresse Réseau  | Adresse IP       |
|-------------|------------------|------------------|
| Serveur prod | 192.168.30.0/24 | 192.168.30.3/24  |
