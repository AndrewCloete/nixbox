{ inputs, config, pkgs, ... }:
let
  params = {
    user = "user";
    homeDirectory = "/home/user";
    dir_vulture = "${params.homeDirectory}/Workspace";

  };
in
{
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.sessionVariables = { };

  home.file = {
    ".config/alacritty/alacritty.toml" = {
      source = ./alacritty/alacritty.toml;
      recursive = true;
    };
  };


  home.packages = with pkgs ; [
    pkgs.maven
    pkgs.jdk17
    pkgs.awscli2
    pkgs.dust
    pkgs.nodejs-18_x
    pkgs.nodePackages."aws-cdk"
    pkgs.openshift
    pkgs.ruff
    pkgs.hey
    pkgs."kubernetes-helm"
    pkgs.glab
    pkgs.mongosh
    pkgs.watchexec
    pkgs.duckdb
  ];

  programs.zsh.shellAliases = {
    "rts-env" = "source ${params.dir_vulture}/aws/rts/rts-lib/packages/vodacom_rts_cdk/scripts/rts-env.sh";
    "rts-env-pip" = "source ${params.dir_vulture}/aws/rts/rts-lib/packages/vodacom_rts_cdk/scripts/rts-env-pip.sh";
  };


  imports = [
    (import ./base.nix ({ inherit config pkgs params; }))
  ];
}
