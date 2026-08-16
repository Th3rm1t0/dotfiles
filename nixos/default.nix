{ lib, ... }:

let
  discoverModuleDirs =
    dir:
    map (name: dir + "/${name}") (
      builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir))
    );
in
{
  imports = discoverModuleDirs ./services;
}
