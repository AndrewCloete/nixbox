{ config
, pkgs
, ...
}: {
  home.packages = [
    pkgs.awscli2
    pkgs.dust
    pkgs.ssm-session-manager-plugin
    pkgs.nodejs-18_x
    pkgs.python310
    pkgs.nodePackages."aws-cdk"
    pkgs.nodePackages.tiddlywiki
  ];
}
