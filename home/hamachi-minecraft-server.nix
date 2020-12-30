{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.services.hamachi-minecraft-server;
in {
  options.services.hamachi-minecraft-server = {
    enable = mkEnableOption "minecraft server using Hamachi as VPN";
  };

  config = mkIf cfg.enable {
    services.logmein-hamachi.enable = true;
    services.minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      serverProperties = {
        online-mode = false;
      };
    };
  };
}
