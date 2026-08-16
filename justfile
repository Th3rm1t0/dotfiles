host := env("DOTFILES_HOST", `hostname`)
username := env("DOTFILES_USER", "th3rm1t3")
config := username + "@" + host

default:
    @just --list

build:
    nh home build . -c {{config}}

switch:
    nh home switch . -c {{config}}

os-build:
    nh os build . -H {{host}}

os-switch:
    nh os switch . -H {{host}}

update:
    nix flake update

gc:
    nix-collect-garbage -d

check:
    nix flake check

fmt:
    nix fmt $(git ls-files -- '*.nix')

lint:
    deadnix --exclude .claude .
    statix check --ignore .claude/ .

fix:
    deadnix -e --exclude .claude .
    statix fix --ignore .claude/ .
    nix fmt $(git ls-files -- '*.nix')
