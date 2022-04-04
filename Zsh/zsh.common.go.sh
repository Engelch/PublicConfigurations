# go support --2110

debug LOADING zsh.go.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ ! -z $NO_zshGo ] && debug exiting zsh.go.sh && return 

alias gopad="checkIfCurrentVersionExisting debug patch"
alias gopd=gopad
alias gopa=gopad
alias gopar="checkIfCurrentVersionExisting release patch"

alias gomid="checkIfCurrentVersionExisting debug minor"
alias gomi="gomid"
alias gomir="checkIfCurrentVersionExisting release minor"

alias gomad="checkIfCurrentVersionExisting debug major"
alias goma="gomad"
alias gomar="checkIfCurrentVersionExisting release major"

alias god=godebug
alias gor=gorelease

alias exd=gode
alias gode='execHelp debug $*'
alias exr=gore
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

# checkIfCurrentVersionExisting checks if a binary exists for the current version, architecture, and environment. If not,
# it shall not increase the version number. It is a helper function to be called by gopad, gomid, gomad. If you you for
# example gopad and the compilation fails, then a next call for gopad would increase the version number further which is
# often not the intention.
# This script does not support cross compilation.
function checkIfCurrentVersionExisting() {
    if [ "$1" = debug -o "$1" = release ] ; then
        declare -r _releaseType=$1
    else
        err Wrong call to checkIfCurrentVersionExisting with '$1' being $1
        return
    fi
    if [ "$2" = patch -o "$2" = minor -o "$2" = major ] ; then
        declare -r _patch=$2
    else
        err Wrong call to checkIfCurrentVersionExisting increase type being $2
        return
    fi
    declare -r _binDir=./build
    declare -r _hostarch=$(uname -m | tr "A-Z" "a-z" | sed 's/x86_64/amd64/')
    declare -r _hostostype=$(uname | tr "A-Z" "a-z")
    declare -r _osDir=${_hostostype}_$_hostarch
    declare -r _outputDir=$_binDir/$_releaseType/$_osDir
    declare -r _appName=$(basename $(pwd))
    declare -r _checkname=$_outputDir/${_appName}-$(version.sh)
    debug _appName $_appName
    debug _hostostype $_hostostype
    debug _osDir $_osDir
    debug _outputDir $_outputDir
    debug _version $(version.sh)
    debug _checkname $_outputDir/${_appName}-$(version.sh)
    [ -e $_checkname ] && echo version existing, increasing && echo bump$_patch && bump$_patch && echo go$_releaseType && go$_releaseType
    [ ! -e $_checkname ] && echo version NOT existing && echo go$_releaseType && go$_releaseType
}

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
