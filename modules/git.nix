{ config, ... }:
let
  inherit (config.host) owner;
in
{
  programs.git = {
    enable = true;
    config = {
      user = {
        email = "ndavidq0@gmail.com";
        name = "Nuno David";
        signingkey = "/home/${owner}/.ssh/sig_commits";
      };
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh = {
          allowedSignersFile = "/home/${owner}/.config/git/allowed_signers";
        };
      };
      init.defaultBranch = "main";
      status.showUntrackedFiles = "normal";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      push.default = "current";
      fetch.prune = true;
      alias = {
        l = ''log --pretty=format:"%C(auto)%h%d%C(reset) %C(blue)%cn %C(cyan)[%cr]%C(reset) %s"'';
        lg = ''log --graph --pretty=format:"%C(auto)%h%d%C(reset) %C(blue)%cn %C(cyan)[%cr]%C(reset) %s"'';
        ld = ''log --pretty=format:"%C(auto)%H%d%C(reset) %C(blue)%cn %C(cyan)[%cd]%C(reset) %s"'';
        lplus = ''log --stat --oneline --pretty=format:"%C(auto)%H%d%C(reset) %C(blue)%cn %C(cyan)[%cr; %cd]%C(reset)%n%C(#F1502F)%B"'';
      };
    };
  };
}
