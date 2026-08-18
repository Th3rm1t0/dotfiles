{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  # nwg-hello 自体は greetd の子プロセスとして直接動くのではなく、Wayland
  # コンポジタ上で動く GUI アプリのため、専用の最小構成 Hyprland を greeter
  # セッションとして起動する。exec-once はシェル経由で実行され、greetd の
  # systemd ユニットが持つ PATH には /run/current-system/sw/bin が含まれない
  # ため、バイナリは絶対パスで指定する。

  # nwg-hello は /etc/nwg-hello 相当の設定ファイルを自身の Nix store パスに
  # 埋め込んでおり、実行時に外から上書きできない（NixOS では /etc/nwg-hello
  # という実パスも存在しない）。そのため設定は -c で明示的に渡す。
  #
  # デフォルト設定の session_dirs は /run/current-system/sw/share/{wayland-
  # sessions,xsessions} を指すが、NixOS ではセッション .desktop 群はそのパスに
  # 存在せず、services.displayManager.sessionData.desktops というビルドごと
  # に生成される store パスの下に置かれ、XDG_DATA_DIRS 経由でのみ公開され
  # る（greetd 経由の起動ではこの環境変数が効かない）。そのため実際の
  # generation が持つパスを直接渡す。
  #
  # デフォルトの custom_sessions（"Shell": "/usr/bin/bash"）も FHS 前提の
  # パスで NixOS には存在しないため、実際の store パスに差し替える。
  nwgHelloConfig = pkgs.writeText "nwg-hello.json" (
    builtins.toJSON {
      session_dirs = [
        "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
        "${config.services.displayManager.sessionData.desktops}/share/xsessions"
      ];
      custom_sessions = [
        {
          name = "Shell";
          exec = "${pkgs.bash}/bin/bash";
        }
      ];
    }
  );

  greeterHyprConf = pkgs.writeText "nwg-hello-hyprland.conf" ''
    monitor=,preferred,auto,1
    misc {
        disable_hyprland_logo = true
    }
    animations {
        enabled = false
    }
    exec-once = ${lib.getExe pkgs.nwg-hello} -c ${nwgHelloConfig}; ${pkgs.hyprland}/bin/hyprctl dispatch exit
  '';
in
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
  #
  # Hyprland バイナリを直接起動すると "launched without start-hyprland" と
  # 警告が出る。start-hyprland は Hyprland 本体を watchdog 経由で正しく
  # 起動するためのラッパーで、-- 以降の引数が Hyprland にそのまま渡される。
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.hyprland}/bin/start-hyprland -- --config ${greeterHyprConf}";
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
  # サポートしており、これらのプロトコルに対応した Wayland アプリと
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
    # デフォルトは fonts.sizes.applications (12pt) を継承するが、
    # ターミナルの文字が大きく感じられたため明示的に縮小する。
    fonts.sizes.terminal = 9;
  };
}
