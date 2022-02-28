# vim:ts=2:sw=2
# hadm-profile alias common-profile

# echo common-profile.sh

# Copyright © 2021 by Christian ENGEL (mailto:engel-ch@outlook.com)
# License: BSD
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#    This product includes software developed by the <organization>.
# 4. Neither the name of the <organization> nor the
#    names of its contributors may be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# DESCRIPTION:
#  - common-profile can be used on its own as a default profile for bash and zsh.
#
# RELEASES:
# 3.16
# - PATH to include /snap/bin for Ubuntu
# 3.15
# - tlsCert shows SHA256-based fingerprints
# - git branch without pager
# - no git avv anymore, just gibr
# 3.14
# - sdecrypt introduced -k to keep to original, encrypted file.
# - no sudo for tlmgr (texlive on OSX).
# - errorExit added again.
# - add time to prompt to know when the former command ended.
# 3.13
# - sencrypt & sdecrypt integrated into common-profile.
# 3.12
# - fix for running in docker container.
# - tlsCert can issue hierarchical certificate (PEM) files.
# - fixed bug in tlsRsa2Pubkey.
# 3.11
# - 17: pkgU for dnf and yum based systems.
# - 16: new colour for directories with ls command on OSX.
# - fixing HISTFILE to use the one of the current, effective user.
# - imported existing functions err4, err8, ... from bash_template.
# - restructuring of the file splitting between utility functions (block 1) and setup-related ones (block 2).
# 3.10
# - use homebrew curl if installed.
# - issue warning if gnu-getopt not default getopt.
# - issue warning if curl not from homebrew.
# 3.9
# - change git merge strategy to rebase https://spin.atomicobject.com/2019/01/10/git-merging-vs-rebasing/
# - further tlsCalls to fully replace tlsUtils
# 3.8
# - iho fixed
# - add fingerprints for tls certificates, keys, and public keys (MD5)
# 3.7
# - add tmux colouring aliases
# 3.6
# - git list untracked files not in .gitignore
# 3.5
# - ash removed
# - listTags to list all ansible tags
# - iho extended for surrounding lines
# 3.4
# - ei for egrep -i
# - lla reintroduced
# - ip alias changed to ipi: stupid error
# - NO_loadBashCompletions now default to be set for non OSX platform
# - pkgU now only requires superuser permissions if an update has to be installed
# 3.3
# - iho function to search for inventory hosts
# - ls colour-support enabled for WSL2
# - texlive load latest fix, using now universal-bin/ directory
# 3.2
# - ssf does not show ProxyJump lines anymore to deliver more appropriate results
# - alias ip for curl https://ipinfo.io
# 3.1
# - gicma for a git commit -a 
# - ssf now offers colour output
# - ssf now shows 3 lines *after* match
# - ssf does not show comment lines anymore
# - gihelp gipua output improved
# 3.0
# - main integrated again into function
# 2.22
# - improved BSD compatibility
# - bsroot compatibility
# 2.20
# - journalctl issues errors for ubu18.04 (fixed w/ ubu20.04; no -g option); stderr to /dev/null
# - ASH_SURROUNDING_LINES now variable for ash to be reset in .profile.post
# - new function sshPriv2PubKey introduced
# - no rlFast anymore, replaced by rlFull
# - only rlFull rebuilds the PATH and TeX paths and turns on debug during the run
# - bash-completion support
# 2.19
# - eksctl completion
# - show AWS_PROFILE setting
# - help functions gihelp and k8help introduced
# 2.18
# - login speed improved by better journalctl call
# - apple silicon support for /opt/homebrew
# - ssf supports files ending w/ .conf or .config
# - extended systemctl-related calls, all beginning with sy..., no paging mode for status
# - ash to search ansible hosts files
# 2.17
# - start-script support .profile.pre and .profile.post
# - clean-up
# - fix zsh loading
# 2.16
# - no default setting for DISPLAY variable
# - use of PROMPT_COMMAND to synchronise different bash procesess for history
# 2.15.2
# - root alias with -E to preserve environment => logadd working for root
# 2.15.1
# - histappend to make sure that history is not deleted
# 2.14.3, 2.14.4
# - gitInit also sets pull strategy to default (merge)
# 2.14.2
# - vim sw + ts to 2 chars
# 2.14.1
# - ssh-grep as simpler reminder for ssf
# 2.13.2
# - output if COMMONRC_VERSION has changed
# 2.13.1
# - gitInit defines git last
# 2.12.2
# - OSX pkgU: sets currently the python interpreter to version 3.8 as 3.9 does not work.
# 2.12.1
# - ssf change to B3
# 2.12.0
# - printDirs for directory listings to be included into documentations
# - .7 added 'I had this case :-)'
# - f is now fgrep again
# 2.11.2
# - fixed accidential removal of loading of ssh-agent
# 2.11.1
# - CDPATH to contain .
# 2.11.0
# - CDPATH enabled for ~
# 2.10.1
# - Azure dev spaces
# 2.9.3
# - ssf to be extended for ~/.ssh/conf.d directories and search uses grep -iC instead of grep -iA
# 2.9.2
# - root alias: simplifying to login shell
# - split of setupOS into 2 further sub-functions setupGit, setupK8s to make the code more readable
# - split of setupOSspecific into setupLinux, setupOSX, setupBSD
# 2.9.1
# - root alias: explicitly load .profile
# 2.9.0
# - OSX: broot support integrated
# - debian: pkgU support
# 2.8.1
# - fix ssf for multiple files of type ~/.ssh/*.config
# 2.8.0
# - umask 0022 for win10
# 2.7.5
# - LaTeX distribution detection repaired
# 2.7.3, 2.7.4
# - CALC_ROOT_SHELL problem on windows10
# 2.7.2
# - bash PS1 shows exit code if non 0
# 2.7.1
# - clean up calling main
# 2.6.2
# - gitrm fix $2
# 2.6.1
# - gitrm added
# 2.5.2
# - alias docker -> docker.exe, kubectl -> kubectl.exe if docker for windows found
# 2.5.1
# - preserve history if multiple terminals are open
# 2.5.0
# - FC android studio inclusion
# 2.4.5
# GHC Windows Path inclusion + stack (haskell-language-server)
# 2.4.4
# - haskell path ~/.local/bin
# 2.4.3
# - DISPLAY to :0 by default
# 2.4.2
# - VS Code (win) and dotnet included into PATH
# 2.4.1
# OSX + Linux support for git storage of credentials
# 2.3.3
# - Windows Path
# 2.3.2
# - aliases added for rm~ <=> rmbak, brmd
# 2.3.1
# - gcloud path update
# 2.3.0
# - add FreeBSD, OSX specifics
# 2.2.3
# - RPROMPT added
# - %~ replaced for %4~ for non-root shells (zsh)
# 2.2.2
# - different PS1 separators for bash (|) and zsh (•))
# 2.2.1
# - documentation and reordering of functions
# 2.2.0
# - move all code to the end, functions first
# 2.1.1
# - clean up
# 2.1.0
# - root not login shell anymore
# - cleanup, reorganisation
# - suffix aliases
# 2.0.4
# - return 0 at EOF
# 2.0.3
# - simplified COMMONRC_FILE + zsh-compatible
# 2.0.2
# 2.0.1
# 2.0.0
# - caching for PATH introduced with 3 commands rl, rlFast, rlFull
# - /usr/local/bin before /bin:/usr/bin for non-root shells
# 1.11.0
# - sshFingerprint, sshCertificate added
# - gcp Path included
# - flutter Path included
# - linkerd2 Path included
# - lat LaTeX command added
# 1.10.1
# - gipu now a function to work properly for non-default repositories.
# 1.10.0
# - osx no warning if still using bash
# - zsh colourised prompt, more default settings based on https://scriptingosx.com/2019/08/moving-to-zsh-part-8-scripting-zsh/
# 1.9.2
# - PS1 gitContents in red
# 1.9.1
# - PS1 not root colour change: user@host in green, path in yellow
# 1.9.0
# - killUser script added
# - debugSet, debugUnset: debug Variable set no no value for unset, so that ${DebugFlag:-...} expressions can be used
# 1.8.0
# new alias k8gp
# 1.7.1
# kill ssh-agent at logout
# 1.6.1, 1.6.2
# - calculation of user using hadm only if $HADM_LAST_LOGIN_FINGERPRINT could be set
# 1.6.0
# - rl uses last sourced file
# 1.5.1
# - TeX-specific (OSX) path creation
# 1.4.12
# - PS1 as 2 line prompt
# 1.4.11
# - HISTFILE checks now also for existence.
# 1.4.10
# - user-detection not working if not in group wheel. fix.
# 1.4.9
# - HISTFILE changed to default naming with underscore
# - HISTSIZE enhanced to 8000
# 1.4.8
# - paths for WSL integrated
# 1.4.7
# 1.4.6
# - issue warning if .bash.history is not writable
# 1.4.5
# - Simplification Profile.d/...
# 1.4.4
# - gitInit added
# 1.4.3
# - determine user by ssh login journalctl only if SSH_CLIENT is set
# 1.4.2
# - add .zshrc in installCommonrc
# 1.4.1
# - new function installCommonrc
# 1.4.0
# - add gitPrompt support using gitContents
# - color prompts
# 1.3.1
# - add path to COMMONRC_FILE
# 1.3.0
# - rl fixed w/ COMMONRC_FILE
# 1.2.0
# - k8 aliased improved
# - alias gibr added
# 1.1.0
# - k8 aliases introduced
# 1.0.0
# - cleanup

