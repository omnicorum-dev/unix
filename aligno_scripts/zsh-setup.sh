#!/usr/bin/env bash

echo Installing zsh
yes | sudo apt install zsh

echo Installing JetBrains nerd font
FONT_DIR="/usr/local/share/fonts"
FONT_NAME="JetBrainsMono"

# Check if any JetBrains Mono Nerd Font TTF file already exists
if find "$FONT_DIR" -type f -name "${FONT_NAME}*.ttf" | grep -q .; then
  echo "JetBrains Nerd Font is already installed. Skipping download."
else
  echo "Installing JetBrains Nerd Font..."

  sudo mkdir -p "$FONT_DIR"
  (
    cd "$FONT_DIR"

    ZIP_FILE="JetBrainsMono.zip"
    URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/${ZIP_FILE}"

    sudo wget -q "$URL" -O "$ZIP_FILE"
    sudo unzip -o "$ZIP_FILE"
    sudo rm "$ZIP_FILE"

    # Fix permissions
    sudo find "$FONT_DIR" -type f -name "*.ttf" -exec chmod 644 {} \;
    sudo find "$FONT_DIR" -type f -name "*.otf" -exec chmod 644 {} \;

    sudo fc-cache -fv >/dev/null
  )

  echo "JetBrains Nerd Font installed successfully."
fi

echo Installing FiraCode Nerd Font
FONT_NAME="FiraCode"

# Check if any FiraCode Nerd Font TTF file already exists
if find "$FONT_DIR" -type f -name "${FONT_NAME}*.ttf" | grep -q .; then
  echo "FiraCode Nerd Font is already installed. Skipping download."
else
  echo "Installing FiraCode Nerd Font..."

  sudo mkdir -p "$FONT_DIR"
  (
    cd "$FONT_DIR"

    ZIP_FILE="FiraCode.zip"
    URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/${ZIP_FILE}"

    sudo wget -q "$URL" -O "$ZIP_FILE"
    sudo unzip -o "$ZIP_FILE"
    sudo rm "$ZIP_FILE"

    # Fix permissions
    sudo find "$FONT_DIR" -type f -name "*.ttf" -exec chmod 644 {} \;
    sudo find "$FONT_DIR" -type f -name "*.otf" -exec chmod 644 {} \;

    sudo fc-cache -fv >/dev/null
  )

  echo "FiraCode Nerd Font installed successfully."
fi

echo setting zsh as default shell
sudo chsh -s /usr/bin/zsh
sed -i 's#SHELL=/bin/bash#SHELL=/usr/bin/zsh#g' /etc/default/useradd

echo Creating system-wide Oh-My-Zsh directory
OMZ_DIR='/usr/share/oh-my-zsh'
if [ ! -d "$OMZ_DIR" ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh "$OMZ_DIR"
fi

echo Installing system-wide Powerlevel10k theme
mkdir -p "$OMZ_DIR/custom/themes"
git clone --depth=1 https://github.com/romkatv/powerlevel10k \
  "$OMZ_DIR/custom/themes/powerlevel10k" || true

echo Installing system-wide plugins
mkdir -p "$OMZ_DIR/custom/plugins"
# Autosuggestions
if [ ! -d "$OMZ_DIR/custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$OMZ_DIR/custom/plugins/zsh-autosuggestions"
fi

# Syntax highlighting
if [ ! -d "$OMZ_DIR/custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$OMZ_DIR/custom/plugins/zsh-syntax-highlighting"
fi

echo Creating default .zshrc for all users
DEFAULT_ZSHRC="/etc/zsh/zshrc"
DEFAULT_P10k="/etc/zsh/p10k.zsh"
SCRIPT_DIR=$(dirname "$(realpath "$0")")

mkdir -p /etc/zsh

cp "$SCRIPT_DIR/p10k.zsh" $DEFAULT_P10k
cp "$SCRIPT_DIR/zshrc" $DEFAULT_ZSHRC

echo Applying default .zshrc to existing users
for home in /home/*; do
  if [ -d "$home" ]; then
    cp "$DEFAULT_ZSHRC" "$home/.zshrc"
    cp "$DEFAULT_P10k" "$home/.p10k.zsh"
    chown $(basename "$home"):$(basename "$home") "$home/.zshrc"
    chown $(basename "$home"):$(basename "$home") "$home/.p10k.zsh"
  fi
done
