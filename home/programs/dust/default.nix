{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.dust.enable = lib.mkEnableOption "dust" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.dust.enable {
    home.packages = [ pkgs.dust ];
  };
}
