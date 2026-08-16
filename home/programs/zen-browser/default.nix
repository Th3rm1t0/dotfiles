{
  inputs,
  config,
  lib,
  ...
}:

{
  imports = [ inputs.zen-browser.homeModules.default ];

  options.dotfiles.programs.zen-browser.enable = lib.mkEnableOption "zen-browser" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.zen-browser.enable {
    programs.zen-browser.enable = true;
  };
}
