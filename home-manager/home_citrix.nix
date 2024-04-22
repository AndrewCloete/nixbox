{ inputs, config, pkgs, ... }:
let
  params = {
    user = "user";
    homeDirectory = "/home/user";
  };
in
{
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.sessionVariables = { };

  home.packages = [
    pkgs.awscli2
    pkgs.dust
    pkgs.nodejs-18_x
    pkgs.python310
    pkgs.nodePackages."aws-cdk"
    pkgs.openshift
    pkgs.ruff
  ];

  imports = [
    (import ./base.nix ({ inherit config pkgs params; }))
  ];
}
