{ lib, pkgs, ... }:

{
  imports = [
    ../common.nix
    ../roles/wsl.nix
  ];

  home = {
    username = "th3rm1t3";
    homeDirectory = "/home/th3rm1t3";
  };

  targets.genericLinux.enable = true;

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

  home.activation.setDefaultShell =
    let
      zshPath = "$HOME/.nix-profile/bin/zsh";
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      currentShell=$(grep "^$USER:" /etc/passwd | cut -d: -f7)
      if [ "$currentShell" != "${zshPath}" ]; then
        if ! grep -qxF "${zshPath}" /etc/shells 2>/dev/null; then
          echo "${zshPath}" | /usr/bin/sudo tee -a /etc/shells >/dev/null
        fi
        /usr/bin/sudo chsh -s "${zshPath}" "$USER"
      fi
    '';
}
