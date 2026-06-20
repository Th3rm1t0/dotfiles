#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
export NIX_CONFIG="experimental-features = nix-command flakes"

install_nix() {
    if command -v nix &>/dev/null; then
        return
    fi
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
        | sh -s -- install --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}

resolve_config() {
    if [[ -n "${1:-}" ]]; then
        echo "$1"
        return
    fi
    local configs
    configs=$(grep -oE '"[^"]+" = home-manager\.lib' "${DOTFILES_DIR}/flake.nix" \
        | grep -oE '"[^"]+"' | tr -d '"')
    local count
    count=$(echo "$configs" | wc -l)
    if [[ "$count" -eq 1 ]]; then
        echo "$configs"
    else
        echo "Available configurations:" >&2
        echo "$configs" | sed 's/^/  /' >&2
        echo "Usage: $0 <config-name>" >&2
        exit 1
    fi
}

set_default_shell_to_zsh() {
    local zsh_path
    zsh_path="$(command -v zsh 2>/dev/null || true)"
    [[ -z "$zsh_path" ]] && return
    [[ "$SHELL" == "$zsh_path" ]] && return
    grep -qxF "$zsh_path" /etc/shells 2>/dev/null \
        || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    chsh -s "$zsh_path"
}

main() {
    install_nix

    local config
    config=$(resolve_config "${1:-}")
    echo "Applying: ${config}"
    nix run nixpkgs#home-manager -- switch --flake "${DOTFILES_DIR}#${config}"

    set_default_shell_to_zsh
}

main "$@"
