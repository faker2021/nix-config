{ config, pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    defaultKeymap = "viins";

    shellAliases = { ll = "ls -l"; };

    initExtra = ''
      # surely something else has these defaults?
      bindkey "^[[H"    beginning-of-line
      bindkey "^[[F"    end-of-line
      bindkey "^[[3~"   delete-char
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      # autoload -U compinit && compinit
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };

    history = {
      size = 99999;
      save = 99999;
    };
  };
}
