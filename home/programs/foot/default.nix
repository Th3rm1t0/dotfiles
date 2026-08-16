{ config, lib, ... }:

{
  options.dotfiles.programs.foot.enable = lib.mkEnableOption "foot" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.foot.enable {
    programs.foot.enable = true;
  };
}
