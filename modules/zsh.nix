{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;

    shellAliases = {
      ll = "ls -l";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
}
