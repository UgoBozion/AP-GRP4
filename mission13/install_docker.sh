echo "Mise à jour du système..."
apt update && apt upgrade -y

echo "Installation des dépendances..."
apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "Ajout du dépôt Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Mise à jour des dépôts..."
apt update

echo "Installation de Docker..."
apt install -y docker-ce docker-ce-cli containerd.io

echo "Vérification de l'installation de Docker..."
systemctl start docker
systemctl enable docker
docker --version

echo "Ajout de l'utilisateur au groupe Docker..."
usermod -aG docker $USER

echo "Installation de Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Vérification de l'installation de Docker Compose..."
docker-compose --version

echo "L'installation est terminée. Veuillez vous déconnecter et vous reconnecter ou exécuter 'newgrp docker' pour que les changements prennent effet."

