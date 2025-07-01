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
  INSTALL_PATH="$HOME/Apps/bw"

  # check if dependencies are installed
  for dependency in unzip wget; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        echo "$dependency is not installed. Please install it and try again."
        exit 2
    fi
  done

  echo "Downloading Bitwarden CLI from $DOWNLOAD_URL"
  wget -O "$TEMP_FILE" "$DOWNLOAD_URL" || { echo "Failed to download Bitwarden CLI."; exit 10; }
  
  echo "Unzipping $TEMP_FILE"
  unzip -o "$TEMP_FILE" || { echo "Failed to unzip $TEMP_FILE."; exit 11; }

  echo "Create ~/Apps folder if it doesn't exist"
  mkdir -p $HOME/Apps

  if [[ ":$PATH:" == *":$HOME/Apps:"* ]]; then
    echo "~/Apps is already part of the path"
  else
    echo "PATH=$PATH:/home/jimmy/Apps" > $HOME/.bashrc && source $HOME/.bashrc
    echo "~/Apps has been added to the path"
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
