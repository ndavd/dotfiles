{
  pkgs,
  config,
  lib,
  ...
}:
let
  snapshotsSubvolume = "/home";
  isBtrfs = config.fileSystems.${snapshotsSubvolume}.fsType == "btrfs";
  keep = 7;

  create-snapshot-script = pkgs.writeShellApplication {
    name = "create-snapshot";
    runtimeInputs = with pkgs; [
      btrfs-progs
    ];
    text = ''
      timestamp="$(date +%s)"
      snapshot_path="${snapshotsSubvolume}/.snapshots/$timestamp"
      btrfs subvolume snapshot -r "${snapshotsSubvolume}" "$snapshot_path"
      echo "Created snapshot: $snapshot_path"
    '';
  };
  prune-snapshots-script = pkgs.writeShellApplication {
    name = "prune-snapshots";
    runtimeInputs = with pkgs; [
      btrfs-progs
    ];
    text = ''
      snapshots_dir="${snapshotsSubvolume}/.snapshots"
      old_snapshots="$(find "$snapshots_dir" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort -n | head -n -"${toString keep}")"
      for snapshot in $old_snapshots; do
        echo "Deleting snapshot: $snapshot"
        btrfs subvolume delete -c "$snapshots_dir/$snapshot"
      done
    '';
  };
in
{
  config = lib.mkIf isBtrfs {
    environment.systemPackages = [
      create-snapshot-script
      prune-snapshots-script
    ];
    systemd = {
      services = {
        btrfs-snapshot = {
          description = "Create btrfs snapshot";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${create-snapshot-script}/bin/create-snapshot";
          };
          onSuccess = [ "btrfs-cleanup.service" ];
        };
        btrfs-cleanup = {
          description = "Prune old btrfs snapshots";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${prune-snapshots-script}/bin/prune-snapshots";
          };
        };
      };
      timers = {
        btrfs-snapshot = {
          description = "Daily btrfs snapshot timer";
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
            Unit = "btrfs-snapshot.service";
          };
          wantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
