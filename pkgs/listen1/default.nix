{ appimageTools, fetchurl }:

appimageTools.wrapType2 {
  # or wrapType1
  name = "listen1";
  src = fetchurl {
    url =
      "https://github.com/listen1/listen1_desktop/releases/download/v2.21.6/listen1_2.21.6_linux_x86_64.AppImage";
    sha256 = "1ylvy4ipfdlf3r6kzyxv07l81ms8mm8mk86fcbkvkvf9nd41yrm2";
  };
  extraPkgs = pkgs: with pkgs; [ ];
}
