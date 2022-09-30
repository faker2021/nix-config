{ config, pkgs, ... }:

{
  home.username = "maho";
  home.homeDirectory = "/home/maho";

  home.packages = [
    pkgs.nixpkgs-fmt
    pkgs.conda
  ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "maho";
    userEmail = "nspyia2002@gmail.com";
    signing = {
      key = "nspyia2002@gmail.com";
      signByDefault = false;
    };
  };

  home.file = {
    ".config/nix/nix.conf".source = ./files/.config/nix/nix.conf;
  };

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
