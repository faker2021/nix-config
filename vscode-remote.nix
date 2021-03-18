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
  }];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensions;
    };
in
{
  environment.systemPackages = [
    vscode-with-extensions
  ];
}