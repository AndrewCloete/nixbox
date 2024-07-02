{ config
, pkgs
, ...
}:
{
  home.packages = [
    pkgs.awscli2
    pkgs.dust
    pkgs.ssm-session-manager-plugin
    pkgs.python310
    pkgs.nodejs-18_x
    pkgs.nodePackages."aws-cdk"
    pkgs.nodePackages.tiddlywiki
    # pkgs.terraform
  ];
}
