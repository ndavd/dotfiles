{
  pkgs,
  ...
}:
let
  ipns-publish-script = pkgs.writeShellApplication {
    name = "ipns-publish";
    runtimeInputs = with pkgs; [
      kubo
      curl
    ];
    text = ''
      ipfs daemon &
      sleep 10
      ipfs name publish \
        --key=ndavd \
        "$(curl -sS https://raw.githubusercontent.com/ndavd/blog/refs/heads/main/cid.txt)/"
      ipfs shutdown
    '';
  };
in
{
  systemd.user = {
    services = {
      ipns-publish = {
        description = "Publish latest CID to IPNS";
        serviceConfig = {
          ExecStart = "${ipns-publish-script}/bin/ipns-publish";
        };
      };
    };
    timers = {
      ipns-publish = {
        description = "IPNS publish timer";
        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "3h";
          Unit = "ipns-publish.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
