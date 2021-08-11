{ config, pkgs, lib, ... }:
{
  networking.firewall.enable = false;
  networking = {
    hostName = "wst";
    networkmanager.enable = true;
  };
  services.openssh.enable = true;
  services.sshd.enable = true;
}