{ lib, ... }:

let
  serviceDirs = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./services)
  );
in
{
  imports = map (name: ./services/${name}) serviceDirs;
}
