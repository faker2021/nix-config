{ pkgs, lib, ... }:

pkgs.writeShellScriptBin "patchelf-dirs" (builtins.readFile ./dirspatchelf.sh)
