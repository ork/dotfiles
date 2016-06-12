# Bash resource file
# ------------------
#
# Based upon Debian's default bashrc.


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
    else
    color_prompt=
    fi
fi

# Username is displayed in red if it is root
if [[ $EUID -ne 0 ]]; then
    user_color="01;34m"
else
    user_color="01;31m"
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[$user_color\]\u\[\033[00m\]@\[\033[01;04;32m\]\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Apple stuff
if hash brew 2>/dev/null; then
    export HOMEBREW_PREFIX=$(brew --prefix)

    if [ -f ${HOMEBREW_PREFIX}/etc/bash_completion ]; then
        . ${HOMEBREW_PREFIX}/etc/bash_completion
    fi

    # Use GNU userland without "g" prefix to binary name
    if [ -d "${HOMEBREW_PREFIX}/opt/coreutils" ]; then
        export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
        export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"
    fi
    if [ -d "${HOMEBREW_PREFIX}/opt/gnu-sed" ]; then
        export PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:${PATH}"
        export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:${MANPATH}"
    fi
    if [ -d "${HOMEBREW_PREFIX}/opt/gnu-tar" ]; then
        export PATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:${PATH}"
        export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:${MANPATH}"
    fi
    if [ -d "${HOMEBREW_PREFIX}/opt/grep" ]; then
        alias grep='ggrep --color=auto'
        alias egrep='gegrep --color=auto'
        alias fgrep='gfgrep --color=auto'
    fi
    if [ -d "${HOMEBREW_PREFIX}/opt/findutils" ]; then
        export MANPATH="/usr/local/opt/findutils/libexec/gnuman:${MANPATH}"
        alias find='gfind'
        alias locate='glocate'
        alias updatedb='gupdatedb'
        alias xargs='gxargs'
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# 256 colors
[[ ! -v TMUX ]] && export TERM=xterm-256color

if [ -f /usr/share/dircolors/dircolors.256dark ]; then
    eval $(dircolors /usr/share/dircolors/dircolors.256dark)
fi

# Color configuration for less(1)
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# A load of other aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls --classify --tabsize=0 --literal --show-control-chars --human-readable --group-directories-first'
alias lolmatrix='tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias selfie='gst-launch-1.0 -e v4l2src num-buffers=1 ! textoverlay font-desc="Sans 30" text="Live from Pluto" shaded-background=true auto-resize=false ! jpegenc ! filesink location=/tmp/pouet.jpg'

