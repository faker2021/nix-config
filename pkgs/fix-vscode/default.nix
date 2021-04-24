
{ pkgs, lib, ... }:

pkgs.writeShellScriptBin "fix-vscode" ''
patchelf-dirs ~/.vscode 
patchelf-dirs ~/.vscode-server
''
