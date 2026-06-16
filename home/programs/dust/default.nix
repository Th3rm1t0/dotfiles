{ pkgs, ... }:

{
    # dust は home-manager の programs.* 未対応のためパッケージとして導入する。
    home.packages = [ pkgs.dust ];
}
