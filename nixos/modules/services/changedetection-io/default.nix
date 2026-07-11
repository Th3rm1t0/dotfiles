{ config, lib, ... }:

let
  cfg = config.dotfiles.services.changedetection-io;
in
{
  options.dotfiles.services.changedetection-io.enable = lib.mkEnableOption "changedetection-io";

  config = lib.mkIf cfg.enable {
    services.changedetection-io = {
      enable = true;
      # WSL2 の localhost forwarding で Windows ブラウザから届く
      listenAddress = lib.mkDefault "127.0.0.1";
      port = lib.mkDefault 5000;
    };
  };
}
