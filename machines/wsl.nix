{ lib, pkgs, config, modulesPath, ... }:

with lib;
let

in
{
  imports = [
    # nixos for wsl 
    "${modulesPath}/profiles/minimal.nix"

    # user modules
    ../modules/flakes.nix
    ../modules/user.nix
    ../modules/zsh.nix
    ../modules/i18n.nix
    ../modules/fonts.nix
    ../modules/dev.nix
    ../modules/direnv.nix
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
