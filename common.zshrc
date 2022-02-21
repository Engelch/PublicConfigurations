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

# --------------------------------------------------------------------------- Functionality block, alphabetically sorted
# ---- ansible -----------------------------------------------------------------------

function ansibleListTags() {
   for i in $* ; do ansible-playbook --list-tags $i 2>&1 ; done | grep "TASK TAGS" | cut -d":" -f2 | awk '{sub(/\[/, "")sub(/\]/, "")}1' | sed -e 's/,//g' | xargs -n 1 | sort -u
}

# ---- BSD -----------------------------------------------------------------------

function setupBSD() { 
   debug common.zshrc in setupBSD
   alias proc='ps auxww | egrep -i '
   alias o=xdg-open
   alias open=o
   alias xlock='xlock -remote -mode blank -allowroot'
   alias xl=xlock
}

# ---- Crypto -----------------------------------------------------------------------

# These routines delete the original file. By default, they do not overwrite existing files. This can be changed by supplying the argument `-f`.

function sencrypt() {
   local file
   local keep=
   local force=
   [ $1 = -f ] && force=True && shift
   [ $1 = -k ] && keep=True && shift
   [ $1 = -f ] && force=True && shift # all 4 forms (1) -f -k (2) -k -f (3) -kf (4) -fk
   [ $1 = -kf -o $1 = -fk ] && keep=True && force=True && shift
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
   [ $1 = -f ] && force=True && shift
   [ $1 = -k ] && keep=True && shift
   [ $1 = -f ] && force=True && shift # all 4 forms (1) -f -k (2) -k -f (3) -kf (4) -fk
   [ $1 = -kf -o $1 = -fk ] && keep=True && force=True && shift
   for file in $* ; do
      target=$(basename $file .asc)
      [ ! -z $force ] && /bin/rm -f $target 2>/dev/null
      [ -f $target ] && error target file already exists for $file. && continue
      debug gpg -d -o $target $file
      gpg -d -o $target $file && [ -z $keep ] && /bin/rm -f $file
   done
}

# ---- GIT  -----------------------------------------------------------------------

# gitContents: helper for PS1: git bash prompt like, but much shorter and also working for darwin.
function gitContents() {
    if [[ $(git rev-parse --is-inside-work-tree 2>&1 | grep fatal | wc -l) -eq 0  ]] ; then
            _gitBranch=$(git status -s -b | head -1 | sed 's/^##.//')
            _gitStatus=$(git status -s -b | tail -n +2 | sed 's/^\(..\).*/\1/' | sort | uniq | tr "\n" " " | sed -e 's/ //g' -e 's/??/?/' -e 's/^[ ]*//')
            echo $_gitStatus $_gitBranch
    fi
}

# git-specific aliases and functions
function setupGit() {
   debug common.zshrc in setupGit
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
    echo 'function gipua() { for remoterepo in $(grep "^\[remote" $(git rev-parse --show-toplevel)/.git/config | sed -e "s/.remote \"//" -e s"/..$//") ; do git push --all $remoterepo ; git push --tags $* ; done ; }'
}

# ---- k8s -----------------------------------------------------------------------

