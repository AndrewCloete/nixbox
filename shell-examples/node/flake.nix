{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      # system should match the system you are running on
      # system = "x86_64-linux";
      # system = "x86_64-darwin";
      system = "aarch64-darwin";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.mkShell {
          # create an environment with nodejs_18, pnpm, and yarn
          packages = with pkgs; [
            # awscli2
            # ssm-session-manager-plugin
            # nodejs_18
            # nodePackages.pnpm
            # (yarn.override { nodejs = nodejs_18; })
            # nushell
          ];

          shellHook = ''
            	  ${builtins.readFile ./fixtures.sh}
          '';
        };
    };
}
