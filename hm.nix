{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];


  ## ---------- User settings and other default things ----------------- ##
  users.defaultUserShell = pkgs.zsh;
  users.users.wsanf = {
    isNormalUser = true;
    description = "wsanf";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  time.hardwareClockInLocalTime = true;

  ## ---------- X settings ----------------- ##
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  ## ---------- Printing and sound ----------------- ##
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ## ---------- Home Manager Settings ----------------- ##
  nixpkgs.config.allowUnfree = true;
  home-manager.users.wsanf = {
    home.stateVersion = "23.11";

    home.sessionVariables = {
      SHELL = "/home/wsanf/.nix-profile/bin/zsh";
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      vscode
      firefox
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
      vscode
      dmenu
      git
      gnome.gnome-keyring
      nerdfonts
      networkmanagerapplet
      nitrogen
      pasystray
      picom
      polkit_gnome
      pulseaudioFull
      rofi
      unrar
      unzip
      neofetch
      rclone
      xarchive
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
      extraLuaConfig = lib.fileContents "/etc/nixos/nvim/init.lua";
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
