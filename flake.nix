{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, ... }@inputs:

    {
      nixosConfigurations = {

        workst = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            inputs.vital-modules.nixosModules.foundation
            ./machines/main
            ({
              nixpkgs.overlays = [
                (final: prev: {

                })
              ];
            })
          ];
        };
      };
    };
}
