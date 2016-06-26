# Install Vim plugins
function dotfiles_configure_vim {
    local vundle_path="${HOME}/.vim/bundle/Vundle.vim"

    if [ ! -d "${vundle_path}" ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git "${vundle_path}"
    fi

    vim +PluginInstall +qall
}

# Use vim plugin to read manual pages
function __viman {
    ${1} -c  "Man ${2} ${3}" -c 'silent only'
}
function viman {
    __viman vim ${1} ${2}
}
function gviman {
    __viman gvim ${1} ${2}
}
function mviman {
    __viman mvim ${1} ${2}
}
complete -F _man viman gviman mviman

#
# APPLE STUFF
#

# List macOS applications
function mac_apps {
    find /Applications/ "${HOME}"/Applications -maxdepth 1 -iname '*.app' -print0 | \
    xargs -P 4 -0 basename -s '.app'
}

# Ouvrir application en français
function fropen {
    open -a "${1}" --args -AppleLanguages '(French)' -AppleLocale 'fr_FR'
}

# Render manual page in glorious A4
function pman {
    cat $(man -w "${1}") | groff -Tps -dpaper=a4 -P-pa4 -mandoc | open -f -a Preview
}
complete -F _man pman

function dotfiles_configure_brew {
    while read line; do
        brew tap ${line}
    done < "${HOME}"/.local/share/brew/default_taps

    while read line; do
        brew install ${line}
    done < "${HOME}"/.local/share/brew/default_packages
}

# Aliases
alias lockscreen='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias dodo="osascript -e 'tell application \"System Events\" to sleep'"

#
# GENERIC STUFF
#

function waldo {
    egrep --color=always "${1}|" "${2--}"
}

alias treeg='tree -a -I .git'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls --classify --tabsize=0 --literal --show-control-chars --human-readable --group-directories-first'
