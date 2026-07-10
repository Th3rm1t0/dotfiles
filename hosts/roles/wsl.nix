{ pkgs, ... }:
{
  # Windows 側の 1Password SSH agent を ssh.exe 経由で使う
  # (NixOS-WSL でも interop / appendWindowsPath はデフォルト有効)
  programs.git.settings.core = {
    autocrlf = "input";
    sshCommand = "ssh.exe";
  };

  # wslu (wslview) は nixpkgs から消えているため、
  # Windows 側の URL ハンドラを直接叩くラッパーで代替
  home.packages = [
    (pkgs.writeShellScriptBin "wslview" ''
      exec /mnt/c/Windows/System32/rundll32.exe url.dll,FileProtocolHandler "$@"
    '')
  ];
  home.sessionVariables.BROWSER = "wslview";
}
