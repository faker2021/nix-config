{ config, pkgs, ... }:
let



in {
  programs.home-manager.enable = true;

  home.username = "yxb";
  home.homeDirectory = "/home/yxb";

  home.packages = [ pkgs.nixpkgs-fmt pkgs.htop];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "faker";
    userEmail = "nspyia2002@gmail.com";
    signing = {
      key = "nspyia2002@gmail.com";
      signByDefault = false;
    };
    extraConfig = {
      push.default = "current";
      push.autoSetupRemote = "true";
    };
  };

  home.file = { ".config/nix/nix.conf".source = ./files/.config/nix/nix.conf; };

  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "23.05";
}
