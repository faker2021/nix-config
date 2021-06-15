{ lib, config, options, pkgs, ... }:
let cfg = config.services.chrome-remote-desktop;
in {
  options.services.chrome-remote-desktop = {
    enable = lib.mkEnableOption "Chrome Remote Desktop";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc = {
        "chromium/native-messaging-hosts/com.google.chrome.remote_assistance.json".source = "${pkgs.chrome-remote-desktop}/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_assistance.json";
        "chromium/native-messaging-hosts/com.google.chrome.remote_desktop.json".source = "${pkgs.chrome-remote-desktop}/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_desktop.json";
      };

      systemPackages = [ pkgs.chrome-remote-desktop ];
    };

    security = {
      wrappers.crd-user-session.source = "${pkgs.chrome-remote-desktop}/opt/google/chrome-remote-desktop/user-session";

      pam.services.chrome-remote-desktop.text = ''
        auth        required    pam_unix.so
        account     required    pam_unix.so
        password    required    pam_unix.so
        session     required    pam_unix.so
      '';
    };

    users.groups.chrome-remote-desktop = {};
  };
}
