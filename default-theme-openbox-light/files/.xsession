# This program, based on code found in the gpg-agent man page, is 
# presumably licensed under the GPL.
#
# As the effects of this default .xsession on an account using
# (t)csh are not yet known, feedback and/or suggestions are welcomed.

if [ -x "$(which gpg-agent)" ]; then
  if test -f $HOME/.gpg-agent-info &&    kill -0 $(cut -d: -f 2 $HOME/.gpg-agent-info) 2>/dev/null; then
    GPG_AGENT_INFO=$(cat $HOME/.gpg-agent-info)
    export GPG_AGENT_INFO
  else
    eval $(gpg-agent --daemon)
    echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
  fi
fi

# Note that the new option --write-env-file may be used instead.

# You should always add the following lines to your .bashrc or whatever
# initialization file is used for all shell invocations:
 
GPG_TTY=$(tty)
export GPG_TTY

