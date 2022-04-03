debug LOADING zsh.os-specific.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ ! -z $NO_os_specific ] && debug exiting zsh.os-specific.sh && return 

# ---- Darwin alias OSX -----------------------------------------------------------------------


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

   # useful only for Mac OS Silicon M1, 
   # still working but useless for the other platforms
   docker() {
      if [[ `uname -m` == "arm64" ]] && [[ "$1" == "run" || "$1" == "build" ]]; then
         /usr/local/bin/docker "$1" --platform linux/amd64 "${@:2}"
      else
         /usr/local/bin/docker "$@"
      fi
   }

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

[ -z $NO_setupOSX ] && setupOSX
[ -z $NO_setupOSX_PostgreSQL ] && setupOSX_PostgreSQL

# EOF
