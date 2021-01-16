# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "e3828769e877b1869129a3816515a8c0ea454977";
  };

  # `machineConf` contains machine-specific settings
  machineName = (import ./machine/machine.nix).machine;
  machineConf = import "/etc/nixos/machine/${machineName}.nix";

  mkHome = import ./home/core.nix;
in

{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
      
      # Machine-specific configuration
      machineConf.bootLoader
      # TODO: Find why this doesn't work (see todo.md)
      # machineConf.makeSoundWork
      machineConf.keyboard
      machineConf.networking

      # Home manager
      (import "${home-manager}/nixos")
    ];

  # Used for virtualbox extension packs
  nixpkgs.config.allowUnfree = true;

  # Home manager configuration
  # TODO handle differences with function
  home-manager.users = {
    root = mkHome {
      pkgs = pkgs;

      username = "root";
      homeDirectory = "/root";
    };

    dincio = mkHome {
      pkgs = pkgs;

      username = "dincio";
      homeDirectory = "/home/dincio";
    };
  };

  networking.hostName = "richard"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "it";
  };

  # Xserver configuration.
  services.xserver = {
    enable = true;

    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+xmonad";

    desktopManager.gnome3.enable = true;
    windowManager = {
      # Needs to be here and not in home-manager, because the default session
      # includes xmonad.
      xmonad.enable = true;
    };
  };

  # Enable CUPS to print documents
  # services.printing.enable = true;

  # For easy bluetooth with blueman-applet and blueman-manager
  # TODO: Remove if bluetoothctl works: services.blueman.enable = true;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    package = pkgs.pulseaudioFull;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dincio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # NB. Most packages are managed by home-manager
  ] ++
  # Packages needed for the machine
  machineConf.extraPackages pkgs;

  # Kill Luke Smith
  # NOTE: Actually not needed anymore
  services.flatpak.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable virtualbox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "root" "dincio" ];

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
  system.stateVersion = "20.09"; # Did you read the comment?
}
