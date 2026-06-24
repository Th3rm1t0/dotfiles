{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  programDirs = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./programs)
  );
in
{
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ] ++ map (name: ./programs/${name}) programDirs;

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = true;
    };
  };
}
