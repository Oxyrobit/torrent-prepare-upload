#!/bin/bash

set -e

TRACKER_URL="https://YOUR_TRACKER.cc/announce"
PASSKEY=""

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-upload-directory> OR <path-to-upload-file>"
    exit 1
fi

UPLOAD_PATH="$1"
if [ -d "$UPLOAD_PATH" ]; then
    if [ ! -d "$UPLOAD_PATH" ]; then
        echo "Error: Upload directory '$UPLOAD_PATH' does not exist."
        exit 1
    fi
elif [ -f "$UPLOAD_PATH" ]; then
    if [ ! -f "$UPLOAD_PATH" ]; then
        echo "Error: Upload file '$UPLOAD_PATH' does not exist."
        exit 1
    fi
else
    echo "Error: '$UPLOAD_PATH' is neither a file nor a directory."
    exit 1
fi

# Vérification de la présence de mediainfo
if ! command -v mediainfo &> /dev/null; then
    echo "Error: mediainfo is not installed. Please install it and try again."
    exit 1
fi

# Vérification de la présence de transmission-create
if ! command -v transmission-create &> /dev/null; then
    echo "Error: transmission-create is not installed. Please install it and try again."
    exit 1
fi

MEDIAINFO_FILE=""
if [ -d "$UPLOAD_PATH" ]; then

    # Vérification de la présence d'un fichier nfo (interdit)
    if ls "$UPLOAD_PATH"/*.nfo &> /dev/null; then
        echo "Error: NFO files are not allowed in the upload directory."
        exit 1
    fi

    # Obtenir le premier fichier média pour mediainfo
    MEDIAINFO_FILE=$(find "$UPLOAD_PATH" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \) | head -n 1)
    if [ -z "$MEDIAINFO_FILE" ]; then
        echo "Error: No media files found in the upload directory for mediainfo."
        exit 1
    fi
fi

# Génération des informations mediainfo dans un fichier texte
MEDIAINFO_OUTPUT="$(basename "$MEDIAINFO_FILE").txt"
mediainfo "$MEDIAINFO_FILE" > "$MEDIAINFO_OUTPUT"
echo "Mediainfo saved to $MEDIAINFO_OUTPUT"

# Création du fichier .torrent
TORRENT_FILE="$(basename "$UPLOAD_PATH").torrent"
transmission-create -p -o "$TORRENT_FILE" -t "$TRACKER_URL/$PASSKEY" "$UPLOAD_PATH"
echo "Torrent file created: $TORRENT_FILE"