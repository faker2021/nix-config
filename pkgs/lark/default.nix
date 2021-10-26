

{ appimageTools, fetchurl }:

appimageTools.wrapType2 { # or wrapType1
  name = "listen1";
  src = fetchurl {
    url = "https://github.com/Ericwyn/electron-lark/releases/download/V1.1.5/electron-lark-1.1.5.AppImage";
    sha256 = "13if4clmx8k91ri77bldl33nlgdff573naji148gs2vyjxxjzch3";
  };
  extraPkgs = pkgs: with pkgs; [ ];
}