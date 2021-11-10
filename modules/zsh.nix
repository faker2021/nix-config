{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "zsh-syntax-highlighting" "zsh-autosuggestions" "z" "d"];
      theme = "robbyrussel";
    };
  };
}
