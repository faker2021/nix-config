{ config, pkgs, lib, ... }:

let
  vscode-server-src = fetchTarball {
    url = "https://github.com/msteen/nixos-vscode-server/tarball/82e4b80";
    sha256 = "119kka9ihymajiri16dcj7f376lk6pvlkg02fr4gm5hj23khbg04";
  };
in
{
  imports = [ "${vscode-server-src}/modules/vscode-server/home.nix" ];

  services.vscode-server.enable = true;
  services.vscode-server.nodejsPackage = pkgs.nodejs-16_x;
  services.vscode-server.enableFHS = true;
}
