{ stdenv, pkgs, lib, fetchurl, fetchgit, dpkg, python3, glibc, glib, pam, nss
, nspr, expat, gnome3, xorg, fontconfig, dbus_daemon, alsaLib, shadow }:
stdenv.mkDerivation rec {
  name = "chrome-remote-desktop";
  src = fetchurl {
    sha256 = "0f7c0mm69sjpa6bjbv74zymy1m8iwj7f8ya70p7nqimhxpb1w7v7"; # This hash needs frequent updates
    url =
      "https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb";
  };

  buildInputs = [ pkgs.makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src $out
  '';

  installPhase = ''
    mkdir $out/bin
    makeWrapper $out/opt/google/chrome-remote-desktop/chrome-remote-desktop $out/bin/chrome-remote-desktop
  '';

  replacePrefix = "/opt/google/chrome-remote-desktop";
  replaceTarget = "/run/current-system/sw/bin/./././";

  patchPhase = ''
    substituteInPlace $out/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_desktop.json --replace $replacePrefix/native-messaging-host $out/$replacePrefix/native-messaging-host
    substituteInPlace $out/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_assistance.json --replace $replacePrefix/remote-assistance-host $out/$replacePrefix/remote-assistance-host

    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "USER_SESSION_PATH = " "USER_SESSION_PATH = \"/run/wrappers/bin/crd-user-session\" #"
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/python3 ${python3.withPackages (ps: with ps; [ psutil ])}/bin/python3
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace '"Xvfb"' '"${xorg.xorgserver}/bin/Xvfb"'
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace '"Xorg"' '"${xorg.xorgserver}/bin/Xorg"'
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace '"xrandr"' '"${xorg.xrandr}/bin/xrandr"'
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/lib/xorg/modules ${xorg.xorgserver}/lib/xorg/modules
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace xdpyinfo ${xorg.xdpyinfo}/bin/xdpyinfo
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/sudo /run/wrappers/bin/sudo
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/pkexec /run/wrappers/bin/pkexec
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/gpasswd ${shadow}/bin/gpasswd
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/groupadd ${shadow}/bin/groupadd
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      glib
      pam
      nss
      nspr
      expat
      gnome3.gtk
      gnome3.dconf
      xorg.libXext
      xorg.libX11
      xorg.libXcomposite
      xorg.libXrender
      xorg.libXrandr
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXi
      xorg.libXtst
      xorg.libxcb
      fontconfig
      xorg.libXScrnSaver
      dbus_daemon.lib
      alsaLib
    ];
  in ''
        for i in $out/$replacePrefix/{chrome-remote-desktop-host,start-host,native-messaging-host,remote-assistance-host,user-session}; do
          sed -i "s|$replacePrefix|$replaceTarget|g" $i
          patchelf --set-rpath "${libPath}" $i
          patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 $i
        done
      '';
}