{ config
, pkgs
, params
, ...
}: {

  home.packages = with pkgs; [
    watchexec
    ts
  ];

  programs.zsh.shellAliases = {
    tbx = "cd ${params.dir_tbx}";
    hm = "cd ${params.homeDirectory}/nixbox/home-manager";
    nb = "cd ${params.dir_nb}";
    rzsh = ". ${params.homeDirectory}/.zshrc";
    dm = "node ${params.homeDirectory}/Workspace/digemy/digemy.devops/cli/dist/cli.js";
    "in" = "nvim ${params.dir_nb}/tiddly/tiddlers/Inbox.md";
  };

}
