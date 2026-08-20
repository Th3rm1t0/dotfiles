{ config, lib, ... }:

let
  cfg = config.dotfiles.services.changedetection-io;
in
{
  options.dotfiles.services.changedetection-io.enable = false;

}
