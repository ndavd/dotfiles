#
# ~/.zprofile
#

if [[ -r ~/.profile ]]; then . $HOME/.profile;
else echo 'No ~/.profile found.'; fi
