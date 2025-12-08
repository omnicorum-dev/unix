#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run user creation as root"
  exit 1
fi

sudo mkdir -p /etc/skel/Development

ALIGNO_GROUP="aligno"
if ! getent group "$ALIGNO_GROUP" >/dev/null; then
  echo "[+] Creating group: $ALIGNO_GROUP"
  sudo groupadd "$ALIGNO_GROUP"
else
  echo "[=] Group $ALIGNO_GROUP already exists"
fi

REPO_PATH="/srv/git/Aligno.git"
DATA_PATH="/srv/aligno_data"
USER_HOME_BASE="/home"

if [ ! -d "$REPO_PATH" ]; then
  echo "[+] Creating bare git repo at $REPO_PATH"
  sudo mkdir -p "$REPO_PATH"
  sudo git init --initial-branch=main --bare "$REPO_PATH"
else
  echo "[=] Repo already exists"
fi

if [ ! -d "$DATA_PATH" ]; then
  echo "[+] creating shared data directory: $DATA_PATH"
  sudo mkdir -p "$DATA_PATH"
else
  echo "[=] Data path already exists"
fi

echo "[+] Setting permissions"
sudo chown -R root:"$ALIGNO_GROUP" "$REPO_PATH" "$DATA_PATH"
sudo chmod -R g+ws "$REPO_PATH" "$DATA_PATH"
sudo chmod -R o-rwx "$REPO_PATH" "$DATA_PATH"

echo "[+] marking git safe.directory for shared access"
sudo git config --system --add safe.directory "$REPO_PATH" || true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

USER_FILE="$SCRIPT_DIR/default_users.txt"

if [ ! -f "$USER_FILE" ]; then
  echo "File $USER_FILE not found!"
  exit 1
fi

echo "[+] Creating / updating users"

while IFS=: read -r username password fullname; do
  # skip empty lines
  [ -z "$username" ] && continue

  USER_HOME="$USER_HOME_BASE/$username"
  DEV_FOLDER="$USER_HOME/Development"
  CLONE_FOLDER="$DEV_FOLDER/Aligno"

  # check if user already exists
  if id "$username" &>/dev/null; then
    echo "[=] User $username already exists, ensuring $ALIGNO_GROUP member"
    sudo usermod -aG "$ALIGNO_GROUP" "$username"
  else
    # create user with home dir and zsh shell
    echo "[+] Creating user $username"
    useradd -m -s /usr/bin/zsh -c "$fullname" -G "$ALIGNO_GROUP" "$username"
    echo "$username:$password" | sudo chpasswd
    sudo -u "$username" xdg-user-dirs-update
    echo "User $username added successfully"
  fi

  sudo mkdir -p "$DEV_FOLDER"
  sudo chown "$username:$username" "$DEV_FOLDER"

  # Clone repo if missing
  if [ ! -d "$CLONE_FOLDER" ]; then
    echo "    [+] Cloning repo for $username"
    sudo -u "$username" git clone "$REPO_PATH" "$CLONE_FOLDER" || {
      echo "    [!] Clone failed for $username — check permissions"
      continue
    }
  else
    echo "    [=] Repo already cloned for $username"
  fi

  # Create symlink to shared data
  if [ ! -L "$CLONE_FOLDER/data" ]; then
    echo "    [+] Linking data directory for $username"
    sudo -u "$username" ln -s "$DATA_PATH" "$CLONE_FOLDER/data" || true
  else
    echo "    [=] Data link already exists for $username"
  fi

done <"$USER_FILE"
