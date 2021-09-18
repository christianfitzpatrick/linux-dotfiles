autoload -Uz compinit
compinit

# Bloated plugin manager is bloated
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fox_mod"

plugins=(gitfast git-open fzf-tab zsh-syntax-highlighting zsh-interactive-cd zsh-system-clipboard golang)
source $ZSH/oh-my-zsh.sh

# Line editing stuff and vim emulation mode
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd e edit-command-line
bindkey -v
bindkey "^?" backward-delete-char
bindkey '^H' backward-kill-word


# Jump to beginning/end of line with H and L
bindkey -sM vicmd 'H' '^'
bindkey -sM vicmd 'L' '$'

KEYTIMEOUT=1

mkcd () {
    mkdir -p "$1"
    cd "$1"
}

# Copies current line in shell to clipboard
copybuffer () {
  if which clipcopy &>/dev/null; then
    printf "%s" "$BUFFER" | clipcopy
  else
    echo "clipcopy function not found. Please make sure you have Oh My Zsh installed correctly."
  fi
}

zle -N copybuffer
bindkey "^O" copybuffer

# Aliases
alias sl="ls"
alias zathura="zathura --fork"
alias z="zathura --fork"
alias vlc="vlc --start-paused"
alias tmux="TERM=screen-256color-bce tmux"
alias notion="notion-snap"
alias brave="brave-browser"

# Java Apps: How DO They Work?
alias ghidra="$HOME/Downloads/ghidra_9.2.3_PUBLIC/ghidraRun"

# Pipe into this to push it to system clipboard
alias copy="xclip -selection clipboard"

# I use Vim a bunch
alias vim=nvim
alias v="vim"
alias :q="exit"
alias :qa=":q && :q"
alias :Q="exit"
alias editor=vim
alias cim=vim
alias ivm=vim

# Quick access to config files
alias vrc="vim ~/.vimrc"
alias nvrc="vim ~/.config/nvim/init.vim"
alias vi3="vim ~/.config/i3/config"
alias vsh="vim ~/.zshrc"

alias pwd="pwd && pwd | copy"
alias weather="curl wttr.in"

# CLI tool customizations
alias cat='bat --theme=gruvbox --paging=never --style="grid"'
alias tree="lsd --tree"
alias man="mangl"
alias kb="source ~/.Xmodmap"

# Python stuff
alias python="python3.9"
alias py="python3.9"
alias pip="pip3.9"

# Reload shell
alias ez="exec zsh"

# Apps that don't use GNU readline by default
alias racket="rlwrap -a racket"
alias redis-cli="rlwrap -a redis-cli"

# Node REPL doesn't use GNU readline
# But there's an env var that should work for this
if [ $(command -v rlwrap) ] ; then
  alias node='NODE_NO_READLINE=1 rlwrap node'
fi

# Spin up quick http servers on port 8000 in the current directory
alias pysrv="~/py_server.sh"
alias nsrv="~/node_server.sh"

# Set some nicer MPV defaults and always fork
function mpv_wrap() {
    mpv --really-quiet --volume=50 --keep-open=yes --cache=yes $1 &;
    disown;
}

alias mpv="mpv_wrap"

# Fixes some vim mode stuff
bindkey -v
KEYTIMEOUT=1

# Disable ctrl S accidentally suspending the TTY
# I do this on accident when I miss my tmux prefix key
stty stop ""

# Do not remember where this came from but colors are always nice, I guess
LS_COLORS='rs=0:di=1;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=
00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc
=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.t
xz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01
;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;
31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01
;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01
;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjp
eg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.
xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35
:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01
;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01
;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01
;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;5:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00
;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg
=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# FZF config stuff
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='
    --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
    --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
    --select-1
'

# RipGrep config
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Python environment stuff
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Python REPL config
export PYTHONSTARTUP=~/.pyrc
export PYTHONPATH=$PYTHONPATH:/usr/src

# GHC stuff
[ -f "/home/christian/.ghcup/env" ] && source "/home/christian/.ghcup/env"

# Keyboard and display fixes
setxkbmap -option caps:none
source ~/.Xmodmap
xgamma -gamma 0.9 > /dev/null 2>&1

# Show the newest file(s) in dir
function new() {
    local num=${1:-1}
    ls -1t | head -$num
}

# More PATH stuff
PATH="/home/christian/.local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/go/bin:$PATH"
source /home/christian/.config/broot/launcher/bash/br

alias attach="tmux attach-session -t"
