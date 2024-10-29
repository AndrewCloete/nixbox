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

  home.packages = with pkgs; [
    kubectl
# Helm has plugins. The diff plugin is needed byt helmfile
# Luckilly, nixpkgs provide "wrapHelm" to easily add these
# https://nixos.wiki/wiki/Helm_and_Helmfile
    (wrapHelm kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-diff
        ];
      })
    helmfile
  ];

  imports = [
    (import ./base.nix ({ inherit config pkgs params; }))
    (import ./workstation.nix ({ inherit config pkgs params; }))
    ./extras.nix
  ];
}
