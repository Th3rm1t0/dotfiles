{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.zoxide.enable = lib.mkEnableOption "zoxide" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
