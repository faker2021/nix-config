

{ appimageTools, fetchurl }:

appimageTools.wrapType2 { # or wrapType1
  name = "telegram";
  src = fetchurl {
    url = "https://apprepo.de/uploads/package/version/2021/08/27/084348/Telegram.AppImage";
    sha256 = "192lcdbsjncqjpggpxgz489407p1kk7zbzhwwvb19hkmccbvzrhj";
  };
  extraPkgs = pkgs: with pkgs; [ ];
}