# !bin/bash

set -euo pipefail

while [[ $# -gt 0 ]]; do
  case $1 in
    --user)
      USERNAME="$2"
      shift 2
      ;;
    --host)
      HOSTNAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
done

NIX_CONFIG="experimental-features = nix-command flakes"

nix run nixpkgs#home-manager -- switch --flake .#$USERNAME@$HOSTNAME

# Set zsh as the default shell
ZSH_PATH="$(which zsh)"
sudo sh -c "echo $ZSH_PATH >> /etc/shells"
chsh -s "$ZSH_PATH"
