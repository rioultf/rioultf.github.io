#!/usr/bin/env python3
"""
generate_comptine.py — génère une comptine longue et affiche
le nombre de tokens estimé (sur stderr) tout en écrivant
le texte sur stdout pour redirection si besoin.
"""

import sys
import argparse
import tiktoken

# Fonction qui compte les tokens d'un texte
def count_tokens(text: str, encoding_name: str = "cl100k_base") -> int:
    encoding = tiktoken.get_encoding(encoding_name)
    return len(encoding.encode(text))

# Génère la comptine
def generate_song(repeat: int) -> str:
    """
    Génère une comptine avec des vers numérotés
    et un refrain.
    """
    refrain = "Refrain: Récapitule tous les carnets vus jusqu’ici.\n"
    text = ""
    for i in range(1, repeat + 1):
        text += f"Vers {i}: Le nom de carnet {i} est Marin.\n"
        if i % 10 == 0:
            text += refrain
    return text

# Configuration CLI
parser = argparse.ArgumentParser(
    description="Génère une comptine pour tester les limites de fenêtre de contexte."
)
parser.add_argument(
    "repeat",
    type=int,
    help="Nombre de vers à générer (plus grand = plus long, augmente les tokens)."
)

args = parser.parse_args()

# Génération du texte
comptine = generate_song(args.repeat)

# Comptage des tokens
n_tokens = count_tokens(comptine)

# Sorties
print(f"{comptine}", end="")
print(f"Nombre de tokens estimés : {n_tokens}", file=sys.stderr)
