{lib, config}:
{
  system.activationScripts.fix-vscode-extensions = {
      text = ''
          EXT_DIR=/home/yxb/.vscode/extensions
          mkdir -p $EXT_DIR
          chown yxb:users $EXT_DIR
          for x in ${lib.concatMapStringsSep " " toString config.vscode.extensions}; do
              ln -sf $x/share/vscode/extensions/* $EXT_DIR/
          done
          chown -R ${config.vscode.user}:users $EXT_DIR
      '';
      deps = [];
  };
}