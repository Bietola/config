{
  bootLoader = { ... }: {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # TODO: enable os-prober
  };

  makeSoundWork = { ... }: {
    # Needed to make sound work properly, as specified here:
    # https://wiki.archlinux.org/index.php/HP_Spectre_x360_-_13-ap0xxxx#Audio
    boot.extraModprobeConfig = ''
      blacklist snd_hda_intel
      blacklist snd_soc_skl
    '';
  };

  keyboard = { lib, pkgs, ... }: {
    # Configure keymap in X11
    services.xserver.layout = "it";
    services.xserver.displayManager.sessionCommands =
      let
        myCustomLayout = pkgs.writeText "xkb-layout" ''
          ! Get ~ and ´
          keycode  51 = ugrave 96 ugrave 96 asciitilde asciitilde asciitilde

          ! Swap caps lock with escape for all vimlike things
          ! TODO: Make this work w/ windows caps lock remapping
          remove Lock = Caps_Lock
          keysym Escape = Caps_Lock
          keysym Caps_Lock = Escape
          add Lock = Caps_Lock
        '';
      in "${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout}";
  };

  networking = {

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    # networking.interfaces.enp0s3.useDHCP = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  };

  terminal.font.size = 12;

  extraPackages = pkgs: with pkgs; [
    # Needed for making sound work.
    # Archwiki link: https://wiki.archlinux.org/index.php/HP_Spectre_x360_-_13-ap0xxxx#Audio.
    # TODO: Find out why this doesn't work
    sof-firmware
  ];
}
