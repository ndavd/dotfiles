{ config, lib, ... }:
let
  inherit (config.host) owner;
  isBtrfs = config.fileSystems."/".fsType == "btrfs";
in
{
  services.snapper = {
    snapshotInterval = "daily";
    configs = lib.mkIf isBtrfs {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ owner ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        TIMELINE_LIMIT_HOURLY = 0;
        TIMELINE_LIMIT_DAILY = 3;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