##############################################################################################

# ================================================================================================
# === generic library functions from bashTemplate v1.1.0 =========================================
# ================================================================================================

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
# === normal use-case related functions ===================================================
# =========================================================================================

# iho searches hosts.yml files. It can be called in 2 modes:
# iho inventoryXYZ         # This will open all hosts*.yml files in less 
# iho inventoryXYZ bla     # This will output all lines in the hosts*.yml files 
#                          # that match bla (case-insensitive)
export IHO_SURROUNDING_LINES=3 # can be adjusted in ~/.profile.post
function iho() {
    if [ -z $2 ] ; then
        find "$1/." -name hosts\*.yml -print | xargs cat | less 
    else 
        echo "find $1/. -name hosts\*.yml -print | xargs cat | egrep -i -C $IHO_SURROUNDING_LINES $2"
        find "$1/." -name hosts\*.yml -print | xargs cat | egrep -i -C $IHO_SURROUNDING_LINES "$2"
    fi
}

function listTags() {
   for i in $* ; do ansible-playbook --list-tags $i 2>&1 ; done | grep "TASK TAGS" | cut -d":" -f2 | awk '{sub(/\[/, "")sub(/\]/, "")}1' | sed -e 's/,//g' | xargs -n 1 | sort -u
}

# better latex call
function lat()
{
   local file
   for file in $*
   do
      CURRENT_FILE=$(basename "$file" .tex)
      CURRENT_FILE=$(basename "$CURRENT_FILE" .)
      latex "${CURRENT_FILE}" && latex "${CURRENT_FILE}" && latex "${CURRENT_FILE}" && dvips "${CURRENT_FILE}"    # 3 times to get all references right
   done
}

#### encrypt & decryption helpers.
# These routines delete the original file. By default, they do not overwrite existing files. This can be changed by supplying the argument `-f`.

function sencrypt() {
   local file
   local keep=
   local force=
   [ $1 == -f ] && force=True && shift
   [ $1 == -k ] && keep=True && shift
   [ $1 == -f ] && force=True && shift # all 4 forms (1) -f -k (2) -k -f (3) -kf (4) -fk
   [ $1 == -kf -o $1 == -fk ] && keep=True && force=True && shift
   for file in $* ; do
      [ ! -z $force ] && /bin/rm -f $file.asc 2>/dev/null 
      [ -f $file.asc ] && error target file already exists for $file. && continue
      gpg -c -o $file.asc $file && [ -z $keep ] && /bin/rm -f $file
   done
}

function sdecrypt() {
   local file
   local force=
   local keep=
   local target
   [ $1 == -f ] && force=True && shift
   [ $1 == -k ] && keep=True && shift
   [ $1 == -f ] && force=True && shift # all 4 forms (1) -f -k (2) -k -f (3) -kf (4) -fk
   [ $1 == -kf -o $1 == -fk ] && keep=True && force=True && shift
   for file in $* ; do
      target=$(basename $file .asc)
      [ ! -z $force ] && /bin/rm -f $target 2>/dev/null 
      [ -f $target ] && error target file already exists for $file. && continue
      debug gpg -d -o $target $file
      gpg -d -o $target $file && [ -z $keep ] && /bin/rm -f $file
   done
}

# kill all processes of a user $*
function killUser()
{
   local user
   for user in $*
   do
      echo killing user $user... 1>&2 
      ps -ef | grep $user | awk '{print $2}' | xargs kill -9
   done
}

