{
  description = "Home Manager configuration of user";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv";
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs:
    {
      homeConfigurations."aarch64-darwin" = home-manager.lib.homeManagerConfiguration {
        # For Mac ARM. Create another "homeConfiguration" for other systems
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home_aarch64-darwin.nix ];

        # This is to enable referring to the devenv package in home.nix
        # see https://haseebmajid.dev/posts/2023-08-26-how-to-use-cachix-devenv-to-setup-developer-environments/
        extraSpecialArgs = { inherit inputs; };


        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
