{ inputs, config, pkgs, unstablePkgs, ... }:
let
  params = {
    user = "user";
    homeDirectory = "/home/user";
  };
in
{

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nodejs
    tree
    go
  ];

  imports = [
    (import ./base.nix ({ inherit config pkgs params unstablePkgs; }))
  ];
}
