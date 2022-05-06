{ config, pkgs, lib, ... }: {
  home.packages = [
    pkgs.unzip
    pkgs.wget
    pkgs.gcc
    pkgs.gdb
    pkgs.cmake
    pkgs.python38

  ];

  programs.home-manager.enable = true;

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


}
