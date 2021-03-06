# Source Prezto.
if [[ -s $HOME/.zprezto/init.zsh ]]; then
  source $HOME/.zprezto/init.zsh
fi
eval "$(fasd --init auto)"
# aliases
alias vi="vim"

brew-load() {
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.$1.plist
}

brew-unload() {
  launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.$1.plist
}

# Git blows up because of CA for SSL, ignore it
#export GIT_SSL_NO_VERIFY=true

conflicts='grep -rI "<<<" *'

#alias vncstart="vncserver -geometry 1440x900 -alwaysshared -autokill -dpi 96 :1"
#alias vncstop="vncserver -kill :1"
alias xor="cd ~/src/src.xor.exchange/xor/xor"
alias github="cd ~/src/github.com"
alias gophercon="cd ~/src/github.com/gophercon/gc15"
alias gopheracademy="cd ~/src/github.com/gopheracademy/gopheracademy-web"
alias bketelsen="cd ~/src/github.com/bketelsen"

alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

export PATH=./bin:$GOPATH/bin:/usr/local/go/bin:/opt/local/bin:/usr/local/sbin:/usr/local/bin:/usr/local/cuda-6.5/bin:$PATH

export LD_LIBRARY_PATH=/usr/local/cuda-6.5/lib64:$LD_LIBRARY_PATH
# Tab Completion of .ssh/known_hosts
local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} ) 
zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
#

export TERM=xterm-256color
export XDG_CONFIG_HOME=~/.config

if [ `uname` = "Darwin" ]; then
	alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
fi

