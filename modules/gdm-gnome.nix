{ config, pkgs, lib, ... }:
{
  # desktop gdm gnome
  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = { 
      gdm = {
        enable = true;
        wayland = true;
      };
      autoLogin = {
        enable = true;
        user = "yxb";
      };
    };

    desktopManager.gnome.enable = true;  

  };
  services.gnome.chrome-gnome-shell.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;

  environment.systemPackages = with pkgs; [
    google-chrome synergy
    chrome-gnome-shell
    gnome.gnome-tweak-tool
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.system-monitor
    gnome.gnome-weather
    gnomeExtensions.sound-output-device-chooser
  ];
  services.teamviewer.enable = true;
}