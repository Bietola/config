{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.machine;
{
  options.machineConf = {
    # No options for now
  };

  # TODO: Use something better than mkIf
  config = mkIf true {
    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    # boot.loader.grub.efiSupport = true;
    # boot.loader.grub.efiInstallAsRemovable = true;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi";
    # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

    # Configure keymap in X11
    services.xserver.layout = "it";
    services.xserver.displayManager.sessionCommands =
      let
        myCustomLayout = pkgs.writeText "xkb-layout" ''
          ! Get ~ and ´
          keycode  51 = ugrave 96 ugrave 96 asciitilde asciitilde asciitilde

          ! Swap caps lock with escape for all vimlike things
          ! TODO: Make this work w/ windows caps lock remapping
          ! remove Lock = Caps_Lock
          ! keysym Escape = Caps_Lock
          ! keysym Caps_Lock = Escape
          ! add Lock = Caps_Lock
        '';
      in "${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout}";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.enp0s3.useDHCP = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Other useful machine configuration variables
    machineConf = {
      extraSysPackages = with pkgs; [
        # Nothing for now
      ];

      extraPackages = with pkgs; [
        # Nothing for now
      ];

      ignoredPackages = with pkgs; [
        # No need for a virtualbox inside another virtualbox...
        # (Also, compilation is lengthy)
        virtualbox
      ];
    };
  };
}
