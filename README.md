# Proxy for `sudo` environment
You need this if you are installing single-user mode on WSL behind a proxy
In `/etc/sudoers`, add the following line to pass through the proxy env vars
```
Defaults	env_keep+="http_proxy ftp_proxy all_proxy https_proxy no_proxy" # Add this line
```

# Install nix
```sh
# Multi-user install
sh <(curl -L https://nixos.org/nix/install) --daemon

# Single-user install (required by platforms that don't have a systemd e.g. WSL)
# Remember to set your proxy vars before running
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```


Activate experimental-features
```sh
vim /etc/nix/nix.conf
# or for single-user install
vim ~/.config/nix/nix.conf
"""
experimental-features = nix-command flakes
"""
```

If you installed as `su`, you can enable nix for other users by
```sh
echo ". /etc/profile.d/nix.sh" >> /etc/profile
```

Check for at least one channel and add if none
```sh
# If the channel list is empty...
nix-channel --list

# .. you can add one like this
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update
```

# Ops
```sh
# Upgrade
nix flake upgrade

# Garbage collect
nix-collect-garbage -d
```
