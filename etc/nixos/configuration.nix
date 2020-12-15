# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages
      (fetchTarball "https://github.com/takagiy/nixos-declarative-fish-plugin-mgr/archive/0.0.5.tar.gz")
      #/home/takagiy/Repos/nixos-fish-plugmgr
    ];

  nixpkgs.overlays = [ (import ./overlays/neovim.nix) ];

  # Save <nixpkgs> whithin this build locally.
  environment.etc."nixos/nixpkgs".source = <nixpkgs>;

  nix = {
    # Use unstable version of nix.
    #package = pkgs.nixUnstable;

    # Enable nix flakes.
    #extraOptions = ''
    #  experimental-features = nix-command flakes
    #
    #'';

    # Build packages in isolated environment.
    useSandbox = true;

    # Set nixpkgs to the saved one.
    nixPath = [
      "nixpkgs=/etc/nixos/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
  };

  # Use custom nixpkgs.
  # system.autoUpgrade.flags = [ "-I" "nixpkgs=/home/takagiy/Desk/Repos/nixpkgs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostName = "modapone";
  #networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  programs.nm-applet = {
    enable = true;
    indicator = false;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Enable Japanese IME.
  i18n.inputMethod.enabled = "fcitx";
  i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "Asia/Tokyo";

  # Allow to install proprietary or unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Exporting environment variables.
  environment.variables = {
  };

  # Enable nightly neovim as the default editor.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    package = pkgs.neovim-nightly;
    configure = {
      packages.myVimPackage.start = with pkgs.vimPlugins; [
        fzf-vim
        nvim-lspconfig
	julia-vim
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];
  environment.systemPackages = with pkgs; [
    # cli #
    tree
    ripgrep
    git
    wget
    killall
    fzf
    fzy
    udiskie
    qrcp
    scrot
    acpi
    python38Packages.grip
    openssl
    xbrightness

    # languages #
    nodejs
    (texlive.combine {
      inherit (texlive) scheme-medium collection-langjapanese;
    })
    go
    julia_15
    rustup
    cargo-edit
    gcc
    (python38.withPackages (pypkgs: with pypkgs; [ 
      matplotlib
    ]))

    # desktop #
    wmderland
    ly

    # desktop.general #
    hsetroot
    rofi
    termite
    networkmanagerapplet

    # desktop.applications #
    spotify
    google-chrome
    pavucontrol
    discord
    imv
    vokoscreen-ng
    llpp
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable light to set backlight brightness.
  programs.light.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+wmderland";
  services.xserver.windowManager.wmderland.enable = true;
  services.xserver.windowManager.i3.enable = true;

  # Install fonts.
  fonts.fonts = with pkgs; [
    uw-ttyp0
  ];

  # Set console font.
  console.font = "uw-ttyp0";

  # Enable fish-shell.
  programs.fish = {
    enable = true;
    plugins = [
      "jethrokuan/fzf"
      "b4b4r07/enhancd"
    ];
  };

  # Start fish-shell from the entering step of bash.
  programs.bash.interactiveShellInit = ''
    [ -z "$NO_EXEC_FISH" ] && exec fish
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.users.takagiy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.bash;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
