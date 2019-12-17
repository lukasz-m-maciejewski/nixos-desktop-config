# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    pulseaudio.package = pkgs.pulseaudioFull; # 'full' instead of 'light' for e.g. bluetooth
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    pulseaudio.daemon.config = {
      flat-volumes = "no";
    };
    bluetooth.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Curry"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "pl";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    kdeFrameworks.kwallet
    kdeApplications.kwalletmanager
    kdeFrameworks.networkmanager-qt
    firefox
    okular
    yakuake
    emacs
    yubikey-personalization

    gcc
    gitAndTools.gitFull

    ninja
    cmake
    extra-cmake-modules

    neovim
    python37Packages.pynvim

    acpitool
    compton
    dmenu
    dunst
    htop
    rxvt_unicode
    tmux
    tree
    zathura
    smplayer
    ranger
    libreoffice
    libnotify
    networkmanagerapplet
    pavucontrol
    lxappearance
    termite

    wmctrl
    rofi

    steam
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # services.xserver = {
  #   # Enable the X11 windowing system.
  #   enable = true;
  #   layout = "pl";
  #   xkbOptions = "ctrl:nocaps";
  #   # Enable touchpad support.
  #   libinput = {
  #     enable = true;
  #     naturalScrolling = true;
  #   };

  #   # Enable the KDE Desktop Environment.
  #   displayManager.sddm.enable = true;
  #   desktopManager.plasma5.enable = true;

  #   windowManager.xmonad = {
  #     enable = true;
  #     enableContribAndExtras = true;
  #     extraPackages = haskellPackages: [
  #       haskellPackages.xmonad-contrib
  #       haskellPackages.xmonad-extras
  #       haskellPackages.xmonad
  #     ];
  #   };
  #   windowManager.default = "xmonad";
  # };

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  services.xserver = {
    enable = true;
    layout = "pl";
    xkbOptions = "ctrl:nocaps";
    # Enable touchpad support.
    libinput = {
      enable = true;
      naturalScrolling = true;
    };

#    displayManager.lightdm.enable = true;
    displayManager.sddm.enable = true;
      #   # Enable the KDE Desktop Environment.
  #   displayManager.sddm.enable = true;
  #   desktopManager.plasma5.enable = true;

    desktopManager = {
      default = "none";
      xterm.enable = false;
      plasma5.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
        clipmenu
     ];
    };
    windowManager.default = "i3";
  };

  services.gnome3 = {
    gnome-keyring.enable = true;
    seahorse.enable = true;
  };
  #security.pam.services.lightdm.enable = true;

  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # services.xserver = {
  #   enable = true;
  #   layout = "pl";
  #   xkbOptions = "ctrl:nocaps";
  #   # Enable touchpad support.
  #   libinput = {
  #     enable = true;
  #     naturalScrolling = true;
  #   };
  #   desktopManager = {
  #     default = "xfce";
  #     xterm.enable = false;
  #     xfce = {
  #       enable = true;
  #       noDesktop = true;
  #       enableXfwm = false;
  #     };
  #   };
  #   windowManager.i3 = {
  #     enable = true;
  #     package = pkgs.i3-gaps;
  #     extraPackages = with pkgs; [
  #       dmenu #application launcher most people use
  #     ];
  #   };
  # };

  services.compton = {
    enable          = true;

    backend         = "glx";
    vSync           = "opengl";

    opacityRules = [ "99:class_g = 'konsole'" ];
    shadow          = false;
    fade            = true;
    inactiveOpacity = "0.9";

    fadeDelta       = 4;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      emojione
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira
      fira-code
      fira-mono

      iosevka
      hack-font
      terminus_font
      anonymousPro
      freefont_ttf
      corefonts
      dejavu_fonts
      inconsolata
      ubuntu_font_family
      ttf_bitstream_vera
      hermit
      helvetica-neue-lt-std
    ];
  };


  users.users.lukaszm = {
    isNormalUser = true;
    home = "/home/lukaszm";
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "audio"];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
