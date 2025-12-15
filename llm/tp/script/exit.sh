#!/usr/bin/env bash
#
# exit.sh — sauvegarde historique Bash et profil Firefox
#

set -euo pipefail

# Dates et répertoires
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/Documents/backup/backup_$DATE"

echo "Création du dossier de sauvegarde : $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
history -a
echo "Sauvegarde de l'historique Bash"
cp -v "$HOME/.bash_history" "$BACKUP_DIR/bash_history_$DATE"

# Sauvegarde de la configuration Firefox
echo "Fermeture de Firefox"

# Tenter une fermeture propre
pkill -15 -f firefox 2>/dev/null || true
# Attendre un peu
sleep 2
# Forcer la fermeture si nécessaire
pkill -9 -f firefox 2>/dev/null || true

echo "Firefox arrêté."

echo "Sauvegarde de la configuration Firefox (profil)"
# Détecter le répertoire Firefox
MOZILLA_DIR="$HOME/.mozilla/firefox"

if [ -d "$MOZILLA_DIR" ]; then
  cp -r "$MOZILLA_DIR" "$BACKUP_DIR"
  echo "Firefox sauvegardé dans $BACKUP_DIR/firefox"
else
  echo "Répertoire Firefox introuvable : $MOZILLA_DIR"
fi

echo ""
echo "Sauvegarde terminée."
echo "Fichiers disponibles dans : $BACKUP_DIR"
