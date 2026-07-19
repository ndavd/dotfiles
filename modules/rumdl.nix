{
  config,
  pkgs,
  ...
}:
let
  inherit (config.host) owner;
in
{
  hjem.users.${owner}.xdg.config.files."rumdl/rumdl.toml".source =
    pkgs.writers.writeTOML "rumdl.toml"
      {
        global = {
          extend-enable = [ "MD060" ];
        };
        MD060 = {
          style = "aligned";
        };
        MD013 = {
          line-length = 100;
          reflow = true;
          reflow-mode = "normalize";
          code-blocks = false;
          tables = false;
        };
      };
}
