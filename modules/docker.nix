{ config, pkgs, lib, ... }:
{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker-edge;
  };
}