#!/bin/sh

# Torstein Eide
# https://gist.github.com/Torstein-Eide/d291288a83eac00b3430cf58ca0e4702

# Install Bitwarden CLI

# Exit immediately if Bitwarden CLI (bw) is already in $PATH
test_if_installed() {
  type bw >/dev/null 2>&1 
}
test_if_installed && { exit 0 ; }

Linux() {
  if "$(uname -m)" != "x86_64"; then
    echo "Unsupported architecture. Exiting."
    exit 1
  fi

  echo "Detected Linux and x86_64 architecture. Installing Bitwarden CLI..."
  
  DOWNLOAD_URL="https://bitwarden.com/download/?app=cli&platform=linux"
  TEMP_FILE="/tmp/bw-linux.zip"
  INSTALL_PATH="$HOME/.bin/bw"

  # check if dependencies are installed, auto-install if possible
  for dependency in unzip wget; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
      if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm --needed "$dependency"
      elif command -v apt >/dev/null 2>&1; then
        sudo apt install -y "$dependency"
      elif command -v brew >/dev/null 2>&1; then
        brew install "$dependency"
      else
        echo "$dependency is not installed. Please install it and try again."
        exit 2
      fi
    fi
  done

  echo "Downloading Bitwarden CLI from $DOWNLOAD_URL"
  wget -O "$TEMP_FILE" "$DOWNLOAD_URL" || { echo "Failed to download Bitwarden CLI."; exit 10; }
  
  echo "Unzipping $TEMP_FILE"
  unzip -o "$TEMP_FILE" || { echo "Failed to unzip $TEMP_FILE."; exit 11; }

  echo "Create ~/.bin folder if it doesn't exist"
  mkdir -p "$HOME/.bin"

  if [[ ":$PATH:" == *":$HOME/.bin:"* ]]; then
    echo "~/.bin is already part of the PATH."
  else
    echo 'export PATH="$HOME/.bin:$PATH"' >> "$HOME/.config/bash/custom.sh"
    echo "⚠️  ~/.bin has been added to ~/.config/bash/custom.sh. Please restart your terminal or run: source ~/.bashrc"
  fi

  echo "Moving bw to $INSTALL_PATH"
  mv bw "$INSTALL_PATH" || { echo "Failed to move bw to $INSTALL_PATH."; exit 12; }

  echo "Setting execute permissions on $INSTALL_PATH"
  chmod +x "$INSTALL_PATH" || { echo "Failed to set permissions on $INSTALL_PATH."; exit 13; }
  
  test_if_installed
  echo "Bitwarden CLI successfully installed at $INSTALL_PATH"
}

echo "Bitwarden CLI not found. Proceeding with installation."

case "$(uname -s)" in
    Linux)
      Linux
      ;;

    *)
      echo "Unsupported OS. Exiting."
      exit 1
      ;;
esac
