debug LOADING zsh.common.sh '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'


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
   debug START rlFull
   [ -f "$PATHFILE" ] && debug4 PATHFILE found, deleting it && /bin/rm -f ${PATHFILE} # reload this file w/ recreating the cache
   [ -f "$TEXPATHFILE" ] && debug4 TEXPATHFILE found, deleting it && /bin/rm -f ${TEXPATHFILE} # reload this file and flush all caches (PATH, TEXPATH)
   for file in ~/.zshenv ~/.zshrc ; do source $file; done
   debugUnset
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

# EOF
