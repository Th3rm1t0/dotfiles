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
        statusJson=$(${pkgs.herdr}/bin/herdr status --json 2>/dev/null)
        body=$(printf '%s' "$statusJson" | ${pkgs.jq}/bin/jq -r \
          'if .update.restart_needed then "server: \(.server.version) / client: \(.client.version)\nherdr server stop && herdr" else empty end')
        if [ -n "$body" ]; then
          title="herdr サーバーの更新待ち"
          echo "$title: $body" >&2
          if command -v notify-send >/dev/null 2>&1; then
            notify-send -u normal "$title" "$body" || true
          fi
        fi
      fi
    '';
  };
}
