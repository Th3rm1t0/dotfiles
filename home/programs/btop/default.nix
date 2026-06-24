{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.btop.enable = lib.mkEnableOption "btop" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.btop.enable {
    programs.btop.enable = true;
  };
}
