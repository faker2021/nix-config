{ config, pkgs, lib, ... }:
{
  users.users.yxb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuyN4abRSZQQFo/hRqPcYoPql7mMUCmZiGP/mgr8groYSQwWjCKga7JZy7kTo5pR3Nh1VVeyP3HKfT8ISZcmV6/j9TsBSWodqk8AwBLa371cL7UN9wzwq60SFznqn75r71ct+kvM59Eh5k9v8SXJUubPArHaThFFckFUR2IsczrGpn7VoLVTAaW11vtKOJCjIBBgnwiKA+sy8QFKmBxgfeRaPFF7ISJSwik3hOUUKowEGLsUz14YrGXOH/xbEjIOBodUMgyAsUpLDDyKmDyLRAF7NF+SNvkuF7/k0hKCJsViPgV9lv+A9wrpGpNyWARGmxs0HKkiED6AVKWXkUt8aP yxb@winstudio" ];
  };
}
