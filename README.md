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
