debug LOADING zsh.os-specific.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ ! -z $NO_os_specific ] && debug exiting zsh.os-specific.sh && return 

function setupOSSpecifics() { # OS specific settings and functions
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

# ---- Linux -----------------------------------------------------------------------

function setupLinux() {          # Linux-specific settings of aliases and shell-functions
   debug4 '>>>>' setupLinux
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

# called by zshenv!!!
function setupOSXPaths() {
   debug4 '>>>>' setupOSXPaths
   for _POTENTIAL_DIR in \
      /opt/homebrew/bin /opt/homebrew/opt/gnu-getopt/bin /usr/local/opt/gnu-getopt/bin /opt/homebrew/opt/ \
      /opt/homebrew/opt/openssl\@1.1/bin /usr/local/opt/openssl\@1.1/bin \
      /opt/homebrew/opt/curl/bin  /usr/local/opt/curl/bin/ /usr/local/opt/gnu-getopt/bin \
      /opt/homebrew/opt/java/bin /usr/local/opt/java/bin /Library/Java/JavaVirtualMachines/current/bin \
      /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin \
      /Applications/Visual\ Studio\ Code.app//Contents/Resources/app/bin/ \
      /Applications/Sublime\ Text.app/Contents/MacOS/
   do
        debug4 checking for dir $_POTENTIAL_DIR
        [ -d "$_POTENTIAL_DIR/." ] && debug8 adding path element $_POTENTIAL_DIR && PATH="$_POTENTIAL_DIR":$PATH
    done
}


# Darwin- alias OSX-specific settings of aliases and shell-functions
function setupOSX() {
   debug4 '>>>>' setupOSX
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
   debug4 '>>>>' setupOSX_PostgreSQL '(non-docker installation)'
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

# ---- BSD -----------------------------------------------------------------------

function setupBSD() { 
   debug4 setupBSD
   alias proc='ps auxww | egrep -i '
   alias o=xdg-open
   alias open=o
   alias xlock='xlock -remote -mode blank -allowroot'
   alias xl=xlock
}

# EOF
