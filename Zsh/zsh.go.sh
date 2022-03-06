# go support --2110

debug LOADING zsh.go.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ ! -z $NO_zshGo ] && debug exiting zsh.go.sh && return 

alias gopd="bin/bumppatch ; bin/godebug"
alias gomi="gomid"
alias gomid="bin/bumpminor ; bin/godebug"
alias goma="gomid"
alias gomad="bin/bumpmajor ; bin/godebug"

alias god=bin/godebug
alias gor=bin/gorelease

alias gode='execHelp debug $*'
alias gore='execHelp release $*'
alias goue='execHelp upx $*'

alias bpa=bin/bumppatch
alias bmi=bin/bumpminor
alias bma=bin/bumpmajor

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