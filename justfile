host := env("DOTFILES_HOST", "ubuntu-wsl")
username := env("DOTFILES_USER", "th3rm1t3")
config := username + "@" + host

default:
    @just --list

build:
    home-manager build --flake .#{{config}}

switch:
    home-manager switch --flake .#{{config}}

update:
    nix flake update

gc:
    nix-collect-garbage -d

check:
    nix flake check

fmt:
    nix fmt

lint:
    deadnix --exclude .claude .
    statix check --ignore [".claude/"]

fix:
    deadnix -e --exclude .claude .
    statix fix --ignore [".claude/"]
    nix fmt
