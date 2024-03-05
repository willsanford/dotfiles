{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.wsanf = {
    home.stateVersion = "23.11";

    home.sessionVariables = {
      SHELL = "/home/wsanf/.nix-profile/bin/zsh";
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      vscode
      zsh
      oh-my-zsh
      atuin
      libreoffice
      alacritty
      tmux
      ripgrep
      libclang
      rust-analyzer
      neofetch
    ];
    programs.home-manager.enable = true;
    programs.git = {
	enable = true;
	userName = "Will Sanford";
	userEmail = "wsanford99@gmail.com";
    };

    # Add my custom zsh theme
    home.file.".zsh_theme/themes/nix-shell-theme.zsh-theme".text = ''
      PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%}"
      PROMPT+='$(if [[ -n $SHELL_NAME && -n $IN_NIX_SHELL ]]; then echo "%{$fg_bold[green]%} <$SHELL_NAME>%{$reset_color%}"; else echo ""; fi)'
      PROMPT+=' $(git_prompt_info)'
      ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
      ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
    '';
    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
	update = "sudo nixos-rebuild switch";
	config = "sudo nvim /etc/nixos/configuration.nix";
	todo = "nvim ~/proton/todo.md";
	sync = "rclone bisync /home/wsanf/proton/ proton:/ -v --resync";
	ns = "nix-shell --command zsh";
      };
      history = {
        size = 10000;
	extended = true;
	share = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
	custom = "/home/wsanf/.zsh_theme/";
        theme = "nix-shell-theme";
      };
    };

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.neovim = {
      enable = true;
      extraLuaConfig = lib.fileContents "/home/wsanf/code/dotfiles/nvim/init.lua";
    };
    programs.alacritty = {
      enable = true;
      settings = {
        shell = {
	  program = "/home/wsanf/.nix-profile/bin/zsh";
	};
      };
    };
  };
}
