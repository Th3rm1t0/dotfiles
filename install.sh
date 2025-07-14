#!/bin/bash

set -e

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# OS の判定
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# 必要なツールのインストール
install_tools() {
    local os=$(detect_os)
    
    case $os in
        macos)
            log_info "Installing tools for macOS..."
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install zsh starship neovim mise wezterm 1password-cli
            ;;
        linux)
            log_info "Installing tools for Linux..."
            sudo apt update
            sudo apt install -y zsh curl wget git build-essential
            
            # Starship
            curl -sS https://starship.rs/install.sh | sh
            
            # Neovim
            sudo apt install -y neovim
            
            # mise
            curl https://mise.jdx.dev/install.sh | sh
            SHELL_NAME=$(basename $SHELL)
            RC_FILE="$HOME/.${SHELL_NAME}rc"
            echo 'eval "$(mise activate)"' >> "$RC_FILE"
            source "$RC_FILE"

            # 1Password CLI
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
            sudo apt update && sudo apt install -y 1password-cli
            ;;
        *)
            log_error "Unsupported OS: $OSTYPE"
            exit 1
            ;;
    esac
}

# mise でツールをインストール
mise_install() {
    mise install
}

# zsh を デフォルトシェルに設定
setup_zsh() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting zsh as default shell..."
        chsh -s $(which zsh)
        log_warn "Please restart your terminal or run 'exec zsh' to use zsh"
    fi
}

# メイン実行
main() {
    log_info "Starting dotfiles installation..."
    
    install_tools
    setup_zsh
    mise_install
    
    log_info "Installation completed!"
    log_info "Please restart your terminal and run 'chezmoi apply' to apply configurations"
}

main "$@"

