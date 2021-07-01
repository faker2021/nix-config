{ config, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      ubuntu_font_family
    ];
  };
}