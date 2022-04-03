# LaTeX setup might still be a bit Darwin-specific
functions setupLaTeX() {
    debug4 latex bins....
    _latex=$(find /usr/local/texlive -maxdepth 4 -name universal-darwin &>/dev/null | sort | tail -n1)
    [ ! -z $_latex ] && PATH=$PATH:$_latex
    # +o nomatch ::= by default, if a command line contains a globbing expression which doesn't match anything, Zsh will print the error message you're seeing, and not run the command at all. 
    [ -d /mnt/c/ ] && debug4 latex bins WSL..... && _jdk=$(setopt +o nomatch; find /mnt/c/Program\ Files/Java/jdk* -maxdepth 2 -name bin &>/dev/null | sort -n | tail -n1)
    [ ! -z $_jdk ] && PATH=$PATH:$_jdk

    if $(which latex > /dev/null); then
        debug4 latex found, building cache file...
        # executing the finds takes time. So, let's cache the result.
        TEXBASEDIR=${TEXBASEDIR:-/usr/local/texlive}
        TEXPATHFILE="$HOME/.zshrc.tex.path"
        if [ -d "$TEXBASEDIR" -a ! -f "$TEXPATHFILE" ] ; then
        debug4 creating TEXPATHFILE $TEXPATHFILE...
        # determine current distribution (just for a century :-)
        TEX_DISTRIB_DIR=$(find /usr/local/texlive -type d -mindepth 1 -maxdepth 1 | grep /20 | tail -n 1)
        debug4 TEX_DISTRIB_DIR is $TEX_DISTRIB_DIR
        # determine non-annual TeX-directories (not required at the moment)
        # TEX_OTHER_DIRS=$(ls -d1 /usr/local/texlive/* | egrep -v '.*20[[:digit:]][[:digit:]]')
        _os=$(uname | tr '[A-Z]' '[a-z]')
        # limit depth for speed purposes
        find "$TEX_DISTRIB_DIR" -type d -maxdepth 4 -name 'bin' | egrep '/bin$'  >| $TEXPATHFILE
        find "$TEX_DISTRIB_DIR" -type d -maxdepth 4 -name "\*$_os"   >> $TEXPATHFILE
        fi
        if [ -f "$TEXPATHFILE" ] ; then
        for _line in $(egrep -v '^[[:space:]]*$' $TEXPATHFILE) ; do
            PATH=$PATH:"$_line"
        done
        fi
    else
        err4 NOT FOUND latex
    fi

}

debug LOADING zsh.path.latex.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setupLaTeX

# EOF
