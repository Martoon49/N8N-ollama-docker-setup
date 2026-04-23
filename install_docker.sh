#!/bin/bash

set -e

echo "=============================="
echo "  INSTALL DOCKER DEBIAN 12"
echo "=============================="

echo "== 1. Suppression anciens paquets =="
sudo apt remove -y docker docker-engine docker.io containerd runc || true

echo "== 2. Nettoyage anciens dépôts Docker (Ubuntu cassé si présent) =="
sudo rm -f /etc/apt/sources.list.d/docker.list

echo "== 3. Mise à jour système =="
sudo apt update
sudo apt upgrade -y

echo "== 4. Installation dépendances =="
sudo apt install -y ca-certificates curl gnupg

echo "== 5. Création dossier keyrings =="
sudo install -m 0755 -d /etc/apt/keyrings

echo "== 6. Ajout clé GPG Docker =="
curl -fsSL https://download.docker.com/linux/debian/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "== 7. Ajout dépôt OFFICIEL Debian (bookworm) =="
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian bookworm stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "== 8. Mise à jour apt =="
sudo apt update

echo "== 9. Installation Docker + Compose v2 =="
sudo apt install -y docker-ce docker-ce-cli containerd.io \
docker-buildx-plugin docker-compose-plugin

echo "== 10. Activation Docker =="
sudo systemctl enable docker
sudo systemctl start docker

echo "== 11. Test Docker =="
sudo docker run hello-world

echo "== 12. Ajout utilisateur au groupe docker =="
sudo usermod -aG docker $USER

echo "=============================="
echo " INSTALLATION TERMINÉE"
echo "=============================="
echo ""
echo "⚠️ IMPORTANT : déconnecte/reconnecte ta session pour utiliser docker sans sudo"
echo ""
echo "Test :"
echo "  docker --version"
echo "  docker compose version"
echo "=============================="
