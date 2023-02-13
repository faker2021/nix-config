

{ config, pkgs, lib, ... }:

let
  vscode-server-src = fetchTarball {
    url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
    sha256 = "11hd7yr7parfgjsjnr34s6fp2jgx0ihcc3cr93lfxykl2vv46cpx";
  };
in {
  imports = [ "${vscode-server-src}/modules/vscode-server/home.nix" ];

  services.vscode-server.enable = true;
  services.vscode-server.nodejsPackage = pkgs.nodejs-16_x;
  services.vscode-server.enableFHS = true;
  services.vscode-server.extraFHSPackages = pkgs: builtins.attrValues {
    inherit (pkgs) curl;
  };
}
