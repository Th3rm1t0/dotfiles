{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.herdr.enable = lib.mkEnableOption "herdr" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.herdr.enable {
    home.packages = [ pkgs.herdr ];

    # Nix 管理下では herdr update --handoff が使えず、switch しても常駐 server は入れ替わらない。
    home.activation.herdrRestartCheck = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -S "$HOME/.config/herdr/herdr.sock" ]; then
        restartNeeded=$(${pkgs.herdr}/bin/herdr status server --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.restart_needed // false')
        if [ "$restartNeeded" = "true" ]; then
          echo "herdr: サーバーが古いバージョンのまま起動しています。都合の良いタイミングで 'herdr server stop' の後 'herdr' を実行してください。" >&2
        fi
      fi
    '';
  };
}
