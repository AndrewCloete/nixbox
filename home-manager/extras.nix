{ config
, pkgs
, ...
}: {
  home.packages = [
    pkgs.awscli2
    pkgs.nodejs-18_x
    pkgs.python310
    pkgs.nodePackages."aws-cdk"
  ];
}
