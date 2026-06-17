# 管理対象をここに集約し、flake.nix を肥大させない。
[
    { template = ./templates/example.yml.tpl; out = ".config/example/config.yml"; }
]
