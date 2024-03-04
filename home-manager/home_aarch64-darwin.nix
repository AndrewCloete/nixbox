{ inputs, config, pkgs, ... }:
let
  homeDirectory = "/Users/user";
  dir_tbx = "${homeDirectory}/toolbox";
  dir_nb = "${homeDirectory}/Workspace/notebook";
  dir_se = "${homeDirectory}/Workspace/spatialedge";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "user";
  home.homeDirectory = "${homeDirectory}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.lua print(vim.inspect(vim.lsp.get_active_clients()))
  home.packages = with pkgs; [
    git
    rustup
    eza
    fd
    ripgrep
    xh
    watchexec

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    # Copies in the neovim directory as is
    # See program.neovim on how it is used
    "./.config/nvim/" = {
      source = ./nvim;
      recursive = true;
    };

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/user/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.sessionPath = [
    "${homeDirectory}/.cargo/bin"
  ];



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ":luafile ~/.config/nvim/init.lua";
    extraPackages = [ pkgs.gcc pkgs.stylua ];
  };

  programs.git = {
    enable = true;
    userName = "user";
    userEmail = "user@gmail.com";
  };

  programs.zsh = {
    # See README.md on how to set as default shell with chsh
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    # This is the suggested workaround for the issue where the zsh PATH is
    # overwritten. Hopefully fixed somewhere in the future. See
    # https://github.com/nix-community/home-manager/issues/2991
    profileExtra = pkgs.lib.optionalString (config.home.sessionPath != [ ]) ''
      export PATH="$PATH''${PATH:+:}${pkgs.lib.concatStringsSep ":" config.home.sessionPath}"
    '';

    shellAliases = {
      tbx = "cd ${dir_tbx}";
      hm = "cd ${homeDirectory}/nixbox/home-manager";
      nb = "cd ${dir_nb}";
      se = "cd ${dir_se}";
      "in" = "nvim ${dir_nb}/tiddly/tiddlers/Inbox.md";
      rzsh = ". ${homeDirectory}/.zshrc";
      dm = "node ${homeDirectory}/Workspace/digemy/digemy.devops/cli/dist/cli.js";
      x = "exit";
      ll = "ls -l";
      ls = "eza --icons --git --long";
      lt = "eza --tree --level=2 --long --icons --git";
      gtd = "gtd-cli";
      dc = "docker-compose";
      dcud = "docker-compose up -d";
      dcb = "docker-compose build";
      dck = "docker-compose kill";
      dcs = "docker-compose stop";
      dcdv = "docker-compose down -v";
      dcl = "docker-compose logs";
      dclt = "docker-compose logs --tail=100";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    plugins = [
      {
        # This installs the p10k ZSH plugin from the nix packages store
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        # This install my p10k ZSH config from local directory
        name = "powerlevel10k-config";
        src = pkgs.lib.cleanSource ./zsh/p10k-config;
        file = "p10k.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      # git plugin also adds short aliases by default
      plugins = [ "git" ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    sensibleOnTop = false; # Don't use "sensible" plugin. Causes "reattach-to-user..." issue
    clock24 = true;
    extraConfig = ''
      		  ${builtins.readFile ./tmux/tmux.conf}
      	  '';
  };

  imports = [ ./extras.nix ];

}