# gitContents: helper for PS1: git bash prompt like, but much shorter and also working for darwin.
function gitContents()
{
    #_gitCmd='git status -s --show-stash -b'
    _gitCmd='git status -s -b'
    if [[ $(git rev-parse --is-inside-work-tree 2>&1 | grep fatal | wc -l) -eq 0  ]] ; then
            _gitBranch=$($_gitCmd | head -1 | sed 's/^##.//')
            _gitStatus=$($_gitCmd | tail -n +2 | sed 's/^\(..\).*/\1/' | sort | uniq | tr "\n" " " | sed -e 's/ //g' -e 's/??/?/' -e 's/^[ ]*//')
            echo $_gitStatus $_gitBranch
    fi
}

# ssf finds a host entry in ssh configuration files in ~/.ssh/config.d/*.config. Earlier versions used ~/.ssh/config.d/* but
# this makes it complex to disable files and keep them for a while.
export SSF_SURROUNDING_LINES='--colour -A 3' # variable to be adjusted in .profile.post
function ssf() {
      egrep -v '^[[:space:]]*#' ~/.ssh/*config ~/.ssh/config.d/*.config | egrep -v ProxyJump | egrep -i $SSF_SURROUNDING_LINES --colour=auto "$*"
}

# show the ssh-fingerprints for the supplied files. ssh-keygen does not support multiple files
function sshFingerprint() { for file in $* ; do  echo -n $file': ' ; ssh-keygen -lf "$file" ; done ; }

# show the ssh-certificate for the supplied files. ssh-keygen does not support multiple files
function sshCertificate() { for file in $* ; do ssh-keygen -Lf "$file" ; done ; }

function sshPriv2PubKey() { ssh-keygen -yf $1 ;  } # create public key out of private key


# ------ Certs
# create fingerprint of certificate
function tlsCertFingerprint() {  local file; for file in $*; do /bin/echo -n "$file:"; openssl x509 -modulus -noout -in "$file" | openssl sha256 | sed 's/.*stdin)= //' ; done;  }
# show certificate (replacing the package version tlsCertView)
# removed csplit as it was not workin on Darwin (stupid implementation)
function tlsCert() { [ $(ls tlsCert* 2>/dev/null | wc -l) -ne 0 ] && error files beginning with tlsCert exist in current directory && return ; awk 'BEGIN{RS="/-*BEGIN CERTIFICATE/"}{ f = "tlsCert" NR ".in"; print > f; close(f) }' $* ; local file; for file in tlsCert*; do openssl x509 -in "$file" -subject -email -issuer -dates -sha256 -serial -noout -ext 'subjectAltName' 2>/dev/null | sed -e "s,^,$file:,"; openssl x509 -in "$file" -modulus -noout 2>/dev/null | openssl sha256 |  sed -e "s,^.*= ,$file:SHA256 Fingerprint=,"; done; /bin/rm -f tlsCert*;  }
# ------ Keys
# show fingerprint of private RSA key
function tlsRsaFingerprint() { local file; for file in $*; do /bin/echo -n "$file:"; openssl rsa -modulus -noout -in "$file" | openssl sha256 | sed 's/.*stdin)= //'; done; }
# show fingerprint of public RSA key
function tlsRsaPubFingerprint() { local file; for file in $*; do /bin/echo -n "$file:"; openssl rsa -modulus -noout -pubin -in "$file" | openssl sha256 | sed 's/.*stdin)= //'; done; }
function tlsRsa2PubKey() { openssl rsa -in $1 -pubout; } 
# ------ CSR
function tlsCsr() { local file; for file in $*; do openssl req -in "$file"  -noout -utf8 -text | sed "s,^,$file:," | egrep -v '.*:.*:.*:'; done; }

# =========================================================================================
# === shell setup routines ================================================================
# =========================================================================================

if [ -d "$PROFILES_CONFIG_DIR" ] ; then 
   source $PROFILES_CONFIG_DIR/zsh.version.sh
else  
   err CANNOT FIND PROFILES_CONFIG_DIR which is set to $PROFILES_CONFIG_DIR
fi

# setHistFile sets the HISTFILE to to effective users home-directory/.bash_history file
function setHistFile() {
   debug in setHistFile
   export HISTFILE=$(eval echo ~$USER/.bash_history) ; debug4 HISTFILE is $HISTFILE
   [ -f $HISTFILE ] && debug4 histfile existing && \
      local histfileUser=$(ls -l $HISTFILE | awk '{ print $3 } ') && \
      USER=${USER:-root} # fix for docker
      SHELL=${SHELL:-$(ps a | grep $$ | sed -n "/^ *$$/p" | awk '{ print $NF }')} # fix for docker
     [ $histfileUser != $USER ] && echo ownship of history file must be corrected from user $histfileUser to user $USER && sudo chown $USER $HISTFILE
}

# --210708 disabled by use of setHistFile
# sudo often changes permissions for files. This functions tries to make sure that the history file is writable.
function fixPermHistfile() {
   debug in fixPermHistfile
   export REAL_USER=$(who am i | awk '{print $1}')
   if [ -e "$HISTFILE" -a ! -w "$HISTFILE" ] ; then
      printf "\033[0;31m$HISTFILE not writable\033[0m\n\t" 1>&2 
      sudo chown $REAL_USER $HISTFILE; res=$?
      if [ "$res" -ne 0 ] ; then
         err Could NOT fix it. Please intervene... 1>&2 
      else
         err fixed. 1>&2 
      fi
   fi
}

# set the PATH and cache the result for faster loadTime. rlFull will flush the cash and recreate it.
function setPath() {
   debug in setPath
   PATHFILE="$HOME/.profile.path"
   if [ ! -f "$PATHFILE" ] ; then
      debug PATHFILE $PATHFILE not found, creating it...
      PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
      for POTENTIAL_DIR in \
         /opt/homebrew/bin /opt/homebrew/opt/gnu-getopt/bin /usr/local/opt/gnu-getopt/bin \
         /opt/homebrew/opt/ \
         /opt/homebrew/opt/openssl\@1.1/bin /usr/local/opt/openssl\@1.1/bin /opt/Arch/*/bin \
         /opt/homebrew/opt/curl/bin  /usr/local/opt/curl/bin/ \
         /usr/local/opt/gnu-getopt/bin \
         /opt/homebrew/opt/java/bin /usr/local/opt/java/bin \
         /Library/Java/JavaVirtualMachines/current/bin \
         /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin \
         $HOME/Library/Android/sdk/platform-tools \
         /usr/local/share/dotnet /usr/local/go/bin \
         /Applications/Visual\ Studio\ Code.app//Contents/Resources/app/bin/ \
         /Applications/Sublime\ Tex*.app/Contents/MacOS/ \
         $HOME/bin $HOME/.dotnet/tools $HOME/.rvm/bin \
         /usr/local/google-cloud-sdk/ $HOME/google-cloud-sdk/ \
         $HOME/.pub-cache/bin /opt/flutter/bin \
         $HOME/.linkerd2/bin $HOME/.local/bin \
         $HOME/google-cloud-sdk/bin /usr/local/google-cloud-sdk/bin \
         /opt/android-studio/bin \
         /mnt/c/Windows/System32 /mnt/c/Windows \
         /mnt/c/Windows/System32/wbem /mnt/c/Windows/System32/WindowsPowerShell/v1.0 \
         /mnt/c/Users/$USER/AppData/Local/Microsoft/WindowsApps \
			/mnt/c/go/bin \
			/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin \
         /mnt/c/Program\ Files/dotnet/ \
         /mnt/c/Program\ Files/Haskell\ Platform/actual/bin \
         /mnt/c/Program\ Files/Haskell\ Platform/actual/winghci \
         $HOME/$USER/AppData/Roaming/local/bin \
         /mnt/c/Program\ Files/Docker/Docker/resources/bin \
         /mnt/c/Program\ Files/7-Zip \
         /mnt/c/Program\ Files/Affinity/Designer /mnt/c/Program\ Files/Affinity/Photo \
         /mnt/c/Program\ Files/MiKTeX\ 2.9/miktex/bin/x64 \
         /mnt/c/Program\ Files/PDFCreator /mnt/c/Program\ Files/PDFsam\ Basic \
         /mnt/c/Program\ Files/VueScan /mnt/c/Program\ Files/VeraCrypt /mnt/c/Program\ Files/Wireshark \
         /mnt/c/Program\ Files/draw.io /mnt/c/Program\ Files/Mozilla\ Firefox \
         /mnt/c/Program\ Files/Java/jdk*/bin \
         /usr/local/texlive/20??/bin/universal-darwin/ \
         /snap/bin/
      do
         debug4 checking for dir $POTENTIAL_DIR
         [ -d "$POTENTIAL_DIR/." ] && debug8 adding path element $POTENTIAL_DIR && PATH="$POTENTIAL_DIR":$PATH
      done

      if $(which latex > /dev/null); then 
         debug4 latex found, building cache file...
         # executing the finds takes time. So, let's cache the result.
         TEXBASEDIR=${TEXBASEDIR:-/usr/local/texlive}
         TEXPATHFILE="$HOME/.profile.tex.path"
         if [ -d "$TEXBASEDIR" -a ! -f "$TEXPATHFILE" ] ; then
            echo creating TEXPATHFILE $TEXPATHFILE...
            # determine current distribution (just for a century :-) 
            TEX_DISTRIB_DIR=$(ls -d1 /usr/local/texlive/20* | tail -n 1)
            debug8 TEX_DISTRIB_DIR is $TEX_DISTRIB_DIR
            # determine non-annual TeX-directories (not required at the moment)
            # TEX_OTHER_DIRS=$(ls -d1 /usr/local/texlive/* | egrep -v '.*20[[:digit:]][[:digit:]]')
            find "$TEX_DISTRIB_DIR" -type d -name '*bin'     >| $TEXPATHFILE
            find "$TEX_DISTRIB_DIR" -type d -name '*linux'   >> $TEXPATHFILE
            find "$TEX_DISTRIB_DIR" -type d -name '*darwin'  >> $TEXPATHFILE
         fi
         if [ -f "$TEXPATHFILE" ] ; then
            for line in $(egrep -v '^[[:space:]]*$' $TEXPATHFILE) ; do
               PATH=$PATH:"$line"
            done
         fi
      else 
         debug4 NOT FOUND latex
      fi

      #### PATH should not be touched after this line anymore, here begins the caching

      echo Writing PATHFILE $PATHFILE ...
      echo "PATH=\"$PATH\"" > "$PATHFILE"
   else
      debug4 .. PATHFILE $PATHFILE found, sourcing cache ...
      source "$PATHFILE"
   fi
   unset POTENTIAL_DIR FILE _file line
}

