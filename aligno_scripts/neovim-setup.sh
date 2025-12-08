#!/usr/bin/env bash
set -e

# -------------------------------
# Step 1: Install dependencies
# -------------------------------
sudo apt update
sudo apt install -y git curl software-properties-common gnupg lsb-release ca-certificates

sudo apt install luarocks golang-go cargo

# Add the NodeSource repository (for Node.js 18.x, change version if necessary)
curl -fsSL https://deb.nodesource.com/setup_25.x | sudo -E bash -

# Install Node.js (npm will be installed automatically)
sudo apt install -y nodejs

# Optional: Install build tools (e.g., for compiling native modules)
sudo apt install -y build-essential

# Verify installation
node -v
npm -v

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# install ast_grep
#npm install --global @ast-grep/cli

#npm install -g @mermaid-js/mermaid-cli

# installing pipx and pynvim
sudo apt install pipx
pipx ensurepath
sudo pipx ensurepath
sudo apt install python3-pynvim

# -------------------------------
# Step 2: Install Neovim (>=0.11.2) via PPA
# -------------------------------
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

echo "Neovim version installed:"
nvim --version | head -n 1

# -------------------------------
# Step 3: Clone LazyVim template
# -------------------------------
TEMPLATE_DIR="/usr/local/share/lazyvim-template"
sudo rm -rf "$TEMPLATE_DIR"
sudo git clone https://github.com/LazyVim/starter "$TEMPLATE_DIR"
sudo rm -rf "$TEMPLATE_DIR/.git"

echo "LazyVim template cloned to $TEMPLATE_DIR"

# -------------------------------
# Step 4: Copy template to all existing users
# -------------------------------
for USER_HOME in /home/*; do
  USERNAME=$(basename "$USER_HOME")

  # Skip if it's not a real user directory
  [ -d "$USER_HOME" ] || continue

  USER_NVIM="$USER_HOME/.config/nvim"

  # Only copy if user doesn't already have config
  if [ ! -d "$USER_NVIM" ]; then
    mkdir -p "$USER_HOME/.config"
    sudo cp -r "$TEMPLATE_DIR" "$USER_NVIM"
    sudo chown -R "$USERNAME:$USERNAME" "$USER_NVIM"
    echo "LazyVim copied to $USERNAME's config"
  else
    echo "$USERNAME already has ~/.config/nvim — skipping"
  fi
done

# -------------------------------
# Step 5: Optional: pre-install plugins for all users
# -------------------------------
echo "To pre-install plugins for all users, run:"
echo "sudo -u <username> nvim --headless '+Lazy! sync' +qa"

echo "✅ Multi-user LazyVim installation complete."
