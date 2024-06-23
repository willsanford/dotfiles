{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  # Boot loader configuration
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time and locale
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;
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

  # X11 and desktop environment
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Sound and audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # User configuration
  users.users.wsanf = {
    isNormalUser = true;
    description = "wsanf";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      xarchiver
    ];
  };

  # System-wide packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
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
  ];

  # ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # SSH
  services.openssh.enable = true;

  # Home Manager configuration
  home-manager.users.wsanf = { pkgs, ... }: {
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

  # System state version
  system.stateVersion = "23.11";
}
