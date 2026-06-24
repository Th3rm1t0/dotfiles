{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.lazygit.enable = lib.mkEnableOption "lazygit" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.lazygit.enable {
    programs.lazygit.enable = true;
  };
}
