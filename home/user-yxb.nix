{ config, pkgs, ... }: 

{ 
  home.username = "yxb";
  home.homeDirectory = "/home/yxb";

  home.packages = [
    pkgs.nixpkgs-fmt
  ];

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
