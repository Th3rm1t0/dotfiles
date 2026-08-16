{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    # lanzaboote は systemd-boot モジュールを置き換える
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      # systemd-boot が mkForce false されており、configurationLimit の
      # 継承元が暗黙的になっているため明示する。ESP が 1GiB しかなく
      # 世代が溢れると実害が出る。
      configurationLimit = 10;
    };
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        configurationLimit = 10; # ESP 1GiB
      };
      efi.canTouchEfiVariables = true;
    };
  };

  security.tpm2.enable = true;
  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.tpm2-tools
  ];
}
