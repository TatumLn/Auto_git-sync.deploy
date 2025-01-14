#!/bin/bash

# Verification si GIT est bien installer
checker_git() {
if ! command -v git &> /dev/null;
then
	echo "Git n'est pas installe sur ce systeme."
	echo "Veuillez installer Git avant de continuer."
	echo "Pour installer Git:"
	echo "- Sur Debian/Ubuntu/Kali : sudo apt install git"
	echo "- Sur RHEL : sudo dnf install git"
	exit 1
fi
}

echo "Verification de l'installation de Git ..."
checker_git
echo "Git est bien installe."

# Variables
GIT_REPO=""
BRANCH="main"

# Etape 1: Pull la derniere version du code
echo "1. Pull du derniere version du code sur votre depot GITHUB ..."
git pull origin $BRANCH

# Etape 2: Verification s`il y a eu des modifications locales
if [[ $(git status --porcelain) ]];
then
	echo "2. Modification detecte. Push des modifications sur votre depot GITHUB ..."
	git add .
	echo "3. Veuillez saisir le message de commit ..."
	read commit_message
	message_commit_complet="$commit_message - $(date +'%Y-%m-%d %H:%M:%S')"
	echo "4. Commit :$message_commit_complet"
	git commit -m "$message_commit_complet"

	# Verification de l'etat du push 
	echo "5. Pusher votre modifications sur votre depot GITHUB ..."
	if git push origin $BRANCH;
	then
		echo "Votre code a bien ete pusher avec succes!"
	else
		echo "Le push a rencontre une erreur. verifions cela ..."
	echo "6. Resolution du probleme ..."

else
	echo "2. Pas de modification detecte. Pas de Push ..."
fi

# Etape 3: Message final
echo "Git sync complete!(^_^)"
