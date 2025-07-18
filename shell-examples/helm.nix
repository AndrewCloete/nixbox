{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "Helm";
  buildInputs = with pkgs; [
      helmfile
  ];

  shellHook = ''
    exec zsh
  '';
}