# set all the aliases for the shell    # OS independent setup
function setupShellAliases() {
   debug in setupShellAliases
   CDPATH=.:~

   export LESS='-iR'    # -i := searches are case insensitive; -R := Like -r, but only ANSI "color" escape sequences are output in "raw" form. The default is to display control characters using the caret notation.
   export PAGER=less

   export RSYNC_FLAGS="-rltDvu --modfiy-window=1"     # Windows FS updates file-times only every 2nd second
   export RSYNC_SLINK_FLAGS="$RSYNCFLAGS --copy-links" # copy s-links as files
   export RSYNC_LINK='--copy-links'

   export VISUAL=vim
   export EDITOR=vim    # bsroot has no notion about VISUAL
   export BLOCKSIZE=1K

   alias ..='cd ..'
   alias ...='cd ../..'
   alias .2='cd ../..'
   alias .3='cd ../../..'
   alias .4='cd ../../../..'
   alias .5='cd ../../../../..'
   alias .6='cd ../../../../../..'
   alias .7='cd ../../../../../../..'
   alias a=alias
   alias brmd='[ -f .DS_Store ] &&  /bin/rm -f .DS_Store ; cd .. ; rmdir "$OLDPWD"'
   alias cm=cmake
   alias cp='cp -i'
   alias disp0='export DISPLAY=:0'
   alias disp1='export DISPLAY=:1'
   alias e=egrep
   alias ei='egrep -i'
   alias eir='egrep -iR'
   alias enf='env | egrep -i '   # search the environment in case-insensitive mode
   alias fin='find . -name'      # search for a filename
   alias fini='find . -iname'    # search for a filename in case-insensitive mode
   alias h=history
   alias hf='history | egrep -i '
   alias ipi='curl https://ipinfo.io'
   alias j=jobs
   alias l=less
   alias la="/bin/ls    -aCF     $LS_COLOUR"
   alias lh="/bin/ls    -lFh     $LS_COLOUR"
   alias lha=lla
   alias ll="/bin/ls    -lF      $LS_COLOUR"
   alias lla="/bin/ls   -lahF    $LS_COLOUR"
   alias ln-s='ln -s'
   alias ls="/bin/ls    -CF      $LS_COLOUR"
   alias m=make
   alias mcd=mkcd
   function mkcd(){ mkdir -p $1 && cd $1; }
   alias mv='mv -i'
   alias po=popd
   alias pu='pushd .'
   alias rm='rm -i'                    # life assurance
   alias rmtex='/bin/rm -f *.log *.aux *.dvi *.loc *.toc'   # remove temporary LaTeX/TeX files
   alias rm~='find . -name \*~ -print -exec /bin/rm {} \; ; find . -name \*.bak -print -exec /bin/rm {} \;'
   alias rmbak=rm~
   alias ssh-grep=ssf
   alias tm='tmux new -s '
   alias tw='tmux new-window -n'
   alias tn=tw
   alias tj='tmux join-pane -s'
   alias wh=which

   alias prd='tmux select-pane -P "fg=yellow,bg=color052"' # colour values from https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
   alias qul='tmux select-pane -P "fg=black,bg=color231"'
   alias dvl='tmux select-pane -P "fg=white,bg=color017"'
   alias whbl='tmux select-pane -P "fg=white,bg=black"'
   alias blwh='tmux select-pane -P "fg=black,bg=white"'

   [ -z $NO_setupGit ] && setupGit
   [ -z $NO_setupK8s ] && setupK8s
}

