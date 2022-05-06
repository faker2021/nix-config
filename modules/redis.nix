{ config, pkgs, lib, ... }: {

  services.redis = {
    enable = true;
    port = 6379;
    logLevel = "warning";
  };

}
