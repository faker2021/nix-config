{pkgs, stdenv,lib, ...}:
let
  extensions = (with pkgs.vscode-extensions; [
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
  # {
  #   name = "";
  #   publisher = "";
  #   version = "";
  #   sha256 = "";
  # }
  # {
  #   name = "";
  #   publisher = "";
  #   version = "";
  #   sha256 = "";
  # }
  ];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensions;
    };
in
{
  environment.systemPackages = [
    vscode-with-extensions
  ];

  system.activationScripts.fix-vscode-extensions = {
      text = ''
          EXT_DIR=/home/yxb/.vscode/extensions
          mkdir -p $EXT_DIR
          chown yxb:users $EXT_DIR
          for x in ${lib.concatMapStringsSep " " toString extensions}; do
              ln -sf $x/share/vscode/extensions/* $EXT_DIR/
          done
          chown -R yxb:users $EXT_DIR
      '';
      deps = [];
  };
}