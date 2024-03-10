Install nix
```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Activate experimental-features
```sh
vim /etc/nix/nix.conf
"""
experimental-features = nix-command flakes
"""
```
