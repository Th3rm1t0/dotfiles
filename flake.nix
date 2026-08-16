{
  description = "Th3rm1t3 dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      # inputs.nixpkgs.follows はあえて設定しない。
      # lanzaboote は自前で固定した nixpkgs/Rust ツールチェーンでビルドされており、
      # ここを unstable に追従させると、手元の nixpkgs が進んだ時点で
      # Rust/cargo のビルドが壊れる不具合が過去に報告されている。
      # 追従させない分システムクロージャは多少大きくなるが、安定性を優先する。
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    op-shell-plugins = {
      url = "github:1Password/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills.url = "path:./inputs/skills";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Helper to make common pkgs available
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = builtins.attrValues self.overlays;
        };
      lib = import ./lib { inherit inputs pkgsFor; };
    in
    {
      overlays = import ./overlays { inherit inputs; };

      packages = forAllSystems (system: import ./pkgs (pkgsFor system));
      formatter = forAllSystems (system: (pkgsFor system).nixfmt);

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt
              deadnix
              statix
              just
              nh
            ];
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          formatting =
            pkgs.runCommand "check-formatting"
              {
                nativeBuildInputs = [
                  pkgs.nixfmt
                  pkgs.findutils
                ];
              }
              ''
                find ${self} -name '*.nix' -exec nixfmt --check {} + && touch $out
              '';

          deadnix = pkgs.runCommand "check-deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
            deadnix --fail --exclude .claude ${self} && touch $out
          '';

          statix = pkgs.runCommand "check-statix" { nativeBuildInputs = [ pkgs.statix ]; } ''
            statix check --ignore [".claude/"] ${self} && touch $out
          '';
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = {
            type = "app";
            program =
              let
                bootstrap = pkgs.writeShellApplication {
                  name = "dotfiles-bootstrap";
                  runtimeInputs = [ inputs.home-manager.packages.${system}.default ];
                  text = ''
                    config="''${1:-th3rm1t3@$(hostname)}"
                    echo "Applying: $config"
                    home-manager switch --flake "${self}#$config"
                  '';
                };
              in
              "${bootstrap}/bin/dotfiles-bootstrap";
          };
        }
      );

      homeConfigurations = {
        "th3rm1t3@ubuntu-wsl" = lib.mkHome { hostname = "ubuntu-wsl"; };
      };

      nixosConfigurations = {
        triton = lib.mkNixos {
          hostname = "triton";
          extraModules = [ inputs.nixos-wsl.nixosModules.default ];
        };
        mars = lib.mkNixos {
          hostname = "mars";
        };
      };
    };
}
