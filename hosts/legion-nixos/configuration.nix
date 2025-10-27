# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./options.nix
    ./stylix.nix
    ./hyprland.nix
    ./niri.nix
  ];

  specialisation = lib.mkForce { };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = "auto";
    cores = 0;
    auto-optimise-store = true;
    warn-dirty = false;
    builders-use-substitutes = true;
    http-connections = 128;
    max-substitution-jobs = 128;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "legion-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = lib.mkDefault "Asia/Jakarta";
  # services.automatic-timezoned.enable = true;
  # services.geoclue2.enableDemoAgent = lib.mkForce true;
  # services.geoclue2.geoProviderUrl = "https://beacondb.net/v1/geolocate";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.displayManager.sddm.enable = true;
  services.displayManager.ly.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  security.polkit.enable = true;

  # Enable XDG portals for file dialogs and other desktop integrations
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rid9 = {
    isNormalUser = true;
    description = "rid9";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "video"
      "input"
      "docker"
    ];
    shell = pkgs.fish;
    hashedPassword = "$6$AzOsDEZH9zFSF0AT$g9pxQMibYSOm390jTMiTzYhxT50yM8AsjDAbCfmqkwKT4VdddZ8xTu.3dC44yOsiCt24dniIBNJDZaKfOIGws1";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      mySystem = config.mySystem;
    };
    users.rid9 = {
      imports = [
        ./home-manager.nix
        inputs.catppuccin.homeModules.catppuccin
      ];
    };

    backupFileExtension = "hm-backup";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    git-lfs
    tig
    jujutsu
    zip
    unzip

    nh
    nvd
    nix-output-monitor

    alacritty

    egl-wayland
    ddcutil
    os-prober
    git-crypt

    gtk3
    gtk4

    swayimg

    btop
    bruno
    sqlite
    sqlite-web

    protobuf
    lm_sensors
    i2c-tools

    cachix
    gcc

    kind
    pkg-config
    mariadb
    ripgrep

    gnumake

    zig
    zls

    tree
    file

    libsecret
    polkit_gnome
    jq
  ];

  programs.nh.enable = true;
  programs.nh.flake = "/home/rid9/nixos-config";

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    # fira-code
    # (nerdfonts.override { fonts = [ "FiraCode" ]; })
    nerd-fonts.fira-code
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  time.hardwareClockInLocalTime = true;

  environment.sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
    # NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  # services.logind.settings.Login = ''
  #   # don’t shutdown when power button is short-pressed
  #   HandlePowerKey=suspend
  # '';
  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
  };

  security.pam.services.swaylock = { };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    login.enableGnomeKeyring = true;
    ly.enableGnomeKeyring = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.flatpak.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.file-roller.enable = true;
  xdg.mime.defaultApplications."inode/directory" = "thunar.desktop";
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  catppuccin.flavor = "mocha";

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    trusted-users = root rid9
  '';

  hardware.xpadneo.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "beekeeper-studio-5.3.4" ];

  boot.supportedFilesystems = [ "ntfs" ];
}
