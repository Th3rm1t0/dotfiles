{ pkgs }:

let
    inherit (pkgs) lib;
    secrets = import ./secrets.nix;

    # op inject は親ディレクトリを作らないため先に作る
    renderOne = s: ''
        install -d -m700 "$(dirname "$HOME/${s.out}")"
        op inject -f -i ${s.template} -o "$HOME/${s.out}"
    '';

    script = pkgs.writeShellApplication {
        name = "render-secrets";
        runtimeInputs = [ pkgs._1password-cli ];
        text = lib.concatMapStrings renderOne secrets;
    };
in
{
    render-secrets = {
        type = "app";
        program = "${script}/bin/render-secrets";
    };
}
