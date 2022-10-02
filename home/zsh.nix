{ config, pkgs, lib, ... }: {

  home.packages = [
    pkgs.bat
    pkgs.htop
    pkgs.lsd
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # nix-direnv.enableFlakes = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    defaultKeymap = "viins";

    shellAliases = {
      ll = "ls -l";
      cmake_debug = "cmake -DCMAKE_BUILD_TYPE=Debug ..";
      format_all = "echo $(find -name *.cc)+$(find -name *.h) | while read -r a; do clang-format --verbose -i --style=file $a; done";
    };

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';

    initExtra = ''
      # surely something else has these defaults?
      bindkey "^[[H"    beginning-of-line
      bindkey "^[[F"    end-of-line
      bindkey "^[[3~"   delete-char
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      eval "$(direnv hook zsh)"
      # autoload -U compinit && compinit
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "zdharma-continuum/fast-syntax-highlighting"; }
      ];
    };

    plugins = with pkgs; [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = "p10k.zsh";
        name = "powerlevel10k-config";
        src = ./files;
      }
      {
        name = "enhancd";
        file = "init.sh";
        src = pkgs.fetchFromGitHub {
          owner = "b4b4r07";
          repo = "enhancd";
          rev = "c6967f7f70f18991a5f9148996afffc0d3ae76e4";
          sha256 = "p7ZG4NC9UWa55tPxYAaFocc0waIaTt+WO6MNearbO0U=";
        };
      }
    ];

    history = {
      size = 99999;
      save = 99999;
    };
  };
}
