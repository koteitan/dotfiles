# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file
shopt -s histappend

# ignore commands for history
HISTIGNORE="git restore*:$HISTIGNORE"
HISTIGNORE="rm -rf*:$HISTIGNORE"
HISTIGNORE="rm -r*:$HISTIGNORE"


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# update the values of LINES and COLUMNS after each command if the window size changed
shopt -s checkwinsize

# use wildcard expansion for ** (recursive globbing)
shopt -s globstar

# less can see pdf, etc.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
    xterm|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[32m\]\n\$ \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# git completion
if [ -f ~/lib/git-completion.bash ]; then
    . ~/lib/git-completion.bash
fi

alias vivimrc='vim ~/.vimrc'
alias vibashrc='vim ~/.bashrc'
#alias vivimrc='nvim ~/.config/nvim/init.vim'
#alias vibashrc='nvim ~/.bashrc'
alias bashrc='source ~/.bashrc'
alias viwezterm='vim ~/wezterm/wezterm.lua'

alias jaman='LANG=ja_JP.UTF-8 man'

PATH="$PATH":~/bin/
PATH="$PATH":/opt/nvim/
export EDITOR=vim
export VISUAL=vim

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
#export DISPLAY=`hostname`.mshome.net:0.0
export LIBGL_ALWAYS_INDIRECT=1
#eval "$(pyenv init -)"

alias xterm="xterm -bg '#002244' -fg '#ffffff' -cr '#ff0000' -bd '#ffff00'"
alias acroread="evince"

set bell-style visible

export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64/bin/javac/usr/lib/jvm/java-17-openjdk-amd64/bin"

hostname -I

# third parties ----------------------------
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# go
PATH="$PATH":/usr/local/go/bin

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# qmk
#source ~/qmk_utils/activate_wsl.sh
export PATH="~/.local/bin:$PATH"

# float calc
pycalc(){
  python -c "print($1)"
}
#

#umask
umask 0022

#cargo
. "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

alias dusort='du -h --max-depth=1 | sort -h |tee dusort.txt'

# ディレクトリ履歴を保存するファイル
export DIR_HIST_FILE="$HOME/.dir_history"

# d コマンド
function d {
    if [[ ! -f "$DIR_HIST_FILE" ]]; then
        touch "$DIR_HIST_FILE"
    fi

    # 現在のディレクトリを履歴に保存
    if [[ -z "$1" ]]; then
        selected=$(tac "$DIR_HIST_FILE" | fzf --height 40% --reverse --prompt="Select directory: ")
        if [[ -n "$selected" && -d "$selected" ]]; then
            cd "$selected" || echo "Directory not found: $selected"
        fi
    else
        if [[ -d "$1" ]]; then
            cd "$1" || return
            pwd >> "$DIR_HIST_FILE"
            sort -u -o "$DIR_HIST_FILE" "$DIR_HIST_FILE"
        else
            echo "Directory not found: $1"
        fi
    fi
}

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Claude
alias killclaudes='pkill -f claude'

# private settings
if [ -f "$HOME/.bashrc_private" ]; then
    source "$HOME/.bashrc_private"
fi

