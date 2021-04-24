
{ pkgs, lib, ... }:

pkgs.writeShellScriptBin "fix-vscode" ''
patchelf-dirs ~/.vscode ~/.vscode-server
''
