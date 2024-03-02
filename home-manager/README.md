# Getting started
Bootstrap by running a home-manager shell. Home-manager manages itself meaning
after the first `home-manager switch` it will be installed along with all your
other packager which means you won't need this dev shell again to run it.

```sh
nix-shell -p home-manager
```
Don't run `home-manager init` since you want to use the flake define in the repo.
Instead, To install for user "user" from current directory:
```sh
home-manager switch --flake .#user
```

```sh
# This assumes the flake is in the default ~/.config/home-manager location
# which is not what we want to do right now
home-manager switch
```

# Quick-ref
```sh
man home-configuration.nix
```

# Concepts
## Introduction
https://www.youtube.com/watch?v=FcC2dzecovwho

## First-class programs support
The `programs` output in `home.nix` are packages for which `home-manager`
**offers first-class support**. So instead of defining a package in `pkgs`, you
can define them under `programs` and then use nix language to configure it.
What `home-manager` does during the `switch` is then to generate the
apporpriate config files for those programs and put them in the right directory
so you don't have to For exmple here is how to configure `neovim` using
`home-manager` https://www.youtube.com/watch?v=YZAnJ0rwREA



