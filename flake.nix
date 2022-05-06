{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";

    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:

    {
      nixosConfigurations = {

        workst = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./machines/main.nix
            ({ nixpkgs.overlays = [ (final: prev: { }) ]; })
          ];
        };

        wst = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.wsl
            ./machines/wsl.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yxb = import ./modules/home_wst.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };

      };
    };
}
