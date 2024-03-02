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


