{ inputs, config, pkgs, ... }:
let
  params = {
    user = "capealoe";
    homeDirectory = "/home/capealoe";
  };
in
{
  home.stateVersion = "23.11"; # Please read the comment before changing.
  imports = [
    (import ./base.nix ({ inherit config pkgs params; }))
  ];
}
