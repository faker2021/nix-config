{ config, pkgs, lib, ... }: {

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "gnome3";
  networking.firewall.allowedTCPPorts = [ 3389 ];
}

