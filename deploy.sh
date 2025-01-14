#!/bin/bash

# Verifie les dependances
checker() {
if ! command -v $1 &> /dev/null;
then
	echo "Erreur : $1 n'est pas installe sur ce system."
	echo "Veuillez installer $1 avant de continuer."
	echo "Pour installer $1 :"
	case $1 in 
		docker)
			;;
		kubectl)
			;;
		minikube)
			;;
	esac
	exit 1
fi

}

echo "verification des dependances ..."
checker docker
checker kubectl
checker minikube
echo "Toutes les dependances sont installees ..."

# Verification de l'etat du minikube
echo "verification de l'etat du minikube ..."
if ! minikube status &> /dev/null;
then
	echo "Minikube n'est pas demarrer. Demarrage de Minikube ..."
	minikube start
else
	echo "Minikube est deja demarrer."
fi

# Variables
DOCKER_IMAGE=""
K8S_NAMESPACE=""

# Etape 1: Pull la derniere version de l'image docker ..."
echo "1. Pull la derniere version de l'image docker ..."
docker pull $DOCKER_IMAGE:latest

# Etape 2: Appliquer les fichiers kubernetes
echo "2. Deploy votre image sur Minikube ..."
kubectl apply -f deployment.yaml -n $K8S_NAMESPACE
kubectl apply -f service.yaml -n $K8S_NAMESPACE

# Etape 3: Mettre a jour l'image dans le deploiement Kubernetes
echo "3. Mise a jour de kubernetes avec la nouvelle image ..."
kubectl set image deployment/mon-app mon-container=$DOCKER_IMAGE:latest -n $K8S_NAMESPACE

# Etape 4: Ouvrir l'application
echo "4. Lancement de votre application ..."
minikube service mon-service -n $K8S_NAMESPACE

# Etape 5: Message de Fin
echo "Deployment Complete!(^_^)"
