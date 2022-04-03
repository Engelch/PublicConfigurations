
# echo in zshenv

debug START dot.zshenv

# fix for docker
[ -z "$SHELL" ] && echo Setting SHELL... && export SHELL=/bin/zsh

# setopt noglob   # getting no error if a wildcard cannot be extended into strings
setopt ignoreeof                             # prevent ^d logout
setopt noclobber                             # overwrite protection, use >| to force

##############################################################################################

# =========================================================================================
# === generic library functions from bashTemplate v1.1.0 ==================================
# =========================================================================================
# =========================================================================================

# soMessage helps to write a message to stderr in reverse mode
function soMessage()
# always show such a message.  If known terminal, print the message
# in reverse video mode. This is the other way, not using escape sequences
{
    if [ "$TERM" = xterm -o "$TERM" = vt100 -o "$TERM" = xterm-256color  -o "$TERM" = screen ] ; then
        tput smso ; /bin/echo $* 1>&2 ; tput rmso
    else
        /bin/echo $* 1>&2
    fi
}

# debug functions. Only create output if debugSet was called before. Stop output if debugUnset was called.
function debugSet() {   export DEBUG_FLAG_BASH=TRUE ; }
function debugUnset() { export DEBUG_FLAG_BASH= ; }
function debug() { [ "$DEBUG_FLAG_BASH" = TRUE ] && echo '[DEBUG]' $* 1>&2 ; return 0 ; }
function debug4()       { [ "$DEBUG_FLAG_BASH" = TRUE ] && echo '[DEBUG]    ' $* 1>&2 ; return 0 ; }
function debug8()       { [ "$DEBUG_FLAG_BASH" = TRUE ] && echo '[DEBUG]        ' $* 1>&2 ; return 0 ; }
function debug12()       { [ "$DEBUG_FLAG_BASH" = TRUE ] && echo '[DEBUG]            ' $* 1>&2 ; return 0 ; }

# Write an error message to stderr
function error()        { soMessage 'ERROR:'$*; return 0; }
function error4()       { soMessage 'ERROR:    '$*; return 0; }
function error8()       { soMessage 'ERROR:        '$*; return 0; }
function warning()      { soMessage 'WARNING:'$*; return 0; }
# Write a message w/ potential indentation to stderr
function err()          { echo $* 1>&2; }             # just write to stderr
function err4()         { echo '    ' $* 1>&2; }      # just write to stderr w/ indentation
function err8()         { echo '        ' $* 1>&2; }  # just write to stderr w/ indentation

function errorExit()    { val=$1 ; shift ; error $* ; exit $val ; }

# =========================================================================================

# debugSet

# user-specific pre/post/... configuration
function loadSource() {
   if [ -r "$HOME/.zshrc.$1" ] ; then debug loadSource .zshrc.$1 ; source "$HOME/.zshrc.$1" ; else 
      debug4 loadSource FILE NOT FOUND $HOME/.zshrc.$1 
   fi
}

