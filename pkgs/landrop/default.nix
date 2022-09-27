{ appimageTools, fetchurl }:

appimageTools.wrapType2 {
  # or wrapType1
  name = "landrop";
  src = fetchurl {
    url =
      "https://github.com/LANDrop/LANDrop/releases/download/v0.4.0/LANDrop-0.4.0-linux.AppImage";
    sha256 = "0zvgb1b4zp7jicd4ja9a7kzrl93hsgkrd038v9vkc55kgf52ffz3";
  };
  extraPkgs = pkgs: with pkgs; [ ];
}
