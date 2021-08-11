{ pkgs ? import (fetchTarball https://git.io/Jf0cc) {} }:

let
  customPython = pkgs.python38.buildEnv.override {
    extraLibs = with pkgs.python38Packages;[ 
      jupyter
      numpy
    ];
  };
in

pkgs.mkShell {
  buildInputs = [ customPython ];
}