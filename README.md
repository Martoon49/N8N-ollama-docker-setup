Tutoriel Complet pour la Mise en Œuvre de la Solution avec Docker Compose et n8n

Introduction :

Ce tutoriel vous guidera à travers les étapes nécessaires pour configurer un serveur n8n avec Docker Compose et un serveur Ollama. Nous aborderons l'installation et la configuration du serveur Ubuntu, l'installation de Docker et Docker Compose, la configuration de Docker Compose pour n8n, et l'installation et la configuration d'Ollama.

Prérequis : Installation et Configuration du Serveur Ubuntu
Étape 1 : Configuration Initiale

Choisir la langue : Sélectionnez la langue souhaitée pour l'installation.

Configurer les paramètres réseau IPv4 :
- Adresse IP
- Masque de sous-réseau
- Passerelle
- Serveurs DNS
- Domaines de recherche

Configurer le stockage :
- Utilisez tout le disque.
- Configurez un groupe LVM.

Redémarrez le serveur après l'installation.

Étape 2 : Connexion et Mise à Jour
- Connectez-vous au serveur via SSH.
- Mettez à jour la liste des paquets et mettez à niveau les paquets installés :
sudo apt-get update
sudo apt-get upgrade

- Notez le nom du serveur, le nom d'utilisateur et le mot de passe choisis lors de l'installation.


Installation de Docker et Docker Compose
Étape 1 : Téléchargement et Exécution du Script d'Installation

Créez un fichier script pour installer Docker et Docker Compose. Copiez le texte suivant dans un fichier nommé install_docker.sh :

{ Consultez le repo install_docker.sh }

Rendez-vous dans le répertoire où le fichier a été enregistré et lancez-le avec la commande :
bash install_docker.sh


Configuration de Docker Compose pour n8n
Étape 1 : Création des Répertoires et Fichiers de Configuration

- Créez un dossier pour stocker les fichiers de configuration :

sudo mkdir /etc/docker/n8n-compose
cd /etc/docker/n8n-compose

- Créez un fichier d'environnement test.env et ajoutez les variables nécessaires :
sudo nano test.env

Ajoutez les variables suivantes :

DOMAIN_NAME=example.com
SUBDOMAIN=n8n
GENERIC_TIMEZONE=Europe/Paris
SSL_EMAIL=user@example.com

- Créez un dossier local-files pour partager des informations entre n8n et l'hôte :
sudo mkdir local-files

- Créez le fichier docker-compose.yml avec la configuration/code fournie :
{ Consultez le repo docker-compose.yml }

Étape 2 : Démarrer et Gérer n8n avec Docker Compose
- Pour démarrer les services définis dans le fichier docker-compose.yml en mode détaché (en arrière-plan), utilisez la commande :
sudo docker compose up -d

- Pour arrêter les services :
sudo docker compose stop

- Pour mettre à jour n8n lorsqu'une nouvelle version est disponible, suivez ces étapes :
sudo docker compose pull

sudo docker compose down

sudo docker compose up -d

Accédez à n8n via l'adresse configurée dans Traefik (par exemple, https://n8n.example.com).
- Installation et Configuration d'Ollama

Étape 1 : Lancement d'Ollama
-Lancez Ollama sur le serveur avec la commande :
sudo OLLAMA_HOST=YOUR_SERVER_IP:YOUR_SERVER_PORT ollama serve

Étape 2 : Configuration du Service Ollama
- Modifiez le fichier de service ollama.service pour que Ollama se lance automatiquement au démarrage du serveur :
cd /etc/systemd/system
sudo nano ollama.service

Ajoutez ou modifiez la ligne Environment pour spécifier l'hôte et le port d'écoute :
[Unit]
Description=Ollama Service
After=network.target

[Service]
Environment="OLLAMA_HOST=YOUR_SERVER_IP:YOUR_SERVER_PORT"
ExecStart=/usr/bin/ollama serve
Restart=always
User=root

[Install]
WantedBy=multi-user.target

- Rechargez la configuration systemd, activez le service Ollama pour qu'il démarre au boot, démarrez-le et vérifiez son état :
sudo systemctl daemon-reload
sudo systemctl enable ollama.service
sudo systemctl start ollama.service
sudo systemctl status ollama.service

Étape 3 : Utilisation d'Ollama
- Pour télécharger un modèle :
ollama pull llama3.2

