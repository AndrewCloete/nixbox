# For all options see https://nix-community.github.io/home-manager/options.xhtml
{ config
, pkgs
, params
, ...
}: {

  # These 2 lines replaces the need to define a "~/.config/nix/nix.conf" and
  # set the "experimental-features, flake" flag in there. This creates that
  # file and sets the flag to enable "flakes". Not tested yet so leaving it in
  # the README for now.
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = params.user;
  home.homeDirectory = "${params.homeDirectory}";

  # The home.packages option allows you to install Nix packages into your
  # environment.lua print(vim.inspect(vim.lsp.get_active_clients()))
  home.packages = with pkgs; [
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
    gnupg
    git
    lazygit
    unzip
    wget
    xh
    curl
    htop
    btop
    tldr
    eza
    fd
    ripgrep
    jq
    yq
    rustup # run `rustup default stable` to install rustc and cargo
    lua
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

    # Copies my set of sh scripts nice for a workstation
    "./.config/bin/" = {
      source = ./bin;
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
    "${params.homeDirectory}/.cargo/bin"
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

  programs.tmux = {
    enable = true;
    sensibleOnTop = false; # Don't use "sensible" plugin. Causes "reattach-to-user..." issue
    clock24 = true;
    customPaneNavigationAndResize = true;
    extraConfig = ''
      		  ${builtins.readFile ./tmux/tmux.conf}
      	  '';
  };

  programs.zsh = {
    # See README.md on how to set as default shell with chsh
    enable = true;
    enableCompletion = true;
    history.share = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = false; # Warning, makes paste slow

    # This is the suggested workaround for the issue where the zsh PATH is
    # overwritten. Hopefully fixed somewhere in the future. See
    # https://github.com/nix-community/home-manager/issues/2991
    # For some reason, sessionVariables do not work.. so we force them here.
    # profileExtra = pkgs.lib.optionalString (config.home.sessionPath != [ ]) ''
    #   export PATH="$PATH''${PATH:+:}${pkgs.lib.concatStringsSep ":" config.home.sessionPath}"
    # '';

    # The below is my own hack to try and fix the issue where
    # home.sessionVariables does not have any effect. But I also think it fixes
    # the issue above regarding the PATH being overwritten. Not sure yet, we'll
    # need to see after a restart
    initExtra = ''
      unset __HM_SESS_VARS_SOURCED
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      source ~/.config/bin/functions.sh
    '';

    shellAliases = {
      v = "nvim";
      t = "tmux";
      x = "exit";
      lg = "lazygit";
      ll = "ls -l";
      ls = "eza --icons --git --long";
      lt = "eza --tree --level=2 --long --icons --git";
      gtd = "gtd-cli";
      i = "gtd-inbox";
      dc = "docker-compose";
      dcud = "docker-compose up -d";
      dcb = "docker-compose build";
      dck = "docker-compose kill";
      dcs = "docker-compose stop";
      dcdv = "docker-compose down -v";
      dcl = "docker-compose logs";
      dclt = "docker-compose logs --tail=100";
      gs = "git stash";
      gsp = "git stash pop";
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
    defaultKeymap = "viins"; # vim mode
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
