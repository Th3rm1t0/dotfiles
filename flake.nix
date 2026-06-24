{
  description = "Th3rm1t3 dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix"; # claude-code の最新版への追従のため
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent"; # Hermes Agent (Nous Research) の導入のため
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
          # overlays = builtins.attrValues self.overlays;
        };
    in
    {
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
            ];
          };
        }
      );

      # Custom packages
      # packages = forAllSystems (system: import ./pkgs (pkgsFor system));

      # Overlays
      # overlays = import ./overlays { inherit inputs; };

      # home-manager
      homeConfigurations = {
        "th3rm1t3@ubuntu-wsl" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          extraSpecialArgs = { inherit inputs self; };
          modules = [
            ./hosts/ubuntu-wsl.nix
          ];
        };
      };

    };
}
