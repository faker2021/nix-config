# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports = [ 
    #(fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
    #../vscode-remote.nix
    /home/yxb/workspace/jsy-mirrorer/modules/jsy-mirrorer.nix
    
  ];

  services.flatpak.enable = true;
  # network
  networking.firewall.enable = false;
  networking = {
    hostName = "workst";
    networkmanager.enable = true;
  };

  services.openssh.enable = true;
  services.sshd.enable = true;

  
   nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };


  # localization
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ cloudpinyin ];
    };
  };

  time.timeZone = "Asia/Shanghai";

  location = {
    latitude = 23.0;
    longitude = 113.0;
  };




  # desktop lightdm pantheon
  # services.xserver = {
  #   enable = true;
  #   layout = "us";
  #   displayManager.lightdm = {
  #     enable = true;
  #     greeters.pantheon.enable = true;
  #   };
  #   desktopManager.pantheon.enable = true;  
  # };

  # desktop gdm gnome
  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = { 
      gdm = {
        enable = true;
        wayland = false;
      };
      autoLogin = {
        enable = true;
        user = "yxb";
      };
    };

    desktopManager.gnome3.enable = true;  

  };
  services.gnome3.chrome-gnome-shell.enable = true;
  # look environment.systemPackages




  # font
  fonts = {
    enableDefaultFonts = true;
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      wqy_microhei
      wqy_zenhei
    ];
  };



  # user
  users.users.yxb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys =
  [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuyN4abRSZQQFo/hRqPcYoPql7mMUCmZiGP/mgr8groYSQwWjCKga7JZy7kTo5pR3Nh1VVeyP3HKfT8ISZcmV6/j9TsBSWodqk8AwBLa371cL7UN9wzwq60SFznqn75r71ct+kvM59Eh5k9v8SXJUubPArHaThFFckFUR2IsczrGpn7VoLVTAaW11vtKOJCjIBBgnwiKA+sy8QFKmBxgfeRaPFF7ISJSwik3hOUUKowEGLsUz14YrGXOH/xbEjIOBodUMgyAsUpLDDyKmDyLRAF7NF+SNvkuF7/k0hKCJsViPgV9lv+A9wrpGpNyWARGmxs0HKkiED6AVKWXkUt8aP yxb@winstudio" ];
  };




  # packages
  nix.binaryCaches = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker-edge;
  };
  # services.vscode-server.enable = true;

  #nixpkgs.overlays = [ (import ./mypkgs/synergy) ];
  environment.systemPackages = with pkgs; [
    
    git google-chrome teamviewer  clang cmake proxychains tree synergy nodejs-12_x
    vscode
    chrome-gnome-shell
    gnome3.gnome-tweak-tool
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.system-monitor
    gnome3.gnome-weather
    gnomeExtensions.sound-output-device-chooser
    #(callPackage ./mypkgs/synergy {})
    (callPackage ../pkgs/dirspatchelf { })
    (callPackage ../pkgs/fix-vscode { })
  ];
  services.teamviewer.enable = true;

  # packages config
  environment.etc = {

    # proxy
    "proxychains.conf" = {
      text = ''
        strict_chain
        proxy_dns
        remote_dns_subnet 224
        tcp_read_time_out 15000
        tcp_connect_time_out 8000
        localnet 127.0.0.0/255.0.0.0
        quiet_mode
        [ProxyList]
        socks5 192.168.50.142 7890
      '';
    };
  };



  # systemd
  systemd.services = {
    # synergyserver = {
    #   description = "synergyserver";
    #   after = [ "network.target" ];
    #   wantedBy = [ "multi-user.target" ];
    
    #   serviceConfig.Type = "simple";

    #   script = ''
    #     ${pkgs.synergy}/bin/synergyc -f --no-tray --debug INFO --name workst 192.168.50.142:24800
    #   '';
    # }
    nix_channels_adder = {
      description = "nix_channels_adder";
      serviceConfig.Tyoe = "oneshot";
      script = ''
        nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-20.09 nixos
        nix-channel --update
      '';
    };
  };

  system.stateVersion = "20.09"; # Did you read the comment?
  
  
}

