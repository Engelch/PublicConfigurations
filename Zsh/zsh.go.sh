# go support --2110

debug LOADING zsh.go.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ ! -z $NO_zshGo ] && debug exiting zsh.go.sh && return 

alias gopad="bumppatch ; godebug"
alias gopd=gopad
alias gomid="bumpminor ; godebug"
alias gomi="gomid"
alias gomad="bumpmajor ; godebug"
alias goma="gomid"

alias god=godebug
alias gor=gorelease

alias gode='execHelp debug $*'
alias gore='execHelp release $*'
alias goue='execHelp upx $*'

alias bpa=bumppatch
alias bmi=bumpminor
alias bma=bumpmajor

if [ -z $_goPathCheck ] ; then
    _goPathCheck=yes
    _p=$(ls $HOME/sdk/ 2> /dev/null | tail -n 1)
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
