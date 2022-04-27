{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    # nixos for wsl 
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl

    # user modules
    ../modules/flakes.nix
    ../modules/user.nix
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "yxb";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
