#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run user creation as root"
	exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

USER_FILE="$SCRIPT_DIR/default_users.txt"

if [ ! -f "$USER_FILE" ]; then
	echo "File $USER_FILE not found!"
	exit 1
fi

while IFS=: read -r username password fullname; do
	# skip empty lines
	[ -z "$username" ] && continue

	# check if user already exists
	if id "$username" &>/dev/null; then
		echo "User $username already exists, skipping..."
	else
		# create user with home dir and zsh shell
		useradd -m -s /usr/bin/zsh -c "$fullname" "$username"
		echo "$username:$password" | chpasswd
		sudo -u "$username" xdg-user-dirs-update
		echo "User $username added successfully"
	fi
done < "$USER_FILE"

