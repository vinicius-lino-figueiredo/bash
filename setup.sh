#!/usr/bin/env bash
# ~/.bash/setup.sh — bootstrap idempotente
set -euo pipefail

BASH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### ---[ Helper: package manager ]----------------------------------------------

pkg_install() {
    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y "$@"
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --needed --noconfirm "$@"
    else
        echo "Package manager não suportado. Instale manualmente: $*" >&2
        return 1
    fi
}

### ---[ 1. Dependências do sistema ]-------------------------------------------

if ! command -v gcc &>/dev/null; then
    echo "Instalando gcc..."
    pkg_install gcc
else
    echo "gcc já instalado."
fi

### ---[ 2. Instalar mise ]-----------------------------------------------------

if ! command -v mise &>/dev/null && [[ ! -x "$HOME/.local/bin/mise" ]]; then
    echo "Instalando mise..."
    curl -fsSL https://mise.run | sh
else
    echo "mise já instalado."
fi

### ---[ 2. Configurar ~/.bashrc ]----------------------------------------------

BASHRC_LINE='source "$HOME/.bash/bashrc"'

if [[ ! -f "$HOME/.bashrc" ]] || ! grep -qF '.bash/bashrc' "$HOME/.bashrc"; then
    echo "Configurando ~/.bashrc..."
    echo "$BASHRC_LINE" > "$HOME/.bashrc"
else
    echo "~/.bashrc já configurado."
fi

### ---[ 3. Symlink mise.toml ]-------------------------------------------------

MISE_CONFIG_DIR="$HOME/.config/mise"
MISE_CONFIG="$MISE_CONFIG_DIR/config.toml"
MISE_SOURCE="$BASH_DIR/mise.toml"

if [[ "$(readlink -f "$MISE_CONFIG" 2>/dev/null)" != "$MISE_SOURCE" ]]; then
    echo "Criando symlink mise.toml..."
    mkdir -p "$MISE_CONFIG_DIR"
    ln -sf "$MISE_SOURCE" "$MISE_CONFIG"
else
    echo "Symlink mise.toml já correto."
fi

### ---[ 4. Instalar ferramentas ]----------------------------------------------

echo "Instalando ferramentas via mise..."
mise install
mise reshim

### ---[ 5. Configurar nvim ]---------------------------------------------------

if [[ ! -d "$HOME/.config/nvim" ]]; then
    git clone https://github.com/vinicius-lino-figueiredo/nvim "$HOME/.config/nvim/"
fi

### ---[ 6. Configurar tmux ]---------------------------------------------------

if [[ ! -d "$HOME/.config/.tmuxconf" ]]; then
    git clone https://github.com/vinicius-lino-figueiredo/tmux "$HOME/.config/.tmuxconf/"
fi

if [[ -f "$HOME/.tmux.conf" ]]; then
    rm "$HOME/.tmux.conf"
fi
ln -s "$HOME/.config/.tmuxconf/.tmux.conf" "$HOME/.tmux.conf"

tmux source-file "$HOME/.tmux.conf"

echo "Setup completo!"
