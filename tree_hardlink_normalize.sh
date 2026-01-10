#!/bin/bash
set -Eeuo pipefail
# Vérifications de base
if [ $# -ne 1 ]; then
    echo "Usage: $0 <dossier_source>"
    exit 1
fi

SRC="$(realpath "$1")"

if [ ! -d "$SRC" ]; then
    echo "Le chemin fourni n'est pas un dossier."
    exit 1
fi

PARENT="$(dirname "$SRC")"
BASENAME="$(basename "$SRC")"
NEW_BASENAME="$(echo "$BASENAME" | tr ' ' '.')"
DST="$PARENT/$NEW_BASENAME"

if [ -e "$DST" ]; then
    echo "Le dossier destination existe déjà: $DST"
    exit 1
fi

#mkdir "$DST"
echo "Prévisualisation des opérations à effectuer :"
# Création des dossiers
find "$SRC" -type d | while read -r dir; do
    rel="${dir#$SRC/}"
    [ "$dir" = "$SRC" ] && continue
    new_rel="$(echo "$rel" | tr ' ' '.')"
    echo "$DST/$new_rel"
done


read -p "Ce script va créer un nouveau dossier avec des noms de fichiers et dossiers sans espaces. Voulez-vous continuer ? (Y/N) " choice
if [[ "$choice" != "Y" && "$choice" != "y" ]]; then
    echo "Opération annulée."
    exit 1
fi

mkdir "$DST"

find "$SRC" -type d | while read -r dir; do
    rel="${dir#$SRC/}"
    [ "$dir" = "$SRC" ] && continue
    new_rel="$(echo "$rel" | tr ' ' '.')"
    mkdir "$DST/$new_rel"
done

# Création des hardlinks
find "$SRC" -type f | while read -r file; do
    rel="${file#$SRC/}"
    new_rel="$(echo "$rel" | tr ' ' '.')"
    target="$DST/$new_rel"

    if [ ! -e "$target" ]; then
        ln "$file" "$target"
    fi
done
