# Mise en place d’un serveur LAMP + FTP (pré-prod devs)

## Installation du serveur

### 1. Installation de LAMP  
Se référer à la doc suivante pour l'installation du stack LAMP (Linux, Apache, MySQL, PHP) : [TP Serveurs - BOZION Ugo (PDF)](https://ugobozion.github.io/assets/productions/B2/TP%20Serveurs%20BOZION%20Ugo.pdf)

### 2. Installation et configuration du serveur FTP (vsftpd)  
Installation de vsftpd et configuration du pare-feu :  
`apt install vsftpd`  
`systemctl start vsftpd`  
`systemctl enable vsftpd`  
`apt install ufw` (si ce n’est pas déjà fait)  
`ufw allow 21`  

Modification de la configuration du FTP :  
`nano /etc/vsftpd.conf`  
À modifier dans le fichier :  
`anonymous_enable=NO` → désactive les connexions anonymes  
`local_enable=YES` → autorise les utilisateurs locaux  
`write_enable=YES` → autorise les utilisateurs à écrire/modifier  
`pam_service_name=vsftpd` → pour l’authentification avec PAM standard  

### 3. Création du groupe développeurs et ajout des utilisateurs  
Création d’un groupe dédié :  
`groupadd -g 1003 developpeurs`  
Ajout des utilisateurs au groupe :  
`usermod -aG developpeurs jessy`  
`usermod -aG developpeurs sarah`  

### 4. Définir le dossier racine FTP pour les utilisateurs  
Modifier le fichier `/etc/passwd` pour que les utilisateurs soient redirigés vers `/var/www` à la connexion FTP. Exemple :  
`sarah:x:1002:1003:/var/www:/bin/sh`  
`jessy:x:1001:1003:/var/www:/bin/sh`  

