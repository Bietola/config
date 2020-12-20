{
  bootLoader = { ... }: {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # TODO: enable os-prober
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

  terminal.font.size = 12;
}
