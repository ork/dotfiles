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
