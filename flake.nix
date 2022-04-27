{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";

    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs:

    {
      nixosConfigurations = {

        workst = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./machines/main.nix
            ({
              nixpkgs.overlays = [
                (final: prev: { })
              ];
            })
          ];
        };

        wsl = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.wsl
            ./machines/wsl.nix
          ];
        };

      };
    };
}