- Pour lancer un modèle spécifique et interagir avec lui via le terminal :
ollama run llama3.2

- Pour communiquer avec Ollama via son API :
curl http://YOUR_SERVER_IP:YOUR_SERVER_PORT/api/generate -d '{ "model": "llama3.2", "prompt": "How are you today?"}'

Exemples d'Applications avec n8n et Ollama/Autres Services
- Intégration Gmail (Création de Brouillons)
- Configurer un workflow pour recevoir des messages (trigger "When chat message received").
- Relier à un Agent IA qui agit comme un "transmetteur" entre le modèle IA et les outils.
- Connecter l'Agent IA à un modèle IA (par exemple, Mistral Cloud Chat Model) et à une mémoire simple pour se souvenir des interactions précédentes.

Ajouter un outil Gmail à l'Agent IA.
- Configurer le noeud Gmail pour "créer un brouillon" (Resource: Draft, Operation: Create).
- Configurer les options comme "ID du fil" et "Envoyer un e-mail", potentiellement définies automatiquement par le modèle.

- Pour connecter Gmail, créez des identifiants OAuth 2.0 dans Google Cloud Platform, activez l'API Gmail, créez un projet, un ID client OAuth pour une application web en utilisant une URL de redirection fournie par n8n.
- Donnez un prompt à l'Agent IA via l'option "message système" pour lui indiquer comment gérer la création de brouillons en réponse aux messages.

Intégration PostgreSQL (Magasin Vectoriel)
- Configurer un workflow pour stocker des documents dans une base de données vectorielle PostgreSQL.
- Commencez par un "chat trigger" configuré pour autoriser les téléchargements de fichiers.
- Connectez ce trigger à un connecteur "Boutique Postgres PGVector" avec l'action "ajout des documents au magasin vectoriel".
- Reliez l'entrée "Embeddings" de ce connecteur à un modèle IA (par exemple, Embeddings Mistral Cloud).
- Reliez l'entrée "Document" à un "chargeur de données par défaut" lui-même connecté à un "Séparateur de texte de caractères récursifs".
- Connectez l'outil Postgres au compte PostgreSQL et configurez-le pour "insérer des documents" dans une collection.

Intégration Qdrant (Magasin Vectoriel)
- Configurer un workflow utilisant Qdrant comme magasin vectoriel.
- Utilisez un Agent IA connecté à un modèle IA (par exemple, Ollama Chat Model), une mémoire simple, et un outil "Qdrant Vector Store".
- Connectez le "Qdrant Vector Store" à un modèle IA pour générer les embeddings (par exemple, Embeddings Ollama).
- Connectez les credentials pour Ollama et Qdrant.
- Accédez au tableau de bord Qdrant via une URL spécifique (par exemple, http://n8n.domain.lan:6333/dashboard).
- Donnez un prompt à l'Agent IA décrivant son rôle dans la gestion des vecteurs d'embeddings via Qdrant, incluant la génération, le stockage, la recherche de similarité et l'utilisation des résultats.
- Configurez le trigger "chat message received" pour autoriser les téléchargements de fichiers pour pouvoir demander des informations sur un fichier fourni.

Intégration Google Drive (MCP Client/Server)
Utilisez deux workflows pour cette intégration.

Premier workflow :
- Configurer un "chat trigger" (configuré pour la mémoire et les téléchargements de fichiers).
- Ajouter une mémoire simple.
- Ajouter un Agent IA avec un prompt spécifique pour exécuter des commandes Google Drive via le MCP Client.
- Ajouter un modèle IA (par exemple, Ollama Chat Model).
- Ajouter un "MCP Client".

Deuxième workflow :
- Configurer un "MCP Server Trigger" qui reçoit les données du MCP Client.
- Connectez ce trigger aux outils Google Drive (create folder, move file, delete file, search file/folder).
- Configurer les outils Google Drive dans ce workflow récepteur en utilisant des expressions pour récupérer des informations (comme le nom du dossier ou l'ID du parent) envoyées par l'Agent IA via le MCP Client.
- Configurer le MCP Client du premier workflow avec l'URL du MCP Server Trigger du second workflow, en remplaçant localhost par 127.0.0.1.

- Conclusion
Ce tutoriel vous a guidé à travers les étapes nécessaires pour configurer un serveur n8n avec Docker Compose et un serveur Olama. Vous devriez maintenant être en mesure de mettre en œuvre et de gérer ces services sur votre serveur Ubuntu.
