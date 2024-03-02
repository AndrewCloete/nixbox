{
  description = "Home Manager configuration of user";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
     {
      homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
	# For Mac ARM. Create another "homeConfiguration" for other systems
	pkgs = nixpkgs.legacyPackages."aarch64-darwin";

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];


        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
