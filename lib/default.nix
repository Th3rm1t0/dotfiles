{ inputs, pkgsFor, ... }:

{
  mkHome =
    {
      hostname,
      system ? "x86_64-linux",
      username ? "th3rm1t3",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor system;
      extraSpecialArgs = {
        inherit inputs;
        self = inputs.self;
      };
      modules = [
        inputs.catppuccin.homeManagerModules.catppuccin
        inputs.op-shell-plugins.hmModules.default
        ../hosts/${hostname}.nix
      ];
    };
}
