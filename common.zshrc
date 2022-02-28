#setopt autocd                   #  
#setopt NO_CASE_GLOB
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY            # share history across multiple zsh sessions
setopt APPEND_HISTORY           # append to history

SAVEHIST=5000
HISTSIZE=2000
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

setopt INC_APPEND_HISTORY       # adds commands as they are typed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST   # expire duplicates first
setopt HIST_IGNORE_DUPS         # do not store duplications
setopt HIST_FIND_NO_DUPS        # ignore duplicates when searching
setopt HIST_REDUCE_BLANKS       # removes blank lines from history

#disable auto correct # correct_all will disable autocorrect for options only, not for commands themselves.
# for all including commands use just correct
unsetopt correct_all

set +o nomatch    # get rid of the error messages if a shell globbing pattern cannot be resolved

#### Reverting Shell Options for Defaults
## emulate -LR zsh                 # Useful in scripts

autoload -Uz compinit && compinit   # load completions for curl,...

# --------------------------------------------------------------------------- Functionality block, alphabetically sorted
# ---- ansible -----------------------------------------------------------------------

function ansibleListTags() {
   for i in $* ; do ansible-playbook --list-tags $i 2>&1 ; done | grep "TASK TAGS" | cut -d":" -f2 | awk '{sub(/\[/, "")sub(/\]/, "")}1' | sed -e 's/,//g' | xargs -n 1 | sort -u
}

# ---- LaTeX -----------------------------------------------------------------------

function lat() { # better latex call
    local file
    for file in $*
    do
        CURRENT_FILE=$(basename "$file" .tex)
        CURRENT_FILE=$(basename "$CURRENT_FILE" .)
        latex "${CURRENT_FILE}" && latex "${CURRENT_FILE}" && latex "${CURRENT_FILE}" && dvips "${CURRENT_FILE}"    # 3 times to get all references right
    done
}

# ---- Processes -----------------------------------------------------------------------

function killUser() { # kill all processes of a user $*
    local user
    for user in $*
    do
        echo killing user $user... 1>&2
        ps -ef | grep $user | awk '{print $2}' | xargs kill -9
    done
}

# ---- COMMON  -----------------------------------------------------------------------
# ---- COMMON  -----------------------------------------------------------------------
# ---- COMMON  -----------------------------------------------------------------------

function rlFull() {
   debugSet
   debug common.zshrc in rl
   [ -f "$PATHFILE" ] && debug4 PATHFILE found, deleting it && /bin/rm -f ${PATHFILE} # reload this file w/ recreating the cache
   [ -f "$TEXPATHFILE" ] && debug4 TEXPATHFILE found, deleting it && /bin/rm -f ${TEXPATHFILE} # reload this file and flush all caches (PATH, TEXPATH)
   for file in ~/.zshenv ~/.zshrc ; do source $file; done
   debugUnset
}

# user-specific pre/post/... configuration
function loadSource() {
   if [ -r "$HOME/.zshrc.$1" ] ; then debug loadSource .zshrc.$1 ; source "$HOME/.zshrc.$1" ; else 
      debug loadSource FILE NOT FOUND $HOME/.zshrc.$1 
   fi
}

# If multiple users log in as user hadm, determine the real user logging in by identifying her/his SSH finger-print
function realUserForHadm() {
   debug common.zshrc in realUserForHadm
   if [[ $(id -un) == hadm && $(uname) = Linux && ! $(uname -r) =~ Microsoft && $(id -Gn) =~ wheel ]] ; then
      export HADM_LAST_LOGIN_FINGERPRINT=${HADM_LAST_LOGIN_FINGERPRINT:-$(sudo journalctl -r -u ssh -g 'Accepted publickey' -n 1 -q 2&>/dev/null| awk '{ print $NF }')}

      if [ "$SSH_CLIENT" != "" -a ! -z "$HADM_LAST_LOGIN_FINGERPRINT" ] ; then
         for file in ~/.ssh/*.pub
         do
            if [ $(ssh-keygen -lf $file | grep $HADM_LAST_LOGIN_FINGERPRINT | wc -l) -eq 1 ] ; then
               export HADM_LAST_LOGIN_USER=$(basename $file .pub)
               echo You are $HADM_LAST_LOGIN_USER. Welcome.
               break
            fi
         done
      fi
   fi
}

function main() {
   umask 002 # umask for group work
   loadSource pre
   case $- in
      *i*) #  "This shell is interactive"
         [ -z $NO_zshSetVersion ]        && [ -f "$PROFILES_CONFIG_DIR/zsh.version.sh" ] && source "$PROFILES_CONFIG_DIR/zsh.version.sh" && zshSetVersion
         [ -z $NO_zshShellAliases ]      && [ -f "$PROFILES_CONFIG_DIR/zsh.aliases.sh" ] && source "$PROFILES_CONFIG_DIR/zsh.aliases.sh" && zshShellAliases
         [ -z $NO_setupGit ]             && [ -f "$PROFILES_CONFIG_DIR/zsh.git.sh" ] && source "$PROFILES_CONFIG_DIR/zsh.git.sh" && setupGit
         [ -z $NO_setupK8s ]             && [ -f "$PROFILES_CONFIG_DIR/zsh.k8s.sh" ] && source "$PROFILES_CONFIG_DIR/zsh.k8s.sh" && setupK8s
         [ -z $NO_setupOSSpecifics ]     && [ -f "$PROFILES_CONFIG_DIR/zsh.os-specific.sh" ] && source "$PROFILES_CONFIG_DIR/zsh.os-specific.sh" && setupOSSpecifics
         [ -z $NO_setupCrypto ]          && [ -f "$PROFILES_CONFIG_DIR/zsh.crypto.sh" ] && source "$PROFILES_CONFIG_DIR/zsh.crypto.sh"
         [ -z $NO_sshSetup ]             && sshSetup     # part of zsh.crypto.sh
         [ -z $NO_realUserForHadm ]      && realUserForHadm
         [ -z $NO_loadPost ]             && loadSource post
         NEWLINE=$'\n'
         if [ -z $NO_ownPrompt ] ; then
            setopt PROMPT_SUBST
            PROMPT='%(?..%F{red}%?%F{white} • )%F{green}%n@%m%F{white} • %* • %F{yellow}$(gitContents)%F{white} • %F{red}$AWS_PROFILE%F{white} • %{%F{cyan}%c%{%F{white}%}'${NEWLINE}
            RPROMPT=
         fi
         bindkey '^R' history-incremental-search-backward
         ;;
      *) #echo "This is a script";;
         [ -z $NO_loadPost ]             && loadPost
         ;;
   esac
}

main $@
# EOF
