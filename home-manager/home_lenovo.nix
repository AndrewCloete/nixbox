{ inputs, config, pkgs, ... }:
let
  params = rec {
    user = "user";
    homeDirectory = "/home/user";
    dir_tbx = "${params.homeDirectory}/toolbox";
    dir_nb = "${params.homeDirectory}/Workspace/notebook";
  };
in
{
  home.stateVersion = "23.11"; # Please read the comment before changing.



  imports = [
    (import ./base.nix ({ inherit config pkgs params; }))
    (import ./workstation.nix ({ inherit config pkgs params; }))
    ./extras.nix
  ];
}