# git-specific aliases and functions
function setupGit() {
   debug in setupGit
	alias gidi='git diff'               # show delta working-tree vs index
   alias gidic='git diff --cached'     # show delta index vs last commit
	alias gibr='git branch -avv'
	alias gilo='git log --branches --remotes --tags --graph --oneline --decorate'
	alias gist='git status'
	alias gipl='git pull --all; git fetch --tags'
   alias girm="git status | sed '1,/not staged/d' | grep deleted | awk '{print \$2}' | xargs git rm"
   alias git-untracked="git ls-files --others --exclude-standard" # show untracked files without the ones mentioned by .gitignore
   function gipu() { git push --all $*; git push --tags $* ; }
   # improved git commit
   function gicm() { if [ $# -ne 0 ] ; then git commit -m "$*" ; else git commit ; fi ; }
   function gicma() { if [ $# -ne 0 ] ; then git commit -a -m "$*" ; else git commit -a ; fi ; }
   function gipua() { for remoterepo in $(grep '^\[remote' $(git rev-parse --show-toplevel)/.git/config | sed -e 's/.remote \"//' -e s'/..$//') ; do git push --all $remoterepo ; git push --tags $* ; done ; }
}

# help to show all git helpers
function gihelp() {
   echo alias gidi='git diff'               # show delta working-tree vs index
   echo alias gidic='git diff --cached'     # show delta index vs last commit
	echo alias gibr='git branch -avv'
	echo alias gilo='git log --branches --remotes --tags --graph --oneline --decorate'
	echo alias gist='git status'
	echo alias gipl='git pull --all; git fetch --tags'
   echo alias girm="git status | sed '1,/not staged/d' | grep deleted | awk '{print \$2}' | xargs git rm"
   echo 'alias git-untracked="git ls-files --others --exclude-standard"'
   echo 'function gipu() { git push --all $*; git push --tags $* ; }'
   echo 'function gicm() { if [ $# -ne 0 ] ; then git commit -m "$*" ; else git commit ; fi ; '
   echo 'function gicma() { if [ $# -ne 0 ] ; then git commit -a -m "$*" ; else git commit -a ; fi ; }'
   echo 'gitInit for initial setup. For details: typeset -f gitInit'
   echo 'function gipua() { for remoterepo in $(grep "^\[remote" $(git rev-parse --show-toplevel)/.git/config | sed -e "s/.remote \"//" -e s"/..$//") ; do git push --all $remoterepo ; git push --tags $* ; done ; }'
}

# initialise the git variables
function gitInit()
{
   [ "$CALC_SHELL" = zsh ] && error zsh not supported. Limited read implementation. && return
   _fullName=$(git config --global user.name)
   if [ "$_fullName" = "" ] ; then
      _userName=$(id -un)     # get current potential user-name
      _fullName=$(getent passwd | egrep ^$_userName | awk -F: '{print $5}')
   fi
   read -e -p 'Username for commits:' -i "$_fullName" _gitUsername
   git config --global user.name "$_gitUsername"

   _gitMailAddr=$(git config --global user.email)
   read -e -p 'Email address for commits:' -i "$_gitMailAddr" _gitMailAddr
   git config --global user.email "$_gitMailAddr"
   git config --global alias.last 'log -1 HEAD'
   git config --global pull.rebase true # use rebase
   git config --global pager.branch false # no pager for gibr

   for _editor in vi vim emacs uemacs nano ; do
      command -v $_editor >/dev/null 2>&1 && git config --global core.editor $_editor && \
         echo editor set to $_editor && break
   done
   case $(uname) in
   Linux) 
      [[ $(uname -r ) =~ Microsoft ]] && git config --global credential.helper manager    # WSL support
      [[ ! $(uname -r ) =~ Microsoft ]] && git config --global credential.helper store    # classical Linux
      ;;
   Darwin) git config --global credential.helper osxkeychain 
      ;;
   *) error OS not supported to set the credential.helper variable.
   esac
}

# Kubernetes-specific aliases and functions
function setupK8s() {
   debug in setupK8s
   alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm chenzj/dfimage" # find base image for a container OR docker image history
   alias dih='docker image history'
   alias k=kubectl
   alias k8=kubectl
   alias k8c='kubectl config '
   alias k8cg='kubectl config get-contexts'
   alias k8cs='kubectl config set-context'
   alias k8cu='kubectl config use-context'
   alias k8cv='kubectl config view'
   alias k8gn='kubectl get nodes -o wide'
   alias k8gp='kubectl get pods -o wide'
   alias k8gs='kubectl get services -o wide'
   alias k8ns='kubectl get ns'
   alias k8ga='kubectl get all -A -o wide'
   function k8describe() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift 
      kubectl describe $_pod $*
   }
   function k8exec() { 
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift
      kubectl exec -it $_pod -- ${k8execCmd:-bash} $*
   }
   function k8logs() { 
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      kubectl logs "$2" $_pod # $2 for -f
   }
}

