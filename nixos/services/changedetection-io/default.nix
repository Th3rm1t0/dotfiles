{ config, lib, ... }:

let
  cfg = config.dotfiles.services.changedetection-io;
in
{
  options.dotfiles.services.changedetection-io.enable = lib.mkEnableOption "changedetection-io";

  config = lib.mkIf cfg.enable {
    services.changedetection-io = {
      enable = true;
      listenAddress = lib.mkDefault "127.0.0.1";
      port = lib.mkDefault 49160;
      webDriverSupport = false;
      playwrightSupport = false;
    };

    systemd.services.changedetection-io = {
      serviceConfig.Environment = [
        "PLAYWRIGHT_DRIVER_URL=ws://127.0.0.1:3000"
      ];
      after = [ "podman-changedetection-io-sockpuppet.service" ];
      wants = [ "podman-changedetection-io-sockpuppet.service" ];
    };

    virtualisation.oci-containers.containers.changedetection-io-sockpuppet = {
      image = "dgtlmoon/sockpuppetbrowser";
      environment = {
        SCREEN_WIDTH = "1920";
        SCREEN_HEIGHT = "1024";
        MAX_CONCURRENT_CHROME_PROCESSES = "4";
      };
      ports = [ "127.0.0.1:3000:3000" ];
      extraOptions = [ "--network=bridge" ];
    };
  };
}
