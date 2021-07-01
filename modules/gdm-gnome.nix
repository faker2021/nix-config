{ config, pkgs, lib, ... }:
{
  # desktop gdm gnome
  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = { 
      gdm = {
        enable = true;
        wayland = false;
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
    gnome3.gnome-tweak-tool
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.system-monitor
    gnome3.gnome-weather
    gnomeExtensions.sound-output-device-chooser
  ];
  services.teamviewer.enable = true;
}