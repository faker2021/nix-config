{ config, pkgs, ... }:
let

  gt = (pkgs.python3Packages.callPackage ../pkgs/gt { });
in {
  home.username = "yxb";
  home.homeDirectory = "/home/yxb";

  home.packages = [ pkgs.nixpkgs-fmt pkgs.conda gt ];

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

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
