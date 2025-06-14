#!/bin/bash

# set -e

# Buat symlink dinamis ke main.sh
MAIN_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/main.sh"
LINK_PATH="$HOME/.local/bin/termux-manager"

echo "[*] Checking and installing base packages silently..."
# Daftar package yang dibutuhkan
packages=(curl wget unzip git zsh)

for pkg in "${packages[@]}"; do
    if ! command -v "$pkg" > /dev/null 2>&1; then
        echo "[-] Installing $pkg..."
        pkg install -y "$pkg" > /dev/null 2>&1
        if command -v "$pkg" > /dev/null 2>&1; then
            echo "[✓] $pkg installed successfully."
        else
            echo "[✗] Failed to install $pkg."
        fi
    else
        echo "[✓] $pkg already installed."
    fi
done
echo "[✓] Base packages check complete."

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] Installing Oh My Zsh..."
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "[✓] Oh My Zsh already installed"
fi

# Install Oh My Posh
mkdir -p ~/.local/bin
cd ~/.local/bin
if [ ! -f "oh-my-posh" ]; then
    echo "[+] Installing Oh My Posh..."
    wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v26.6.1/posh-android-arm -O oh-my-posh
    chmod +x oh-my-posh
else
    echo "[✓] Oh My Posh already installed"
fi

# Tambahkan ~/.local/bin ke PATH di ~/.zshrc jika belum ada
if ! grep -q 'export PATH=\$PATH:\$HOME/.local/bin' ~/.zshrc; then
    echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc
fi

# Download tema-tema Oh My Posh
mkdir -p ~/.cache
if [ ! -d ~/.cache/themes ]; then
    echo "[+] Cloning themes..."
    git clone https://github.com/JanDeDobbeleer/oh-my-posh ~/.cache/oh-my-posh
    mv ~/.cache/oh-my-posh/themes ~/.cache/themes
    rm -rf ~/.cache/oh-my-posh
else
    echo "[✓] Themes already available"
fi

# Download dan pasang font NerdFont
FONT_PATH="$HOME/.termux/font.ttf"
if [ ! -f "$FONT_PATH" ]; then
    echo "[+] Installing Nerd Font..."
    mkdir -p ~/.termux
    cd ~/.cache
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip 'JetBrainsMonoNerdFont-Bold.ttf'
    mv JetBrainsMonoNerdFont-Bold.ttf "$FONT_PATH"
    termux-reload-settings
else
    echo "[✓] Nerd Font already installed"
fi

# echo $MAIN_PATH

# Hapus symlink lama kalau ada, lalu buat baru
rm -f "$LINK_PATH"
ln -s "$MAIN_PATH" "$LINK_PATH"

# Tambahkan ke .zshrc jika belum ada
if ! grep -Fxq "bash \"$LINK_PATH\"" ~/.zshrc; then
    echo "bash \"$LINK_PATH\"" >> ~/.zshrc
    echo "✔️ .zshrc updated to run: $LINK_PATH"
else
    echo "ℹ️ setup-manager already in .zshrc"
fi