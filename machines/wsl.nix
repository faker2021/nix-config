{ lib, pkgs, config, modulesPath, ... }:

with lib;
let

in
{
  imports = [
    # nixos for wsl 
    "${modulesPath}/profiles/minimal.nix"
    # nixos-wsl.nixosModules.wsl

    # user modules
    ../modules/flakes.nix
    ../modules/user.nix
    ../modules/zsh.nix
    ../modules/i18n.nix
  ];

  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    wget
    git 
    nodejs-16_x
    (callPackage ../pkgs/dirspatchelf { })
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "yxb";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };
}
