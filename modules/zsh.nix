{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    programs.zsh.autosuggestions.enable = true;
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
