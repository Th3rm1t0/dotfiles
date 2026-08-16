{ config, lib, ... }:

{
  options.dotfiles.programs.rofi.enable = lib.mkEnableOption "rofi" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.rofi.enable {
    programs.rofi.enable = true;
  };
}
