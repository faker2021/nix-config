{ config, pkgs, ... }:

{
  home.username = "yxb";
  home.homeDirectory = "/home/yxb";

  home.packages = [
    pkgs.nixpkgs-fmt
    pkgs.conda
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

  home.file = {
    ".config/nix/nix.conf" =
      {
        text = ''
          experimental-features = nix-command flakes
          substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
        '';
      };
  };

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
