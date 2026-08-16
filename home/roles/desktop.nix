_: {
  fonts.fontconfig.enable = true;

  dotfiles.programs = {
    foot.enable = true;
    rofi.enable = true;
    waybar.enable = true;
    hyprland.enable = true;
  };

  # Hyprland 0.55 で設定形式が hyprlang から Lua へ移行中で、Stylix / home-manager の
  # 対応が追従途上のため、Hyprland の配色のみ Stylix の自動適用対象から外し、
  # home-manager 側で config.lib.stylix.colors を手動参照する。移行が安定したら
  # 元に戻す一時対応。
  #
  # stylix.targets.hyprland は Stylix の NixOS モジュールが home-manager 側へ
  # 転送した場合にのみ存在するオプションのため、Stylix を有効化しない WSL ホストにも
  # 無条件 import される home/programs/hyprland ではなく、Stylix を有効化する
  # ホストだけが import する desktop role 側に置く。
  stylix.targets.hyprland.enable = false;
}
