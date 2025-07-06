#!/bin/bash
echo "[*] Menjalankan proses uninstall termux-manager..."

# Hapus shortcut dari .zshrc
if grep -Fxq "bash \"$HOME/.local/bin/termux-manager\"" ~/.zshrc; then
    sed -i "\|bash \"$HOME/.local/bin/termux-manager\"|d" ~/.zshrc
    echo "[✓] Shortcut dihapus dari .zshrc"
else
    echo "[ℹ️] Tidak ada shortcut termux-manager di .zshrc"
fi

# Hapus PATH tambahan kalau ada
if grep -Fxq 'export PATH=$PATH:$HOME/.local/bin' ~/.zshrc; then
    sed -i '/export PATH=\$PATH:\$HOME\/.local\/bin/d' ~/.zshrc
    echo "[✓] PATH tambahan dihapus dari .zshrc"
fi

# Hapus symlink
if [ -L "$HOME/.local/bin/termux-manager" ]; then
    rm "$HOME/.local/bin/termux-manager"
    echo "[✓] Symlink termux-manager dihapus"
else
    echo "[ℹ️] Symlink termux-manager tidak ditemukan"
fi

# Opsional: Tanya apakah mau hapus Oh My Posh & font
read -p "❓ Hapus Oh My Posh dan font NerdFont juga? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -f "$HOME/.local/bin/oh-my-posh"
    rm -rf "$HOME/.cache/themes"
    rm -f "$HOME/.termux/font.ttf"
    echo "[✓] Oh My Posh dan font dihapus"
fi

# Opsional: Tanya apakah mau hapus Oh My Zsh
read -p "❓ Hapus Oh My Zsh juga? (y/n): " confirm2
if [[ "$confirm2" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    echo "[✓] Oh My Zsh dihapus"
fi

echo "[✓] Uninstall selesai. Restart Termux agar perubahan .zshrc berlaku."