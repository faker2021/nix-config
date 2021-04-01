{ config, pkgs, lib, ... }: {
    options = {
        vscode.extensions = lib.mkOption { 
          default = (with pkgs.vscode-extensions; [
            bbenoist.Nix
            ms-python.python
            ms-vscode-remote.remote-ssh
            #tabnine.tabnine-vscode
            ms-vscode.cpptools
            #tabnine.tabnine-vscode
            #coenraads.bracket-pair-colorizer-2
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }
      {
          name = "bracket-pair-colorizer-2";
          publisher = "coenraads";
          version = "0.2.0";
          sha256 = "0nppgfbmw0d089rka9cqs3sbd5260dhhiipmjfga3nar9vp87slh";
      }
      {
          name = "cmake-tools";
          publisher = "ms-vscode";
          version = "1.6.0";
          sha256 = "1j3b6wzlb5r9q2v023qq965y0avz6dphcn0f5vwm9ns9ilcgm3dw";
      }
      {
        name = "cmake";
        publisher = "twxs";
        version = "0.0.17";
        sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.2.16";
        sha256 = "16bb08486cda2z33g503s0lyi4lx5virjsc4ibrgy2hikg2qcgw3";
      }
    #   {
    #     name = "";
    #     publisher = "";
    #     version = "";
    #     sha256 = "";
    #   }
      ];
   };
        vscode.user = lib.mkOption { default = "yxb";};     # <- Must be supplied
        vscode.homeDir = lib.mkOption {default = "/home/yxb"; };  # <- Must be supplied
        nixpkgs.latestPackages = lib.mkOption { default = []; };
  };

    config = {
        ###
        # DIRTY HACK
        # This will fetch latest packages on each rebuild, whatever channel you are at
        nixpkgs.overlays = [
            (self: super:
                let latestPkgs = import (fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixpkgs-unstable.tar.gz) {
                        config.allowUnfree = true;
                    };
                in lib.genAttrs config.nixpkgs.latestPackages (pkg: latestPkgs."${pkg}")
      
	    )
        ];
        # END DIRTY HACK
        ###

        environment.systemPackages = [ pkgs.vscode ];

        system.activationScripts.fix-vscode-extensions = {
            text = ''
                EXT_DIR=${config.vscode.homeDir}/.vscode/extensions
                mkdir -p $EXT_DIR
                chown ${config.vscode.user}:users $EXT_DIR
                for x in ${lib.concatMapStringsSep " " toString config.vscode.extensions}; do
                    ln -sf $x/share/vscode/extensions/* $EXT_DIR/
                done
                chown -R ${config.vscode.user}:users $EXT_DIR
            '';
            deps = [];
        };
    };
}