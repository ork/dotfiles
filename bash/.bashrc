# If not running interactively, don't do anything
[ -z "${PS1}" ] && return

# Basic shell configuration
shopt -s checkwinsize histappend
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# Colour support valve
if hash tput 2>/dev/null && tput setaf 1 >&/dev/null; then
    [[ ! -v LET_ME_BE_DEPRESSED ]] && _ENABLE_COLORS=yes
fi

function __prompt_command {
    local EXIT_CODE=$?
    local P_USER P_HOST P_PAHT
    local LAST_STATUS='' GIT_STATUS=''
    local -A COLORS=(
        [RESET]='\[\e[0m\]'
        [USER]='\[\e[00;34m\]'
        [ROOT]='\[\e[01;31m\]'
        [HOST]='\[\e[01;04;32m\]'
        [PAHT]='\[\e[01;31m\]'
        [GIT]='\[\e[00;32m\]'
        [EXIT]='\[\e[00;31m\]'
    )

    if hash __git_ps1 2>/dev/null; then
        local GIT_PS1_SHOWDIRTYSTATE=1
        GIT_STATUS="${COLORS[GIT]}$( __git_ps1 '(%s) ' )${COLORS[RESET]}"
    fi

    if [[ $EXIT_CODE != 0 ]]; then
        if [[ $EXIT_CODE < 128 ]]; then
            LAST_STATUS="${COLORS[EXIT]}"
        # else
        #     # TODO Special case for ^C when no input
        #     LAST_STATUS="[$( kill -l ${EXIT_CODE} )] "
        fi
    fi

    if [[ ${EUID} != 0 ]]; then
        P_USER="${COLORS[USER]}\u${COLORS[RESET]}"
        LAST_STATUS+='\$'
    else
        P_USER="${COLORS[ROOT]}\u${COLORS[RESET]}"
        LAST_STATUS+='#'
    fi

    P_HOST="${COLORS[HOST]}\h${COLORS[RESET]}"
    P_PAHT="${COLORS[PAHT]}\w${COLORS[RESET]}"

    export PS1="${COLORS[RESET]}${P_USER}@${P_HOST}:${P_PAHT} ${GIT_STATUS}${LAST_STATUS}${COLORS[RESET]} "
}

if [[ -v _ENABLE_COLORS ]]; then
    PROMPT_COMMAND=__prompt_command
else
    export PS1='\u@\h:\w $ '
fi

# Use bash completions
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Use custom aliases and functions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Apple stuff
if hash brew 2>/dev/null; then
    export HOMEBREW_PREFIX=$(brew --prefix)

    _BREW_PACKAGES=(
        'coreutils'
        'findutils'
        'gnu-sed'
        'gnu-tar'
        'gnu-units' # Add the gnu{bin,share/man} paths
        'grep' # Add the gnu{bin,share/man} paths
    )

    # Use GNU userland without "g" prefix to binary name
    for _brew_package in "${_BREW_PACKAGES[@]}"; do
        _brew_package="${HOMEBREW_PREFIX}/opt/${_brew_package}/libexec"

        if [ -d "${_brew_package}" ]; then
            export PATH="${_brew_package}/gnubin:${PATH}"
            export MANPATH="${_brew_package}/gnuman:${MANPATH}"
        fi
    done

    unset _BREW_PACKAGES _brew_package

    if [ -f ${HOMEBREW_PREFIX}/etc/bash_completion ]; then
        . ${HOMEBREW_PREFIX}/etc/bash_completion
    fi

    export MANPATH=$(manpath)

    # Prevent ^Y from stopping the running process
    stty dsusp undef
fi

# Commands colour support
if [ -v _ENABLE_COLORS ] && hash dircolors 2>/dev/null ; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    if [ -f /usr/share/dircolors/dircolors.256dark ]; then
        eval $(dircolors /usr/share/dircolors/dircolors.256dark)
    fi
fi

# Make less(1) more friendly for non-text input files
if hash lesspipe 2>/dev/null; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi
# Color configuration for less(1)
if [ -v _ENABLE_COLORS ]; then
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;32m'
fi

# Rich colour support
if [ -v TMUX ]; then
    export TERM=xterm-256color
fi

# Some variables
export EDITOR='vim'
export PAGER='less'

unset _ENABLE_COLORS
