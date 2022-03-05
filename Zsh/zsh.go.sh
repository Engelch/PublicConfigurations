# go support --2110

alias bp="bin/patch ; bin/debug"
alias bm="bmi"
alias bmi="bin/minor ; bin/debug"
alias bma="bin/major ; bin/debug"

alias bd=bin/debug
alias br=bin/release

alias bde='execHelp debug $*'
alias bre='execHelp release $*'
alias bue='execHelp upx $*'

if [ -z $_goPathCheck ] ; then
    _goPathCheck=yes
    _p=$(ls $HOME/sdk/ | tail -n 1)
    [ -d $HOME/sdk/$_p/bin ] && echo local go in $HOME/sdk/$_p/bin exists && PATH=$HOME/sdk/$_p/bin:$PATH
    unset _p
fi

function execHelp() {
    local __os=$(uname | tr "A-Z" "a-z")
    local __app=$(pwd | xargs basename)
    local __arch=$(uname -m | tr "A-Z" "a-z")
    [ "$__arch" = x86_64 ] && __arch=amd64
    [ -z $1 ] && echo execHelp expects an argument. && return
    local __env=$1
    shift

    build/${__env}/${__os}_${__arch}/${__app} $*
}