# setupPath sets the path
function setupPath() {
    export PATHFILE="$HOME/.zsh.profile.path"
    if [ ! -f "$PATHFILE" ] ; then
        debug4 PATHFILE $PATHFILE not found, creating it...
        # set up initial path
        [ $UID = 0 ] && debug4 root PATH initialisation &&  PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
        [ $UID != 0 ] && debug4 normal user PATH init &&    PATH=./bin:/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin
        # add directories if existing for all platforms
        for _POTENTIAL_DIR in \
            $HOME/go/bin \
            $HOME/Library/Android/sdk/platform-tools /usr/local/share/dotnet /usr/local/go/bin \
            $HOME/bin $HOME/Bin $HOME/.dotnet/tools $HOME/.rvm/bin \
            /usr/local/google-cloud-sdk/ $HOME/google-cloud-sdk/ $HOME/.pub-cache/bin /opt/flutter/bin \
            $HOME/.linkerd2/bin $HOME/.local/bin $HOME/google-cloud-sdk/bin \
            /opt/PublicConfigurations/bin $HOME/PublicConfigurations/bin $HOME/PublicConfigurations/bin_$(uname | tr [A-Z] [a-z])-$(uname -m)\
            /usr/local/google-cloud-sdk/bin \
            /opt/android-studio/bin
        do
            debug4 checking for dir $_POTENTIAL_DIR
            [ -d "$_POTENTIAL_DIR/." ] && debug8 adding path element $_POTENTIAL_DIR && PATH="$_POTENTIAL_DIR":$PATH
        done
        # only check for WSL
        [ -d /mnt/c/ ] && for _POTENTIAL_DIR in \
            /mnt/c/Windows/System32 /mnt/c/Windows /mnt/c/Windows/System32/wbem \
            /mnt/c/Windows/System32/WindowsPowerShell/v1.0 /mnt/c/Users/$USER/AppData/Local/Microsoft/WindowsApps \
            /mnt/c/go/bin /mnt/c/Program\ Files/Microsoft\ VS\ Code/bin \
            /mnt/c/Program\ Files/dotnet/ /mnt/c/Program\ Files/Haskell\ Platform/actual/bin \
            /mnt/c/Program\ Files/Haskell\ Platform/actual/winghci $HOME/$USER/AppData/Roaming/local/bin \
            /mnt/c/Program\ Files/Docker/Docker/resources/bin /mnt/c/Program\ Files/7-Zip \
            /mnt/c/Program\ Files/Affinity/Designer /mnt/c/Program\ Files/Affinity/Photo \
            /mnt/c/Program\ Files/MiKTeX\ 2.9/miktex/bin/x64 /mnt/c/Program\ Files/PDFCreator /mnt/c/Program\ Files/PDFsam\ Basic \
            /mnt/c/Program\ Files/VueScan /mnt/c/Program\ Files/VeraCrypt /mnt/c/Program\ Files/Wireshark \
            /mnt/c/Program\ Files/draw.io /mnt/c/Program\ Files/Mozilla\ Firefox /snap/bin/
        do
            debug4 checking for dir $_POTENTIAL_DIR
            [ -d "$_POTENTIAL_DIR/." ] && debug8 adding path element $_POTENTIAL_DIR && PATH="$_POTENTIAL_DIR":$PATH
        done

        # OS-specific paths
        if [ -z $NO_OS_Specifics ] ; then 
            if [ -f "$PROFILES_CONFIG_DIR/Zsh/zsh.path.$(uname).sh" ] ; then
                debug8 OS is $(uname)
                source "$PROFILES_CONFIG_DIR/Zsh/zsh.path.$(uname).sh"
            else
                err4 No OS-specific path file "$PROFILES_CONFIG_DIR/Zsh/zsh.path.$(uname).sh" found
            fi
        else
            debug4 NO_OS_Specifics was set
        fi    

        [ -z $NO_LaTeX ] && source $PROFILES_CONFIG_DIR/Zsh/zsh.path.latex.sh 

        # go sdk setup, NO_GoSDK might require a second load as loadSource pre is not executed before 
        if [ -z $NO_GoSDK -a -d $HOME/sdk ] ; then
            local -r _go=$(/bin/ls -1 $HOME/sdk/ | tail -n 1 | sed 's,/$,,')
            PATH=$HOME/sdk/$_go/bin:$PATH
            export GOROOT=$HOME/sdk/$_go/
            debug4  Setting PATH for local go environment and GOROOT to $GOROOT
        fi

        #### PATH should not be touched after this _line anymore, here begins the caching
        debug4 Writing PATHFILE $PATHFILE ...
        echo "PATH=\"$PATH\"" > "$PATHFILE"
    else
        debug4 .. PATHFILE $PATHFILE found, sourcing cache ...
        source "$PATHFILE"
        debug8 PATH is
        debug8 $PATH
    fi
    unset _POTENTIAL_DIR _os  _file _line _latex _jdk
}

loadSource env
[ -z $NO_setupPath ] && debug4 setupPath... && setupPath

export ZSH_DISABLE_COMPFIX=true
export LESS='-iR'    # -i := searches are case insensitive; -R := Like -r, but only ANSI "color" escape sequences are output in "raw" form. The default is to display control characters using the caret notation.
export PAGER=less

export RSYNC_FLAGS="-rltDvu --modfiy-window=1"     # Windows FS updates file-times only every 2nd second
export RSYNC_SLINK_FLAGS="$RSYNCFLAGS --copy-links" # copy s-links as files
export RSYNC_LINK='--copy-links'

export VISUAL=vim
export EDITOR=vim    # bsroot has no notion about VISUAL
export BLOCKSIZE=1K

debug STOP dot.zshenv
# EOF
