# shell.nix
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  # Specify the Node.js version you need
  buildInputs = [
    pkgs.nodejs
    pkgs.typescript
    # pkgs.yarn # Uncomment if you use Yarn
    # Add any other build tools needed, e.g., pkgs.typescript
  ];

  # This is crucial: Configure npm's prefix to a writable user-local directory
  # This makes npm link create the global link in a user-writable path
  # instead of trying to write to /nix/store.
  shellHook = ''
    export NPM_CONFIG_PREFIX="$HOME/.npm-global-nix-shell"
    mkdir -p "$NPM_CONFIG_PREFIX"
    # Add the npm bin directory to your PATH for global executables
    export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
    echo "Node.js development environment ready."
    echo "npm prefix set to: $NPM_CONFIG_PREFIX"
    exec zsh
  '';
}

