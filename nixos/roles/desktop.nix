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

  # 日本語入力: fcitx5 + mozc。
  # Hyprland は wlroots 系コンポジタで text-input-v3 / input-method-v2 を
  # サポートしており、foot をはじめとするネイティブ Wayland アプリと
  # 相性が良い fcitx5 の waylandFrontend を使う。ibus は Wayland 対応が
  # 弱く、kime は韓国語向けで日本語変換エンジンを持たないため見送った。
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [ pkgs.fcitx5-mozc ];
      settings.inputMethod = {
        "GroupOrder"."0" = "Default";
        "Groups/0" = {
          "Name" = "Default";
          "Default Layout" = "us";
          "DefaultIM" = "keyboard-us";
        };
        "Groups/0/Items/0"."Name" = "keyboard-us";
        "Groups/0/Items/1"."Name" = "mozc";
      };
    };
  };

  # waylandFrontend を有効にすると GTK_IM_MODULE / QT_IM_MODULE は
  # 自動設定されない（ネイティブプロトコルを使わない XWayland アプリ・
  # GTK3/Qt5 アプリ向けに必要なため明示する）。
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
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
