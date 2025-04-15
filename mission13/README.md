# - Installation de GLPI via Docker avec GLPI Inventory & liaison LDAP

## Étapes d'installation

```bash
apt-get update
# Installer git
apt install git

# Récupérer le script Docker
git clone https://github.com/UgoBozion/AP-GRP4

# Aller dans le dossier mission13 et lancer le script
cd AP-GRP4/mission13
chmod 777 install_docker.sh
./install_docker.sh

# À lancer à la fin de l'install
newgrp docker
```

Lien du tuto utilisé :  
https://tutos-info.fr/wp-content/uploads/2023/05/4.-TUTORIEL-INSTALLER-GLPI-10-DERRIERE-TRAEFIK-2.10-AVEC-DOCKER-COMPOSE.pdf

---

## Préparation des fichiers GLPI

Créer un dossier glpi dans l’arborescence Docker située dans /srv :

```bash
cd /srv
mkdir -p /srv/glpi
```

Déplacer le fichier `mariadb.env` dans le dossier glpi, pour moi c’était dans /root, à adapter selon l’utilisateur :

```bash
mv /root/AP-GRP4/mission13/mariadb.env /srv/glpi
```

Même chose pour le fichier `docker-compose.yml` :

```bash
mv /root/AP-GRP4/mission13/docker-compose.yml /srv/glpi
```

---

## Contenu du docker-compose.yml

```yaml
services:
  mariadb:
    image: mariadb:latest
    hostname: mariadb
    networks:
      - backend
    volumes:
      - mysql_data:/var/lib/mysql
    env_file:
      - ./mariadb.env
    restart: always
    ports:
      - "3306:3306"

  glpi:
    image: diouxx/glpi
    container_name: glpi
    hostname: glpi
    networks:
      - traefik-proxy
      - backend
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - glpi_data:/var/www/html/glpi
    environment:
      - TIMEZONE=Europe/Paris
    restart: always
    ports:
      - "80:80"

networks:
  traefik-proxy:
    driver: bridge
  backend:

volumes:
  mysql_data: {}
  glpi_data: {}
```

Lancer l’installation :

```bash
docker compose up -d
```

---

## Accès interface web

Aller sur :  
http://@ip:80

### Config GLPI

- Choisir la langue
- Suivant
- Suivant
- Installer
- Continuer

Étape 1 : configuration base de données  
- Serveur SQL : mariadb  
- Utilisateur SQL : glpi  
- Mot de passe SQL : passglpi

Étape 2 : choix base de données  
- Sélectionner base existante

Étape 3 : Installer des données  
- Continuer

Étape 4 : Récolter des données  
- Continuer peu importe le paramètre

Étape 5 : Setup GLPI  
- Suivant

Étape 6 : Fin de l’installation  
- Cliquer sur "Utiliser GLPI"

Se connecter avec :  
Login : glpi  
Password : glpi

---

## Installation de GLPI Inventory

Sur le serveur GLPI, aller dans le dossier plugin :

```bash
cd /var/lib/docker/volumes/glpi_glpi_data/_data/plugins
```

Télécharger le plugin correspondant à la version GLPI :

```bash
wget https://github.com/glpi-project/glpi-inventory-plugin/archive/refs/tags/1.5.0.tar.gz
```

Décompresser le fichier :

```bash
tar xzvf 1.5.0.tar.gz
```

Supprimer le fichier compressé :

```bash
rm -f 1.5.0.tar.gz
```

Renommer le dossier :

```bash
mv glpi-inventory-plugin-1.5.0 glpiinventory
```

Dans l’interface web GLPI :  
Aller dans Configuration > Plugins  
Cocher glpiinventory puis cliquer sur Installer  
Penser à l’activer ensuite  
Aller dans Administration > Inventaire  
Cliquer sur "Activer l'inventaire"

Ensuite il faudra installer l’agent sur la machine cliente (ici des Windows 10) :

Aller sur :  
https://github.com/glpi-project/glpi-agent/releases  
(la version 1.12 fonctionne mieux que la 1.13 dans notre cas)

Lancer le setup de l’agent, choisir "Typical" dans Setup Type.  
Dans "remote targets", mettre l’URL suivante :  
http://192.168.20.116/front/inventory.php

Suivant → Terminer

Puis sur la machine cliente, ouvrir un navigateur :  
http://localhost:62354/now  
Cliquer sur "Force an inventory"

Ensuite, dans l’interface GLPI > Parc > Ordinateurs, la machine devrait apparaître.

---

## Liaison GLPI avec LDAP

Créer un compte utilisateur dans l’AD qui sera utilisé pour faire le lien avec GLPI (exemple : glpi-ldap)

Installer l’extension PHP pour LDAP :

```bash
apt-get update
apt-get install php-ldap
```

Dans GLPI, aller dans Configuration > Authentification > Annuaire LDAP  
Cliquer sur "Ajouter", choisir "Active Directory"

Remplir les infos suivantes :

- Nom : nom de l’AD
- Serveur par défaut : oui
- Actif : oui
- Serveur : IP du serveur AD
- Port : 389
- Base DN : DC=domaine,DC=com
- Utiliser bind : oui
- DN du compte : utilisateur@domaine
- Mot de passe : mot de passe du compte AD

Exemple pour mon cas :

- Nom : LPFcliniquegpe4  
- Serveur : 192.168.110.4  
- BaseDN : DC=LPFcliniquegpe4,DC=com  
- DN du compte : glpi-ldap@lpfcliniquegpe4

Sauvegarder, puis tester la connexion LDAP

Ensuite, aller dans Administration > Utilisateurs  
Cliquer sur "Liaison annuaire LDAP"  
Choisir "Importation de nouveaux utilisateurs"  
Rechercher les utilisateurs  
Les sélectionner  
Puis dans "Action", choisir "Importer l’utilisateur"
