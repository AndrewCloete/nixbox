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
    tbx = "cd ${dir_tbx}";
    hm = "cd ${params.homeDirectory}/nixbox/home-manager";
    nb = "cd ${dir_nb}";
    rzsh = ". ${params.homeDirectory}/.zshrc";
    dm = "node ${params.homeDirectory}/Workspace/digemy/digemy.devops/cli/dist/cli.js";
    "in" = "nvim ${dir_nb}/tiddly/tiddlers/Inbox.md";
  };

}
