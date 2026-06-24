{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.delta.enable = lib.mkEnableOption "delta" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.delta.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
  };
}
