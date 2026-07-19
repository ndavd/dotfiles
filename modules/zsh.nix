{
  config,
  pkgs,
  ...
}:
let
  inherit (config.host) owner;
in
{
  users.users.${owner}.shell = pkgs.zsh;
  system.userActivationScripts.zshrc = "touch .zshrc";

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableBashCompletion = false;
    enableLsColors = true;

    syntaxHighlighting.enable = true;

    histSize = 1000;

    setOptions = [
      "NO_BEEP"
      "HIST_IGNORE_SPACE"
      "NO_PATH_DIRS"
    ];

    promptInit = /* zsh */ ''
      SAVEHIST=0

      autoload -U colors && colors

      _isConsole() {
        [[ $TERM =~ "linux|screen" ]] && return 0 || return 1
      }

      _p_bold='%B'
      _p_underline='%U'
      _p_clear='%f%k%b%u'
      if _isConsole; then
        _p_blue="$_p_bold%F{blue}"
        _p_git="$_p_bold%F{cyan}"
      else
        _p_blue='%F{12}'
        _p_git='%F{47}'
      fi
      [[ $UID -eq 0 ]] && _p_pwd="$_p_bold%F{red}" || _p_pwd="$_p_blue"
      _isConsole && dirty="*" staged="+" || dirty="‼" staged="✔"

      _p() {
        if [[ $PATH == /nix/store* ]]; then
          nix_prefix="%F{cyan}<nix>%f"
        else
          nix_prefix=""
        fi

        p="$nix_prefix$_p_pwd%1~$_p_clear"

        local git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        if [[ -n $git_branch ]]; then
          p+="["
          if [[ $git_branch =~ ^(main|master)$ ]] ; then
            p+="$_p_git$git_branch$_p_clear"
          else p+="$git_branch"; fi

          git diff --no-ext-diff --quiet 2>/dev/null || p+="$_p_bold%F{1}$dirty"
          git diff-index --cached --quiet HEAD 2>/dev/null || p+="$_p_bold%F{2}$staged"
          p+="$_p_clear]"
        fi

        if _isConsole; then
          [[ $UID -eq 0 ]] && p+="%F{red}#$_p_clear" || p+="$_p_bold%F{208}\$$_p_clear"
        else
          [[ $UID -eq 0 ]] && p+="%F{red}₿$_p_clear" || p+="%F{208}₿$_p_clear"
        fi
        PROMPT="''${p} "
      }

      precmd() {
        _p;
        print -Pn "\e]2;''${SHELL##*/} %~\a";
      }

      preexec() {
        print -n "\\e]2;''${3}\\a";
      }
    '';

    loginShellInit = /* zsh */ ''
      [[ $TERM == linux ]] && fastfetch
    '';

    interactiveShellInit = /* zsh */ ''
      # umask
      umask 077

      # zsh-vi-mode plugin
      ZVM_CURSOR_STYLE_ENABLED=false
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      zstyle ':completion:*' menu select
      _comp_options+=(globdots)
      bindkey -M isearch '^M' accept-search

      autoload edit-command-line
      zle -N edit-command-line
      bindkey '^X^E' edit-command-line

      fzfa() {
        fd --unrestricted --full-path --color=always | fzf
      }
      f() {
        local dir="$(fd --unrestricted --type d --full-path --color=always -E '/.*' -E node_modules -E .git -E target | fzf)"
        [[ -n $dir ]] && cd "$dir"
      }
      book() {
        local file="$(fd --unrestricted --color=always . /home/${owner}/data/books | fzf)"
        [[ -n $file ]] && zathura "$file"
      }
      video() {
        local file="$(fd --no-ignore --color=always --glob '*.{mp4,mkv,mpeg,webm,avi,h264,mov,wmv}' /home/${owner}/data/videos | fzf)"
        [[ -n $file ]] && mpv "$file"
      }
    '';
  };
}
