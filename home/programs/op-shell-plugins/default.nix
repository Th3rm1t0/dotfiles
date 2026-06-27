{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.op-shell-plugins.enable =
    lib.mkEnableOption "1Password shell plugins"
    // {
      default = true;
    };

  config = lib.mkIf config.dotfiles.programs.op-shell-plugins.enable {
    programs._1password-shell-plugins = {
      enable = true;
      plugins = [ ];
    };
  };
}
