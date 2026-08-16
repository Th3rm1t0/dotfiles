{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "th3rm1t3" ];
  };

  programs.hyprland.enable = true;

  # ログイン
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
      user = "greeter";
    };
  };

  services.fwupd.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";
    fonts.monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
  };
}
