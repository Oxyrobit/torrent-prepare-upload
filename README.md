# Torrent Prepare Upload

A Bash script to automate the preparation of torrent files and MediaInfo for uploading to private trackers.

## Overview

This script simplifies the process of creating torrent files and generating MediaInfo for your media files. It's designed for private trackers that use the announce URL format: `https://yourtracker/announce/passkey`

## How It Works

The script performs the following operations:

1. **Validates the input**: Checks if the provided path is a valid file or directory
2. **Checks dependencies**: Ensures `mediainfo` and `transmission-create` are installed
3. **NFO file detection**: Verifies that no `.nfo` files are present in the upload directory (NFO files are not allowed)
4. **Generates MediaInfo**: Creates a text file containing detailed media information from the first video file found (`.mkv`, `.mp4`, or `.avi`)
5. **Creates torrent file**: Generates a `.torrent` file using the transmission tools with your tracker's announce URL

## Prerequisites

Before using this script, you need to have the following tools installed on your system:

### Required Tools

- **mediainfo**: Used to extract detailed technical information from media files
  ```bash
  # Ubuntu/Debian
  sudo apt-get install mediainfo
  
  # macOS (Homebrew)
  brew install media-info
  
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

### 1. Make the script executable

After downloading or cloning this repository, you need to make the script executable:

```bash
chmod +x prepare-upload.sh
```

### 2. Configure your tracker settings

Edit the `prepare-upload.sh` file and update the following variables:

- **TRACKER_URL**: Replace `https://YOUR_TRACKER.cc/announce` with your tracker's base URL
- **PASSKEY**: Add your personal passkey provided by your tracker

Example:
```bash
TRACKER_URL="https://mytracker.net/announce"
PASSKEY="your_personal_passkey_here"
```

The script will automatically construct the full announce URL in the format: `https://yourtracker/announce/passkey`

## Usage

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

## Output

The script will generate two files:

1. **MediaInfo text file**: `<filename>.txt` - Contains detailed technical information about the media file
2. **Torrent file**: `<filename>.torrent` - The torrent file ready to be uploaded to your tracker

## Important Notes

- **NFO files are prohibited**: The script will exit with an error if any `.nfo` files are detected in the upload directory
- **Tracker URL format**: This script is designed for trackers using the announce URL format `https://yourtracker/announce/passkey`
- **Passkey security**: Never share your passkey or commit it to public repositories

## Troubleshooting

- **"mediainfo is not installed"**: Install mediainfo using the commands in the Prerequisites section
- **"transmission-create is not installed"**: Install transmission-cli using the commands in the Prerequisites section
- **"NFO files are not allowed"**: Remove any `.nfo` files from your upload directory before running the script
- **"No media files found"**: Ensure your directory contains at least one video file with `.mkv`, `.mp4`, or `.avi` extension

## License

This project is open source and available for use.