# help file to show all k8s commands
function k8help() {
   echo  dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm chenzj/dfimage" # find base image for a container OR docker image history
   echo  dih='docker image history'
   echo  k=kubectl
   echo  k8=kubectl
   echo  k8c='kubectl config '
   echo  k8cg='kubectl config get-contexts'
   echo  k8cs='kubectl config set-context'
   echo  k8cu='kubectl config use-context'
   echo  k8cv='kubectl config view'
   echo  k8gn='kubectl get nodes -o wide'
   echo  k8gp='kubectl get pods -o wide'
   echo  k8gs='kubectl get services -o wide'
   echo  k8ns='kubectl get ns'
   echo  k8ga='kubectl get all -A -o wide'
   echo '   function k8describe() {
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift 
      kubectl describe $_pod $*
   }
   function k8exec() { 
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      shift
      kubectl exec -it $_pod -- ${k8execCmd:-bash} $*
   }
   function k8logs() { 
      local _pod=$(kubectl get po | grep -i "$1" | cut -d ' ' -f 1)
      kubectl logs "$2" $_pod # $2 for -f
   }'
}


# --- shell setup -------------------------------------------------------------------------

function setupLinux() {          # Linux-specific settings of aliases and shell-functions
   debug in setupLinux
   eval $(dircolors)
   export LS_COLOUR='--color=auto'
   alias proc='ps -ef | grep -i '
   alias o=xdg-open
   alias open=o
   alias xlock='xlock -remote -mode blank -allowroot'
   alias xl=xlock

   if [[ $(uname -r) =~ Microsoft ]] ; then  # WSL
      debug Microsoft environment detected
      alias docker=docker.exe
      alias kubectl=kubectl.exe
      alias k=kubectl.exe
   fi

   # systemd ; always load them, as likelihodd is high that it exists :-(
   function sylt() { systemctl list-timers $* ; }
   function sylu() { systemctl list-units $* ; }
   function syrestart()	{ systemctl restart $* ; systemctl --no-pager status $* ; }
   alias restat=syrestart
   function systart() { systemctl start $* ; systemctl --no-pager status $* ; }
   alias systat='systemctl status'
   function systop() { systemctl stop $* ; systemctl --no-pager status $* ; }

   function pkgU() {
      local found=0
      [ -e /etc/debian_version ] && found=1 && apt-get update && apt-get dist-upgrade && apt-get autoremove
      command -v dnf &>/dev/null && found=1 && dnf -y upgrade && dnf -y clean packages
      command -v dnf &>/dev/null || command -v yum &>/dev/null && found=1 && yum -y update && yum -y clean packages
      [ $found -eq 0 ] && error pkgU not supported for this OS && return 1
      touch ~/.pkgU
   }
}

# Darwin- alias OSX-specific settings of aliases and shell-functions
function setupOSX() {
   debug in setupOSX
   export BASH_SILENCE_DEPRECATION_WARNING=1    # OSX: no warning if still using bash
   export LS_COLOUR='-G'
   export LSCOLORS=Exfxcxdxbxegedabagacad # change directory colour 1st letter; see man ls(1)
   alias proc='ps -ef | grep -i '
   alias sublime='Sublime\ Text'
   alias subl=sublime
   alias o=open
   alias vnc='open /System/Library/CoreServices/Applications/Screen\ Sharing.app'

   for _newApp in getopt curl openssl ; do 
      which $_newApp | egrep '^/opt/homebrew|/usr/local' > /dev/null || warning $_newApp does not seem to be from homebrew.
   done

   pkgU() # upgrade homebrew, gcloud,  macTeX
   {
      echo homebrew........................................  1>&2 
      brew update && brew upgrade && brew autoremove && brew cleanup # casks are also updated to today's brew upgrade && brew cu -ay # cu := cask upgrade
      echo Google Cloud SDK................................  1>&2 
      if $(command -v gcloud > /dev/null 2>&1) ;then 
         currentGCPSDK=$(gcloud components list 2>&1 | egrep 'Your current Cloud SDK version' | awk '{ print $NF }')
         availableGCPSDK=$(gcloud components list 2>&1 | egrep 'The latest available version' | awk '{ print $NF }')
         echo Installed version of GCP SDK: $currentGCPSDK, available version: $availableGCPSDK
         [ ! "$currentGCPSDK" = "$availableGCPSDK" ] && sudo CLOUDSDK_PYTHON=python3.8 gcloud components update
         [ "$currentGCPSDK" = "$availableGCPSDK" ] && echo No GCP SDK update found.
      else warning gcloud does not seem to be installed ;fi
      echo macTeX........................................... 1>&2 
      if $(command -v tlmgr > /dev/null 2>&1) ; then tlmgr --self --all update
      else warning mactex does not seem to be installed ;fi
      touch ~/.pkgU
   }

   # start Xcode
   xc()
   {
      if [ `ls -d *.xcworkspace 2>/dev/null | wc -l` -eq 1 ] ; then
         echo opening *.xcworkspace 1>&2 ; open *.xcworkspace
      elif [ `ls -d *.xcodeproj 2>/dev/null | wc -l` -eq 1 ] ; then
         echo opening *.xcodeproj 1>&2 ; open *.xcodeproj
      else error multiple xcodeproj files/directories or none found. ; fi
   }

   ######### Xarmarin helpers # open visual studio, usually
   sln()
   {
      if [ `ls -d *.sln 2>/dev/null | wc -l` -eq 1 ] ;
      then debug opening *.sln ; open *.sln
      else error multiple sln files/directories or none found.
      fi
   }
}

function setupOSX_PostgreSQL() {
   #POSTGRESQL specific
   debug in setupOSX_PostgreSQL '(non-docker installation)'
   if [ -d /Applications/Postgres.app/Contents ] ; then
      export PGDIR="$HOME/Library/Application Support/Postgres/" # PGDIR: directory of PGSQL configuration
      if [ `ls "$PGDIR" 2>/dev/null | tail -1 | wc -l` -gt 0 ] ; then
         debug PostgreSQL installation found
         PGVERSION=`ls "$PGDIR" | tail -1`
         export PGDATA="$PGDIR"$PGVERSION # PGDATA: directory of PGSQL data files
         if [ ! -d "$PGDATA" ] ; then
                  echo $PGDATA is not a directory. Unsetting it. 1>&2 
                  unset PGDATA
         else
                  PGNUMBER=`echo "$PGVERSION" | sed 's/.*-//'`
                  PATH=$PATH:/Applications/Postgres.app/Contents/Versions/"$PGNUMBER"/bin
         fi
      else
         echo PGDIR seems to be empty or not existing 1>&2 
         echo Hint: this message often disappears after the installation AND the 1st start of Postgres 1>&2 
      fi
   fi
}

