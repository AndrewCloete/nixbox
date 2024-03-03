# nix-shell --run zsh

with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "node";
  buildInputs = [
    nodejs-18_x
    pkgs.python310
  ];
  shellHook = ''
    export PATH="$PWD/node_modules/.bin/:$PATH"
  '';
}


