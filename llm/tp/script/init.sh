#!/usr/bin/env bash
#
# init.sh — Ajoute des configurations à ~/.bashrc
#           et restaure les sauvegardes de exit.sh
#

set -euo pipefail

BASHRC="$HOME/.bashrc"
BACKUP_ROOT="$HOME/Documents/backup"

echo "Ajout des configurations dans $BASHRC..."

# Copier si nécessaire ~/.ssh
if [ ! -d "$HOME/.ssh" ]; then
  echo "Création du répertoire ~/.ssh..."
  cp -rf "$HOME/Documents/.ssh" "$HOME"
  chmod 600 "$HOME/.ssh"/*
fi

BASHRC=/dev/null
cat >> "$BASHRC" << 'EOF'

# ───────────────── Personnalisation ajoutée par init.sh ───────────────── #

HISTSIZE=1000000
HISTFILESIZE=20000

export PS1="\u@\h:\W\$ "

alias ls='ls --color=auto -T 0 -N'
alias clean='rm -f core *.out #*# *~ .*~ *.aux *.log *.dvi *.o *.a *.train* *.test* *.aux *.bbl *.blg *.dvi *.toc'
alias ll='ls -ln'
alias la='ls -la'
alias lr='ls -R'
alias lc='ls *.h* *.c*'

alias rm='rm -i'
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'

alias more=less
alias lsof='/usr/sbin/lsof'

. /etc/bash_completion

alias docker='sudo -g docker docker'

export PATH="$PATH:$HOME/Documents/bin"

# ───────────────── Fin de la personnalisation ───────────────── #

EOF

echo "Configurations Bash ajoutées avec succès."

echo ""
echo "N'oubliez pas de recharger votre bash avec :"
echo "   source ~/.bashrc"
echo ""
echo "Vérification des sauvegardes possibles..."

# ------------------------------
# Restauration de la sauvegarde
# ------------------------------

# Restaurer l'historique Bash

shopt -s nullglob # La commande shopt -s nullglob active une option de comportement de Bash liée à l’expansion des modèles (globbing)
history_files=("$BACKUP_ROOT"/backup_*/bash_history_*)
if [ ${#history_files[@]} -gt 0 ]; then
  latest_hist=$(ls -1t "${history_files[@]}" | head -n 1)
  echo "Restaurer l'historique Bash depuis : $latest_hist"
  cp -v "$latest_hist" "$HOME/.bash_history"
else
  echo "Aucune sauvegarde d'historique Bash trouvée dans $BACKUP_ROOT"
fi

# Restaurer le profil Firefox

echo ""
echo "Tentative de restauration du profil Firefox..."

# Emplacements possibles pour les backups
firefox_backups=("$BACKUP_ROOT"/backup_*/firefox)
if [ ${#firefox_backups[@]} -gt 0 ]; then
  latest_firefox=$(ls -1td "${firefox_backups[@]}" | head -n 1)
  echo "Profil Firefox trouvé : $latest_firefox"

  # Emplacement actuel de Firefox
  target_ff="$HOME/.mozilla/firefox"

  if [ -d "$target_ff" ]; then
    echo "Sauvegarde de l'ancien profil Firefox existant"
    mv -v "$target_ff" "$target_ff.old_$(date +%Y%m%d_%H%M%S)"
  fi

  echo "Copie du profil Firefox de sauvegarde..."
  if [ ! -d ~/.mozilla ]; then
    mkdir ~/.mozilla
  fi
  cp -a "$latest_firefox" "$target_ff"

  echo "Profil Firefox restauré depuis $latest_firefox"
else
  echo "Aucune sauvegarde de Firefox trouvée dans $BACKUP_ROOT"
fi

echo ""
echo "Restauration terminée."
echo "Vous pouvez désormais relancer Firefox ou recharger votre session Bash."

echo ""
echo "Pour recharger l'historique de la session précédente,"
echo "et mettre à jour l'environnement, relancez bash"
echo "        bash"
