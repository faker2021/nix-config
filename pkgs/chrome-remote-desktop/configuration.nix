nixpkgs.config = {
  allowUnfree = true;
  packageOverrides = import (./overlay) pkgs; # Import overlay that defines a chrome-remote-desktop package
};

...

imports = [ # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ./chrome-remote-desktop.nix # Load chrome-remote-desktop.nix module.
];

...

services = {
  chrome-remote-desktop.enable = true; # Enable the service.
};

...

users.$USER.extraGroups = [ "chrome-remote-desktop" ]; # Add chrome-remote-desktop group to your user.