# function setupOSX_MonoDotNet() {
#    ###################### mono support (installed via homebrew)
#    debug loading OSX Mono Support
#    export MONOBIN=/usr/local/Cellar/mono
#    export MONOMSBIN=/Library/Frameworks/Mono.framework/Versions/Current/bin/  # MS version, if installed as a pkg
#    if [ -d "$MONOMSBIN" ] ; then # MS mono has precedence
#       debug ms mono found
#       PATH=$PATH:$MONOMSBIN
#       MANPATH=$MANPATH:$MONOMSBIN/../share/man
#    elif [ -d "$MONOBIN" ] ; then
#       LATEST_MONO=$MONOBIN/$(ls $MONOBIN | tail -1)
#       if [ -d $LATEST_MONO/bin ] ; then
#          debug homebrew mono found
#          canonicalPath=$(cd $LATEST_MONO/bin; pwd) # evaluate path so that it can be added to PATH
#          PATH=$PATH:$canonicalPath
#          unset canonicalPath
#       fi
#    else
#       debug no mono found
#    fi
#    unset MONOBIN MONOMSBIN
# }

# BSD-specific aliases and shell-functions
function setupBSD() {
   debug in setupBSD
   alias proc='ps auxww | egrep -i '
   alias o=xdg-open
   alias open=o
   alias xlock='xlock -remote -mode blank -allowroot'
   alias xl=xlock
}

function setupOSSpecifics() { # OS specific settings and functions
   debug in setupOSSpecifics
   case $(uname) in
   Linux)
      [ -z $NO_setupLinux ] && setupLinux ;;
   Darwin)
      [ -z $NO_setupOSX ] && setupOSX 
      [ -z $NO_setupOSX_PostgreSQL ] && setupOSX_PostgreSQL
      #  [ -z $NO_setupOSX_MonoDotNet ] && setupOSX_MonoDotNet
      ;;
   *BSD)
      [ -z $NO_setupBSD ] && setupBSD ;;
   *)
      echo WARNING: No OS-specfic settings found.
   esac
}

function sshagent_findsockets {
   find /tmp -uid $(id -u) -type s -name agent.\* 2>/dev/null
}

function sshagent_testsocket {
    [ ! -x "$(which ssh-add)" ] && echo "ssh-add is not available; agent testing aborted" && return 1

    [ X"$1" != X ] && export SSH_AUTH_SOCK=$1

    [ X"$SSH_AUTH_SOCK" = X ] && return 2

    if [ -S $SSH_AUTH_SOCK ] ; then
        ssh-add -l > /dev/null
        if [ $? = 2 ] ; then
            debug  "socket $SSH_AUTH_SOCK is dead! Deleting!"; rm -f $SSH_AUTH_SOCK; return 4
        elif [ $? = 1 -a $(ssh-add -l | wc -l) -eq 0 ] ; then
            ssh-add
        else
            debug "ssh-agent found: $SSH_AUTH_SOCK"; return 0
        fi
    else
        debug "$SSH_AUTH_SOCK is not a socket!"; return 3
    fi
}

function sshagent_init { #  ssh agent sockets can be attached to a ssh daemon process or an ssh-agent process.
    local AGENTFOUND=0  
    local agentsocket

    if sshagent_testsocket ; then AGENTFOUND=1 ; fi # Attempt to find and use the ssh-agent in the current environment

    # If there is no agent in the environment, search /tmp for possible agents to reuse before starting a fresh ssh-agent process.
    if [ $AGENTFOUND = 0 ] ; then
         for agentsocket in $(sshagent_findsockets) ; do
            if [ $AGENTFOUND != 0 ] ; then break ; fi
            if sshagent_testsocket $agentsocket ; then AGENTFOUND=1 ; fi
         done
         eval `ssh-agent`
    fi
    [[ $(ssh-add -l | grep  'no identities' | wc -l) -eq 1 ]] && ssh-add # load keys if none loaded so far
}

function bashSetup() {
	debug in bashSetup
   # Save and reload the history after each command finishes. Synchronises different shells
   export PROMPT_COMMAND="history -a; history -c; history -r" # ; $PROMPT_COMMAND"
	if [ $(id -u) -eq 0 ] ; then
      debug4 bash ROOT shell
      PATH=/sbin:/bin:/usr/sbin:/usr/bin:"$PATH" # security: no enhanced PATHs first
		PS1='[$?] \033[0;31m\t | \u@\h | $(pwd) \033[0m##########################\n'
	else
      debug4 bash non-root shell
		PS1='[$?] \033[34m\t\033[0m|\033[32m\u@\h\033[0m|\033[0;31m$(gitContents)\033[0m|$AWS_PROFILE|\033[0;33m\w\e[0m\$\n'
	fi
}

function zshSetup() {
   debug in zshSetup
	setopt hist_ignore_all_dups
	setopt hist_ignore_space
   setopt pushd_ignore_dups
   setopt always_to_end
   setopt auto_list
   setopt auto_menu
   setopt auto_param_slash
   setopt complete_in_word
   unsetopt menu_complete
	setopt autocd
	setopt extended_glob
   setopt glob_dots
   setopt append_history
   setopt extended_history
   unsetopt hist_beep
   unsetopt beep
   setopt combining_chars
   setopt emacs
   setopt share_history
   setopt INC_APPEND_HISTORY
   setopt HIST_REDUCE_BLANKS
	autoload -U compinit
	setopt correctall    	# Correction
   export EDITOR2=${ZSH_EDITOR:-code}
   alias -s txt=$EDITOR2   # open the following file-types with the specified editor
   alias -s rc=$EDITOR2
   alias -s go=$EDITOR2
   alias -s md=$EDITOR2
   alias -s tex=$EDITOR2
   alias -s log='tail -f'
   NEWLINE=$'\n'
	if [ $(id -u) -eq 0 ] ; then
	   debug4 zsh ROOT shell
      PATH=/sbin:/bin:/usr/sbin:/usr/bin:"$PATH" # security: no enhanced PATHs first
		PS1="%(?..%F{red}%?%F{white}•)%F{red}%n@%m%F{white}•%F{blue}%h%F{white}•%F{yellow}%B%~%b%F{white}#${NEWLINE}"
      RPROMPT='[%*]'
	else
	   debug4 non-root zsh shell
	   compinit
		PROMPT="%(?..%F{red}%?%F{white}•)%F{green}%n@%m%F{white}•%F{blue}%h%F{white}•%F{red}$(gitContents)%F{white}•%F{yellow}%B%4~%b%F{white}\$${NEWLINE}"
      RPROMPT='[%*]'
	fi
}

