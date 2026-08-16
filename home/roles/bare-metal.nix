{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";

  xdg.configFile."git/allowed_signers".text =
    "80260010+Th3rm1t0@users.noreply.github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPit0XMIE0xrI2ZdX2R94TbvDE+B4V1bEUb18HAAAQQA GitHub\n";

  programs.git.settings = {
    gpg = {
      format = "ssh";
      ssh = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
      };
    };
    user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPit0XMIE0xrI2ZdX2R94TbvDE+B4V1bEUb18HAAAQQA GitHub";
    commit.gpgsign = true;
  };
}
