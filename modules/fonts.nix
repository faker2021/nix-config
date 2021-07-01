{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Vazir" "Ubuntu" ];
        sansSerif = [ "Vazir" "Ubuntu" ];
        monospace = [ "Ubuntu" ];
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      ubuntu_font_family
      vazir-fonts
    ];
  };
}