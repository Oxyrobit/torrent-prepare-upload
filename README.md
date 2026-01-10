# Torrent Prepare Upload

A collection of Bash scripts to automate the preparation of torrent files and MediaInfo for uploading to private trackers.

## Overview

This repository contains two helpful scripts for managing and preparing media files for private tracker uploads:

1. **prepare-upload.sh**: Creates torrent files and generates MediaInfo for your media files
2. **tree-hardlink-normalize.sh**: Normalizes directory and file names by replacing spaces with dots using hardlinks

---

## prepare-upload.sh

This script simplifies the process of creating torrent files and generating MediaInfo for your media files. It's designed for private trackers that use announce URLs with a passkey (e.g., `https://yourtracker/announce/your-passkey`).

## How It Works

### prepare-upload.sh

The script performs the following operations:

1. **Validates the input**: Checks if the provided path is a valid file or directory
2. **Checks dependencies**: Ensures `mediainfo` and `transmission-create` are installed
3. **NFO file detection**: Verifies that no `.nfo` files are present in the upload directory (NFO files are not allowed)
4. **Generates MediaInfo**: Creates a text file containing detailed media information from the first video file found (`.mkv`, `.mp4`, or `.avi`)
5. **Creates torrent file**: Generates a `.torrent` file using the transmission tools with your tracker's announce URL

### tree-hardlink-normalize.sh

This script normalizes directory and file names by replacing spaces with dots, using hardlinks to avoid duplicating disk space:

1. **Validates the input**: Checks if the provided path is a valid directory
2. **Analyzes the structure**: Scans all files and directories in the source
3. **Shows preview**: Displays what operations will be performed
4. **User confirmation**: Asks for confirmation before proceeding
5. **Creates normalized structure**: Creates a new directory tree with spaces replaced by dots
6. **Creates hardlinks**: Links files from the original directory to the new normalized structure (no disk space duplication)

**Important**: This script uses hardlinks, which means the files are not copied but linked. Both the original and normalized directories will point to the same file data on disk, saving space. Deleting files from one directory will not affect the other unless all hardlinks are removed.

## Prerequisites

Before using this script, you need to have the following tools installed on your system:

### Required Tools

- **mediainfo**: Used to extract detailed technical information from media files
  ```bash
  # Ubuntu/Debian
  sudo apt-get install mediainfo
  
  # macOS (Homebrew)
  brew install mediainfo
  
  # Fedora/RHEL
  sudo dnf install mediainfo
  ```

- **transmission-cli**: Provides the `transmission-create` command for creating torrent files
  ```bash
  # Ubuntu/Debian
  sudo apt-get install transmission-cli
  
  # macOS (Homebrew)
  brew install transmission-cli
  
  # Fedora/RHEL
  sudo dnf install transmission-cli
  ```

## Setup

### For prepare-upload.sh

### 1. Make the script executable

After downloading or cloning this repository, you need to make the script executable:

```bash
chmod +x prepare-upload.sh
```

### 2. Configure your tracker settings

Edit the `prepare-upload.sh` file and update the following variables:

- **TRACKER_URL**: Your tracker's announce URL (should end with `/announce`)
- **PASSKEY**: Your personal passkey provided by your tracker

Example:
```bash
TRACKER_URL="https://mytracker.net/announce"
PASSKEY="your_personal_passkey_here"
```

The script will automatically construct the full announce URL by combining these: `TRACKER_URL/PASSKEY` (e.g., `https://mytracker.net/announce/your_personal_passkey_here`).

### For tree-hardlink-normalize.sh

Make the script executable:

```bash
chmod +x tree-hardlink-normalize.sh
```

No additional configuration is needed for this script.

## Usage

### prepare-upload.sh

Run the script with the path to the file or directory you want to upload:

```bash
./prepare-upload.sh <path-to-upload-directory>
```

or

```bash
./prepare-upload.sh <path-to-upload-file>
```

### Examples

For a directory containing media files:
```bash
./prepare-upload.sh /path/to/my/movie/folder
```

For a single media file:
```bash
./prepare-upload.sh /path/to/my/video.mkv
```

### tree-hardlink-normalize.sh

Run the script with the path to the directory you want to normalize:

```bash
./tree-hardlink-normalize.sh <path-to-source-directory>
```

#### Examples

For a directory with spaces in file/folder names:
```bash
./tree-hardlink-normalize.sh "/path/to/My Movie Folder"
```

This will create a new directory with the same name but spaces replaced by dots (e.g., `My.Movie.Folder`) and hardlink all files from the original directory.

**Note**: The script will show a preview of operations and ask for confirmation before proceeding.

## Output

### prepare-upload.sh

The script will generate two files:

1. **MediaInfo text file**: `<filename>.txt` - Contains detailed technical information about the media file
2. **Torrent file**: `<filename>.torrent` - The torrent file ready to be uploaded to your tracker

### tree-hardlink-normalize.sh

The script will generate:

1. **New normalized directory**: A directory with the same structure but all spaces replaced by dots in file and folder names
2. **Hardlinked files**: All files are hardlinked (not copied), so no additional disk space is used

## Important Notes

### prepare-upload.sh

- **NFO files are prohibited**: The script will exit with an error if any `.nfo` files are detected in the upload directory
- **Tracker URL configuration**: Configure your TRACKER_URL (ending with `/announce`) and PASSKEY separately in the script. They will be combined as `TRACKER_URL/PASSKEY`
- **Passkey security**: Never share your passkey or commit it to public repositories

### tree-hardlink-normalize.sh

- **Hardlinks only work on the same filesystem**: Source and destination must be on the same partition/filesystem
- **Destination must not exist**: The script will exit if the normalized directory already exists
- **No disk space duplication**: Files are hardlinked, not copied, so disk space usage remains the same
- **Both directories share file data**: Modifying a file in either directory will affect both (they point to the same inode)

## Troubleshooting

### prepare-upload.sh

- **"mediainfo is not installed"**: Install mediainfo using the commands in the Prerequisites section
- **"transmission-create is not installed"**: Install transmission-cli using the commands in the Prerequisites section
- **"NFO files are not allowed"**: Remove any `.nfo` files from your upload directory before running the script
- **"No media files found"**: Ensure your directory contains at least one video file with `.mkv`, `.mp4`, or `.avi` extension

### tree-hardlink-normalize.sh

- **"The provided path is not a directory"**: Ensure you're passing a directory path, not a file
- **"The destination directory already exists"**: The normalized directory already exists. Remove it or choose a different source directory
- **Hardlink creation fails**: Ensure both source and destination are on the same filesystem/partition

## License

This project is open source and available for use.
