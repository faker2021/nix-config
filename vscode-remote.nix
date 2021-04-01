{pkgs, stdenv, ...}:
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
      sha256 = "1r093na1735q85vprifqaach7vc2x85ck7mwqdywrmkpxbbj2248";
  }
  {
    name = "cmake";
    publisher = "twxs";
    version = "0.0.17";
    sha256 = "0bjpf3bscgxh41n306jk509rgpq9l55mpzwk4r99k82dq9qzl7ya";
  }
  {
    name = "";
    publisher = "";
    version = "";
    sha256 = "";
  }
  {
    name = "";
    publisher = "";
    version = "";
    sha256 = "";
  }
  ];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensions;
    };
in
{
  environment.systemPackages = [
    vscode-with-extensions
  ];
}