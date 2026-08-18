{ config, lib, ... }:

{
  options.dotfiles.programs.kitty.enable = lib.mkEnableOption "kitty" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.kitty.enable {
    programs.kitty.enable = true;
  };
}
