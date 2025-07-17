{
  description = "Home Manager configuration of user";

  # To update/upgrade packages:
  # nix flake update <input_name> # For specific inputs (e.g., nixpkgs-unstable for Neovim)
  # home-manager switch --flake .#<target>

  inputs = {
    # 1. Pin your main nixpkgs to a STABLE release.
    #    e.g., "nixos-24.05" is the current stable release.
    #    This ensures most of your packages are from a well-tested, fixed point in time.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs.url = "github:nixos/nixpkgs/634fd46801442d760e09493a794c4f15db2d0cbb";

    # 2. Add a separate 'nixpkgs-unstable' input for packages you want to be bleeding edge.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # <--- NEW INPUT

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # Make Home Manager itself follow your *stable* nixpkgs by default.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv";
    # If devenv has its own nixpkgs input and you want it to follow your stable, add:
    # devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixpkgs-unstable, ... } @ inputs: # <--- ADDED nixpkgs-unstable here
      let
      # Define a helper function to import the unstable pkgs for a given system
      # This 'let' block makes mkUnstablePkgs available within the 'outputs' scope
      mkUnstablePkgs = system: import nixpkgs-unstable { inherit system; };
    in
    {

      homeConfigurations."aarch64-darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";

        modules = [
          ./home_aarch64-darwin.nix
          # Remove the direct overlay here
        ];

        extraSpecialArgs = {
          inherit inputs;
          # Pass the unstable pkgs set for this system into home_aarch64-darwin.nix
          unstablePkgs = mkUnstablePkgs "aarch64-darwin"; # <--- NEW: Pass unstablePkgs
        };
      };
      homeConfigurations."lenovo" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home_lenovo.nix
          # Remove the direct overlay here
        ];
        extraSpecialArgs = {
          inherit inputs;
          unstablePkgs = mkUnstablePkgs "x86_64-linux"; # <--- NEW: Pass unstablePkgs
        };
      };
      homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home_linux.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          unstablePkgs = mkUnstablePkgs "x86_64-linux";
        };
      };
      homeConfigurations."antec" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home_antec.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          unstablePkgs = mkUnstablePkgs "x86_64-linux";
        };
      };
      homeConfigurations."capealoe" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home_capealoe.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          unstablePkgs = mkUnstablePkgs "x86_64-linux";
        };
      };
      homeConfigurations."citrix" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home_citrix.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          unstablePkgs = mkUnstablePkgs "x86_64-linux";
        };
      };
    };
}
