{ config, pkgs, ... }:
{
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";

  programs.git.settings = {
    gpg = {
      format = "ssh";
      ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
    };
    commit.gpgsign = true;
  };
}
