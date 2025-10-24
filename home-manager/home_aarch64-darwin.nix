{ inputs, config, pkgs, unstablePkgs, ... }:
let
  params = rec {
    user = "user";
    homeDirectory = "/Users/user";
    dir_tbx = "${params.homeDirectory}/toolbox";
    dir_nb = "${params.homeDirectory}/Workspace/journals/notebook";
    dir_se = "${params.homeDirectory}/Workspace/journals/spatialedge";
    dir_vulture = "${params.homeDirectory}/Vulture";
  };

  customYarnShim = pkgs.writeShellScriptBin "yarn" ''
    exec "${pkgs.nodejs}/bin/node" "${pkgs.nodejs}/bin/corepack" yarn "$@"
  '';
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
    serverless
    maven
    jdk17
    # jdk8
    # jdk11
    ansible
    php81
    php81Packages.composer
    ruff
    qmk
    hey
    pre-commit
    copier
    exercism
    zig
    ffmpeg
    yt-dlp
    gifsicle
    pkgs."kubernetes-helm"
    imagemagick
    zola
    cloudflared
    customYarnShim
    caddy
    grpcurl
    nixpacks
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".aerospace.toml" = {
      source = ./aerospace/aerospace.toml;
      recursive = true;
    };
    ".config/alacritty/alacritty.toml" = {
      source = ./alacritty/alacritty.toml;
      recursive = true;
    };
  };

  home.sessionVariables = { };
  home.sessionPath = [
    # "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    # "/Applications/Meld.app/Contents/MacOS"
    "/Users/user/Workspace/spatialedge/bin"
  ];

  programs.zsh = {
    shellAliases = {
      se = "cd ${params.dir_se}";
      awsl = "${params.homeDirectory}/Vulture/aws/vodacom-aws-auth/.venv/bin/python ${params.homeDirectory}/Vulture/aws/vodacom-aws-auth/aws_auth.py";
      "rts-env" = "source ${params.dir_vulture}/aws/rts/rts-lib/packages/vodacom_rts_cdk/scripts/rts-env.sh";
      "rts-env-pip" = "source ${params.dir_vulture}/aws/rts/rts-lib/packages/vodacom_rts_cdk/scripts/rts-env-pip.sh";
      "ccc" = "while [ $? -eq 0 ]; do echo keychain clean; security delete-internet-password -l git-codecommit.eu-west-1.amazonaws.com 2>&1 > /dev/null ; done";
      "kwrap" = "source ${params.homeDirectory}/nixbox/home-manager/bin/gke_wrap.sh" ;
    };


    # Install gcloud using the official method (i.e. not nix) https://cloud.google.com/sdk/docs/install
    initExtra = ''
      # gcloud autocomplete and $PATH addition
      source /Users/user/Downloads/google-cloud-sdk/completion.zsh.inc
      source /Users/user/Downloads/google-cloud-sdk/path.zsh.inc
    '';
  };

  imports = [
    (import ./workstation.nix ({ inherit config pkgs params; }))
    (import ./extras.nix ({ inherit config pkgs params; }))
    (import ./picosdk.nix ({ inherit config pkgs params; }))
    (import ./base.nix ({ inherit config pkgs params unstablePkgs; }))
  ];
}
