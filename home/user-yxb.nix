{ config, pkgs, ... }:

{
  home.username = "yxb";
  home.homeDirectory = "/home/yxb";

  home.packages = [
    pkgs.nixpkgs-fmt
  ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "faker";
    userEmail = "nspyia2002@gmail.com";
    signing = {
      key = "nspyia2002@gmail.com";
      signByDefault = false;
    };
  };


  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
