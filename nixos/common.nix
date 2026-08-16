{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  users.users.th3rm1t3 = {
    shell = pkgs.zsh;
    extraGroups = [ "docker" ];
  };

  virtualisation.docker.enable = true;
}
