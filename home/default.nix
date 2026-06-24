{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.agent-skills.homeManagerModules.default
    ./programs/claude-code
    ./programs/hermes-agent
    ./programs/fzf
    ./programs/starship
    ./programs/zsh
    ./programs/direnv
    ./programs/delta
    ./programs/zoxide
    ./programs/lazygit
    ./programs/btop
    ./programs/dust
    ./programs/hyperfine
    ./programs/gh
    ./programs/1password
    ./programs/tmux
  ];

  programs.home-manager.enable = true;

  # Nix
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = true;
    };
  };
}
