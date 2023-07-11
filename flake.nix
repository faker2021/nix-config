{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:faker2021/nixos-vscode-server";

  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
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
            ./modules/redis.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yxb = import ./home/wst.nix;
            }
          ];
        };

      };

      homeConfigurations.yxb = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules =
          [ ./home/user-yxb.nix ./home/shell.nix ./home/vscode-server.nix ];

      };

    };
}
