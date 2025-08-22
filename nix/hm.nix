{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  ## ---------- User settings and other default things ----------------- ##
  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;
  ## ---------- Virtualization ----------------- ##
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.qemu.runAsRoot = true;
  virtualisation.libvirtd.onBoot = "start";
  virtualisation.libvirtd.onShutdown = "suspend";
  boot.kernelModules = [ "kvm-amd" ];
  users.users.wsanf.extraGroups = [ "libvirtd" "kvm" ];
  networking.firewall.checkReversePath = "loose";
  fonts.packages = [
    pkgs.nerd-fonts.fira-code        # Replace with fonts you actually use
    pkgs.nerd-fonts.jetbrains-mono   # Replace with fonts you actually use
  ];

  ## ---------- Home Manager Settings ----------------- ##
  nixpkgs.config.allowUnfree = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.wsanf = {
    home.stateVersion = "25.05";

    home.sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";  # Use the Nix-provided zsh path
      EDITOR = "emacs";
    };

    home.packages = with pkgs; [
      qemu
      virt-manager
      OVMF
      spice-gtk
      emacs
      libtool
      firefox
      git
      zsh
      oh-my-zsh
      atuin
      neofetch
      vscode
      libreoffice
      alacritty
      tmux
      ripgrep
      rust-analyzer
      pyright
      vscode
      gnome-keyring
      networkmanagerapplet
      pasystray
      polkit_gnome
      pulseaudioFull
      unrar
      unzip
      rclone
      rofi
      btop
      obsidian
    ];
    programs.home-manager.enable = true;

    services.syncthing = {
      enable = true;
      settings = {
       devices = {
         "iPhone" = { id = "72OYPRC-LLLDAA7-ZRSEA3Q-G3O4RIZ-P54RKSB-JBZL4GX-ELQS5UV-3ERTVQK"; };
         "nixos" = { id = "7LJOJMB-SN5E3JT-KMYEEPS-NRJ4PHM-SCLB53E-UFRNRF7-7YUH47E-WDK5GAC"; };
         "GalaxyTab" = { id = "DA62RK2-6JVCQUD-KTQUWKF-NZLQ5HM-TZLPUZX-ZSVQAMH-E5KX54Q-XTNV6QE"; };
       };
       folders = {
        "Proton" = {
          path = "/home/wsanf/proton";
          devices = [ "nixos" "iPhone" "GalaxyTab" ];
        };
        };
      };
    };
 
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.git = {
      enable = true;
      userName = "Will Sanford";
      userEmail = "wsanford99@gmail.com";
    };

    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
        config = "sudo nvim /etc/nixos/configuration.nix";
        todo = "nvim ~/proton/todo.md";
        sync = "rclone bisync /home/wsanf/proton/ proton:/ -v --resync";
        ns = "NIXPKGS_ALLOW_UNFREE=1 nix-shell --command zsh";
        copy = "clip -selection clipboard";
        paste = "clip -selection clipboard -o";
        doom = "/home/wsanf/.config/emacs/bin/doom";
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

    # programs.atuin = {
    # enable = true;
# enableZshIntegration = true;
 #   };

    programs.neovim = {
      enable = true;
      extraLuaConfig = lib.fileContents "/etc/nixos/init.lua";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        shell = {
	  program = "${pkgs.zsh}/bin/zsh";  
        };
      };
    };
  };
}
