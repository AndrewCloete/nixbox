{ inputs, config, pkgs, ... }:
let
  params = {
    user = "user";
    homeDirectory = "/Users/user";
  };
  dir_tbx = "${params.homeDirectory}/toolbox";
  dir_nb = "${params.homeDirectory}/Workspace/notebook";
  dir_se = "${params.homeDirectory}/Workspace/spatialedge";
  dir_vulture = "${params.homeDirectory}/Vulture";
in
{

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    watchexec
    maven
    jdk17
    ansible
    ts
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = { };
  home.sessionPath = [
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    "/Applications/Meld.app/Contents/MacOS"
  ];

  programs.zsh.shellAliases = {
    tbx = "cd ${dir_tbx}";
    hm = "cd ${params.homeDirectory}/nixbox/home-manager";
    nb = "cd ${dir_nb}";
    se = "cd ${dir_se}";
    awsl = "${dir_se}/scripts/vodacom-aws-auth/env/bin/python ${dir_se}/scripts/vodacom-aws-auth/aws_auth.py";
    "rts-env" = "source ${dir_vulture}/aws/rts/rts-lib/packages/vodacom_rts_cdk/scripts/rts-env.sh";
    "rts-env-pip" = "source ${dir_vulture}/aws/rts/rts-lib/packages/vodacom_rts_cdk/scripts/rts-env-pip.sh";
    "in" = "nvim ${dir_nb}/tiddly/tiddlers/Inbox.md";
    rzsh = ". ${params.homeDirectory}/.zshrc";
    dm = "node ${params.homeDirectory}/Workspace/digemy/digemy.devops/cli/dist/cli.js";
  };

  imports = [
    (import ./base.nix ({ inherit config pkgs params; }))
    ./extras.nix
  ];
}