# If multiple users log in as user hadm, determine the real user logging in by identifying her/his SSH finger-print
function realUserForHadm() {
   debug in realUserForHadm
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

############# user-commands #################################################################
# The commands below are used for setting up the shell. The following functions are to be used by the user directly.

function rl() {
   source $COMMONRC_FILE
}

function rlFull() {
   debugSet
   debug in rlFull
   [ -f "$PATHFILE" ] && debug4 PATHFILE found, deleting it && /bin/rm -f ${PATHFILE} # reload this file w/ recreating the cache
   [ -f "$TEXPATHFILE" ] && debug4 TEXPATHFILE found, deleting it && /bin/rm -f ${TEXPATHFILE} # reload this file and flush all caches (PATH, TEXPATH)
   rl
   debugUnset
}

function loadBashCompletions() {
   debug in loadBashCompletions
   local _dir=$(ls /usr/local/Cellar/bash-completion/ 2>/dev/null | tail -1)
   #debug after local
   [ ! -z "$_dir" ] && debug bash-completion found $_dir && [ -f "/usr/local/Cellar/bash-completion/$_dir/etc/bash_completion" ] && debug loading bash-completion && . "/usr/local/Cellar/bash-completion/$_dir/etc/bash_completion"
   #debug after osx bash completion
   [ -f /etc/bash_completion ] && debug loading bash-completion on Ubuntu && source /etc/bash_completion

   [[ -s "$HOME/.gvm/scripts/gvm" ]] && debug gvm && source "$HOME/.gvm/scripts/gvm"

   brootFile="$HOME/.config/broot/launcher/bash/br"
   if [ -r "$brootFile" ] ; then debug loading broot  ; source "$brootFile" ; else debug NOT FOUND broot $brootFile;unset brootFile ; fi

   # Azure Dev Spaces
   if [ -f /etc/bash_completion.d/azds ] ; then
      debug Azure Dev Spaces detected 
      source /etc/bash_completion.d/azds
   else
      debug NOT FOUND Azure Dev Spaces
   fi

   if [ -e /usr/local/bin/terraform ] ; then
      debug loading terraform completion
      complete -C /usr/local/bin/terraform terraform
      # autoload -U +X bashcompinit && bashcompinit
      complete -o nospace -C /usr/local/bin/terraform terraform
   fi

   # not in use: [ -s "$HOME/.config/envman/load.sh" ] && debug envman && source "$HOME/.config/envman/load.sh"

   [ -f '/usr/local/bin/aws_completer' ] && debug loading aws_completer && complete -C '/usr/local/bin/aws_completer' aws

   $(which eksctl > /dev/null) && debug loading eksctl completion && . <(eksctl completion bash) # eksctl completion
}

function shellSpecificSetup() {
   debug in shellSpecificSetup
   # not so easy as expected to determine the actual shell type
   export CALC_SHELL=$(ps aux | grep $$ | awk '{ print $2,$11; }' | grep $$ | awk '{ print $2 }' | sed 's/^-//')
   # ps | grep $$ | grep -v grep | sed 's/-l$//' | awk '{ print $NF }' | sed 's/^-//') # not working 4 win10
   alias root='sudo -i $(echo $CALC_SHELL | sed -e "s/ .*//" -e "s/(//" -e "s/)//" )' # required for strange behaviour on win10

   if [[  "$CALC_SHELL" =~ .*bash ]] ; then
      # Avoid duplicates
      export HISTCONTROL=ignoredups:erasedups
      export HISTSIZE=100000
      export HISTFILESIZE=100000
      # When the shell exits, append to the history file instead of overwriting it
      shopt -s histappend
      bashSetup
      [ -z $NO_loadBashCompletions ] && loadBashCompletions
   elif [[ "$CALC_SHELL" =~ .*zsh ]] ; then
      unsetopt nomatch 2&>/dev/null
      setopt INC_APPEND_HISTORY # append entry to history command immediately, not @eoShell
      setopt SH_WORD_SPLIT 2&>/dev/null # var="foo bar" are split into words by most shells. By default, zsh does not have that behaviour: the variable gives compatibility.
      zshSetup
   else
      echo UNKNOWN shell type, no definition found >&2
   fi
}

### ssh and TLS helpers

function sshSetup() {
   alias sagent="sshagent_init"     # SSH setup
   sshagent_init
   trap 'test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`' 0 # kill agent if leaving root
}

################# pre and post loads

# user-specific pre configuration
function loadPre() {
   [ -f "$HOME/.profile.pre" -a -r "$HOME/.profile.pre" ] && debug source .profile.pre && source "$HOME/.profile.pre"
}

# user-specific post-configuration
function loadPost() {
   [ -f "$HOME/.profile.post" -a -r "$HOME/.profile.post" ] && debug loading .profile.post && source "$HOME/.profile.post"
}

############################################################################
# main
############################################################################

function main() {
   umask 0022
   [ $(uname) != Darwin ] && export NO_loadBashCompletions=TRUE # problems with completions on other platform
   # NO_loadBashCompletions can be overwritten in loadPre => ~/.profile.pre if wanted
   loadPre
   case $- in
      *i*) #  "This shell is interactive"
         set -o ignoreeof                             # prevent ^d logout
         set -o noclobber                             # overwrite protection, use >| to force

         [ -z $NO_setVersion ]         && setVersion
         [ -z $NO_setHistFile ]        && setHistFile
         [ -z $NO_setPath ]            && setPath
         [ -z $NO_shellSpecificSetup ] && shellSpecificSetup
         [ -z $NO_setupShellAliases ]  && setupShellAliases
         [ -z $NO_setupOSSpecifics ]   && setupOSSpecifics
         [ -z $NO_sshSetup ]           && sshSetup
         # [ -z $NO_fixPermHistfile ]    && fixPermHistfile # --210708 disabled for setHistFile
         [ -z $NO_realUserForHadm ]    && realUserForHadm
         [ -z $NO_loadPost ]           && loadPost
         ;;
      *) #echo "This is a script";;
         [ -z $NO_loadPost ]  && loadPost
         ;;
   esac
   return 0
}

main $@

#################### EOF
