# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports = [ 
    #(fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
    #../vscode-remote.nix
    /home/yxb/workspace/jsy-mirrorer/modules/jsy-mirrorer.nix
    ../modules/xrdp.nix
    ../modules/network.nix
    ../modules/i18n.nix
    ../modules/fonts.nix
    ../modules/user.nix
    ../modules/docker.nix
    ../modules/gdm-gnome.nix
    ../modules/proxychains.nix
    ../modules/flakes.nix
    ../modules/kernel.nix
  ];

  # packages
  # nix.binaryCaches = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  nixpkgs.config.allowUnfree = true;


  #nixpkgs.overlays = [ (import ./mypkgs/synergy) ];
  environment.systemPackages = with pkgs; [
    git clang_11 cmake tree nethogs unrar patchelf
    vscode nodejs-14_x
    (callPackage ../pkgs/dirspatchelf { })
  ];
  

  system.stateVersion = "21.05"; # Did you read the comment?
  
  
}

