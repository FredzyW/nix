{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    initExtra = ''
	  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      export PATH=/home/fw/.local/bin:$PATH
    '';
    plugins = with pkgs; [
      {
        name = "zsh-z";
        file = "zsh-z.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/agkozak/zsh-z";
          rev = "afaf2965b41fdc6ca66066e09382726aa0b6aa04";
        };
      }
	  {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    shellAliases = {
      ls="ls --color=auto";
      ll="ls -al --color=auto";
      ccr="gcc intopt.c && ./a.out";
      homec="nvim ~/nix/config/home.nix";
      nvimc="nvim ~/.config/nvim/init.lua";
      sdg="sudo nix-collect-garbage -d";
      udg="nix-collect-garbage -d";
      df="df -h";
      c="clear";
    };
    enableCompletion = true;
    initExtraBeforeCompInit = ''
    # Lines configured by zsh-newuser-install
	home() {
		cd ~/nix/ && home-manager switch --flake ".#fw@$(hostname)";
	}
	update() {
		sudo nix-channel --update && sudo nixos-rebuild switch --upgrade --flake '.#$(hostname)'
	}
	reb() {
		cd ~/nix/ && sudo nixos-rebuild switch --flake ".#$(hostname)"
	}

    HISTFILE=~/.histfile
    HISTSIZE=1000
    SAVEHIST=1000
    setopt autocd extendedglob
    bindkey -v
    bindkey '^R' history-incremental-search-backward
    bindkey '^[[1;5C' emacs-forward-word
    bindkey '^[[1;5D' emacs-backward-word
    # End of lines configured by zsh-newuser-install
    # The following lines were added by compinstall
    zstyle :compinstall filename '/home/fw/.zshrc'

    # autoload -Uz compinit
    autoload -U compinit; compinit
    zstyle ':completion:*' menu select

    '';
  };
}
