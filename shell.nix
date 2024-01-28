{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages;
    let
        ca65-symbls-to-nl = pkgs.stdenv.mkDerivation rec {
            name = "ca65-symbls-to-nl";
            version = "1.0";

            src = fetchFromGitHub {
                owner = "miracoly";
                repo = "ca65-symbls-to-nl";
                rev = "63d0c929bf02ae1db539eaf308654b4c2be39972";
                sha256 = "sha256-7Y/QBKnLa4YvoN3iolFLze8TyDvsgZMJgqD7ywoSYWY=";
            };

            DESTDIR = "$(out)";
        };
    in [
        cc65
        gnumake
        ca65-symbls-to-nl
    ];
}