{ pkgs, ... }:

{
    # 1Password CLI (op) は home-manager の programs.* 未対応のためパッケージとして導入する。
    home.packages = [ pkgs._1password-cli ];
}
