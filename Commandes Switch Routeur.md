# Configuration Switch et Routeur

## Configuration switch :

```bash
username [name] secret [mdp] 
```

## Configurer accès Telnet :

```bash
line vty 0 4
login local 
enable secret [mdp]
```

## Création VLAN et attribution :

```bash
enable
conf t 
vlan [numéro vlan]
name [nom]
exit 
interface [nominterface]
switchport mode access 
switchport access vlan [numéro vlan]
no shutdown
end
```

## Supprimer un VLAN :

```bash
no vlan [numéro vlan]
```

## Sauvegarde de la configuration

Les fichiers de configuration sont stockés dans le dossier `/srv/tftp` du serveur TFTP.

### Sauvegarder la configuration du switch :

```bash
copy running-config tftp
Address or name of remote host []? 192.168.251.100
Destination filename []? sw1grp4-confg
```

### Restaurer la configuration du switch :

```bash
copy tftp: running-config 
Address or name of remote host []? 192.168.251.100
Source filename []? sw1grp4-confg
Destination filename []? running-config
```

> Même procédure pour le routeur.

## Passer un port du switch en mode trunk :

```bash
interface [nominterface]
switchport mode trunk 
```

## Attribuer une IP à une interface VLAN :

```bash
interface vlan [numero]
ip address [adresse] [masque]
```

## Configuration routeur :

### Activer l’interface physique :

```bash
interface gigabitethernet 0/0
no shutdown
```

### Configurer une sous-interface pour le routage inter-VLAN :

```bash
interface gigabitethernet 0/0.[sousinterface]
encapsulation dot1q [numero VLAN]
ip address [IP] [masque]
no shutdown
```
