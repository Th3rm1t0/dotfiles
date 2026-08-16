{ inputs, pkgsFor, ... }:

{
  mkHome =
    {
      hostname,
      system ? "x86_64-linux",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor system;
      extraSpecialArgs = {
        inherit inputs;
        inherit (inputs) self;
      };
      modules = [
        ../home/hosts/${hostname}.nix
      ];
    };

  mkNixos =
    {
      hostname,
      system ? "x86_64-linux",
      username ? "th3rm1t3",
      extraModules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit (inputs) self;
      };
      modules = [
        ../nixos/common.nix
        ../nixos
        ../nixos/hosts/${hostname}
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = builtins.attrValues inputs.self.overlays;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              inherit (inputs) self;
            };
            users.${username} = import ../home/hosts/${hostname}.nix;
          };
        }
      ]
      ++ extraModules;
    };
}