# Kubernetes-specific aliases and functions
function setupK8s() {
   debug common.zshrc in setupK8s
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

# ---- Linux -----------------------------------------------------------------------

function setupLinux() {          # Linux-specific settings of aliases and shell-functions
   debug4 common.zshrc in setupLinux
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
   function syrestart() { systemctl restart $* ; systemctl --no-pager status $* ; }
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

# ---- Darwin alias OSX -----------------------------------------------------------------------

# Darwin- alias OSX-specific settings of aliases and shell-functions
function setupOSX() {
   debug4 common.zshrc in setupOSX
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
      brew update && brew upgrade && brew upgrade --cask --greedy &&  brew autoremove && brew cleanup # casks are also updated to today's brew upgrade && brew cu -ay # cu := cask upgrade
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
   debug4 common.zshrc in setupOSX_PostgreSQL '(non-docker installation)'
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

# ---- Processes -----------------------------------------------------------------------

function killUser() { # kill all processes of a user $*
    local user
    for user in $*
    do
        echo killing user $user... 1>&2
        ps -ef | grep $user | awk '{print $2}' | xargs kill -9
    done
}

# ---- SSH  -----------------------------------------------------------------------

# ssf finds a host entry in ssh configuration files in ~/.ssh/config.d/*.config. Earlier versions used ~/.ssh/config.d/* but
# this makes it complex to disable files and keep them for a while.
export SSF_SURROUNDING_LINES='--colour -A 3' # variable to be adjusted in .profile.post
function ssf() { egrep -v '^[[:space:]]*#' ~/.ssh/*config ~/.ssh/config.d/*.config | egrep -v ProxyJump | eval egrep -i $SSF_SURROUNDING_LINES --colour=auto "$*" ; }

# show the ssh-fingerprints for the supplied files. ssh-keygen does not support multiple files
function sshFingerprint() { for file in $* ; do  echo -n $file': ' ; ssh-keygen -lf "$file" ; done ; }

# show the ssh-certificate for the supplied files. ssh-keygen does not support multiple files
function sshCertificate() { for file in $* ; do ssh-keygen -Lf "$file" ; done ; }

function sshPriv2PubKey() { ssh-keygen -yf $1 ;  } # create public key out of private key


function sshagent_findsockets {
   debug8 common.zshrc in sshagent_findsockets
   find /tmp -uid $(id -u) -type s -name agent.\* 2>/dev/null
}

function sshagent_testsocket {
   debug8 common.zshrc in sshagent_testsocket
    [ ! -x "$(which ssh-add)" ] && echo "ssh-add is not available; agent testing aborted" && return 1

    [ X"$1" != X ] && export SSH_AUTH_SOCK=$1

    [ X"$SSH_AUTH_SOCK" = X ] && return 2

    if [ -S $SSH_AUTH_SOCK ] ; then
        ssh-add -l &> /dev/null
        if [ $? = 2 ] ; then
            debug12  "socket $SSH_AUTH_SOCK is dead! Deleting!"; rm -f $SSH_AUTH_SOCK; return 4
        elif [ $? = 1 -a $(ssh-add -l  2>/dev/null | wc -l) -eq 0 ] ; then
            ssh-add
        else
            debug12 "ssh-agent found: $SSH_AUTH_SOCK"; return 0
        fi
    else
        debug12 "$SSH_AUTH_SOCK is not a socket!"; return 3
    fi
}

function sshagent_init { #  ssh agent sockets can be attached to a ssh daemon process or an ssh-agent process.
    debug4 common.zshrc in sshagent_init
    local AGENTFOUND=0
    local agentsocket

    if sshagent_testsocket ; then AGENTFOUND=1 ; fi # Attempt to find and use the ssh-agent in the current environment

    # If there is no agent in the environment, search /tmp for possible agents to reuse before starting a fresh ssh-agent process.
    if [ $AGENTFOUND = 0 ] ; then
        debug8 No agent found
         for agentsocket in $(sshagent_findsockets) ; do
            debug8 Loop findsockets
            if [ $AGENTFOUND != 0 ] ; then break ; fi
            if sshagent_testsocket $agentsocket ; then AGENTFOUND=1 ; fi
         done
         eval `ssh-agent`
      else
        debug8 Agent found
    fi
    [[ $(ssh-add -l 2>/dev/null | grep  'no identities' | wc -l) -eq 1 ]] && ssh-add # load keys if none loaded so far
}

function sshSetup() {
   debug common.zshrc in sshSetup
   alias sagent="sshagent_init"     # SSH setup
   sshagent_init
}

function TRAPEXIT() {
   [ $(id -u) -eq 0 ] && test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`  # kill agent if leaving root
}

# ---- TLS  -----------------------------------------------------------------------

# ------ Certs
# create fingerprint of certificate
function tlsCertFingerprint() {  local output="/dev/null" ; [ "$1" = -v ] &&  output="/dev/stdout" && shift ; local file; for file in $*; do /bin/echo -n "$file:" > $output; openssl x509 -modulus -noout -in "$file" | openssl sha256 | sed 's/.*stdin)= //' ; done;  }

# split -p not existing under Linux .... > switch to simple ruby as existing on most plaforms
# show certificate (replacing the package version tlsCertView) - removed awk against split
# function tlsCert() { 
#    setopt +o nomatch ; 
#    local file
#    local infile
#    local tmpCertDir=$(mktemp -d tmpx.XXXXXX); trap "rm -fr $tmpCertDir" INT TERM EXIT;

#    for file in $* ; do
#       split -p "-----BEGIN CERTIFICATE" $file $tmpCertDir/$file.
#       for infile in $tmpCertDir/$file*; do 
#          openssl x509 -in "$infile" -subject -email -issuer -dates -sha256 -serial -noout -ext 'subjectAltName' 2>/dev/null | sed -e "s,^,$(basename $infile .in):,"; openssl x509 -in "$infile" -modulus -noout 2>/dev/null | openssl sha256 |  sed -e "s,^.*= ,$(basename $infile .in):SHA256 Fingerprint=,"; 
#       done; 
#    done
#    setopt -o nomatch; 
# }

function tlsCert() {
   local a=$(mktemp /tmp/tlsCert.XXXXXXXX)
   trap "rm -f $a" EXIT
   cat >> $a <<EOF
#!/usr/bin/env ruby
VERSION="v2.1.23"
args    = ARGV.join(" ")
count   = -1 
outarr  = Array.new()
# read lines beginning with BEGIN CERTIFICATE and the following into an outarr
IO.foreach(args) do | name |
    if name.include? "----BEGIN CERTIFICATE"
        count += 1
    end
    outarr[count] = outarr[count].to_s + name if count >= 0 
end
print "Number of certificates (#{VERSION}): ", count+1, "\n"
print "================================\n"
(count+1).times do |val|
    IO.popen("openssl x509 -in - -subject -email -issuer -dates -sha256 -serial -noout -ext 'subjectAltName,authorityKeyIdentifier,subjectKeyIdentifier' 2>/dev/null", "w+") do |proc|
         proc.write(outarr[val])
         proc.close_write
         puts "--------------------------------" if val > 0
        
         proc.readlines.each { |x| 
            if x.length > 1 
               print (x.to_s.gsub("\n", ""))
               print ("\n") if not [ "Identifier", "Alternative Name" ].any?{ |s| x.include? s } 
            end
         }
    end
end
print "================================\n"
EOF
   ruby $a $*
   unset a
}

# ------ Keys
# show fingerprint of private RSA key
function tlsRsaPrvFingerprint() { local output="/dev/null" ; [ "$1" = -v ] &&  output="/dev/stdout" && shift ; local file; for file in $*; do /bin/echo -n "$file:" > $output; openssl rsa -modulus -noout -in "$file" | openssl sha256 | sed 's/.*stdin)= //'; done; }
# show fingerprint of public RSA key
function tlsRsaPubFingerprint() { local output="/dev/null" ; [ "$1" = -v ] &&  output="/dev/stdout" && shift ; local file; for file in $*; do /bin/echo -n "$file:" > $output; openssl rsa -modulus -noout -pubin -in "$file" | openssl sha256 | sed 's/.*stdin)= //'; done; }

function tlsRsaPrv2PubKey() { openssl rsa -in $1 -pubout; }

# ------ CSR
function tlsCsr() { local file; for file in $*; do openssl req -in "$file"  -noout -utf8 -text | sed "s,^,$file:," | egrep -v '.*:.*:.*:'; done; }

# ---- ZSH Profile Versioning  -----------------------------------------------------------------------

# setVersion defines the version of this shell scripts. It creates an output with the current version number
# if the version number changes.
function zshSetVersion() {
   debug in zshSetVersion
   # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
   # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
   # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
   # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
   # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
   # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
   export ZSH_RC_VERSION="1.1.3"
   debug ZSH_RC_VERSION is $ZSH_RC_VERSION
   # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   [ ! -z $ZSH_MMONRC_VERSION ] && [ $ZSH_MMONRC_VERSION != $ZSH_RC_VERSION ] && echo new commonrc version $ZSH_RC_VERSION. 1>&2
   ZSH_MMONRC_VERSION=$ZSH_RC_VERSION
}

# set all the aliases for the shell    # OS independent setup
function zshShellAliases() {
   debug common.zshrc in zshShellAliases
   CDPATH=.:~

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
   alias rl='source ~/.zshrc'          # see also rlFull
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

function setupOSSpecifics() { # OS specific settings and functions
   debug common.zshrc in setupOSSpecifics
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

function main() {
   umask 0022
   loadSource pre
   case $- in
      *i*) #  "This shell is interactive"
         [ -z $NO_zshSetVersion ]        && zshSetVersion
         [ -z $NO_zshShellAliases ]      && zshShellAliases
         [ -z $NO_setupGit ]             && setupGit
         [ -z $NO_setupK8s ]             && setupK8s
         [ -z $NO_setupOSSpecifics ]     && setupOSSpecifics
         [ -z $NO_sshSetup ]             && sshSetup
         [ -z $NO_realUserForHadm ]      && realUserForHadm
         [ -z $NO_loadPost ]             && loadSource post
         NEWLINE=$'\n'
         if [ -z $NO_ownPrompt ] ; then
            PROMPT='%(?..%F{red}%?%F{white} • )%F{green}%n@%m%F{white} • %* • $fg[yellow]$(gitContents)$reset_color • $fg[red]$AWS_PROFILE$reset_color • %{$fg[cyan]%}%c%{$reset_color%}${NEWLINE}'
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
