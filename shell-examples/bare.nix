{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "Some name";
  buildInputs = [
    # Add any other build tools needed, e.g., pkgs.typescript
  ];

  shellHook = ''
    exec zsh
  '';
}

