# called by zshenv!!!
function setupOSXPaths() {
   debug4 '>>>>' setupOSXPaths
   for _POTENTIAL_DIR in \
      /opt/homebrew/bin /opt/homebrew/sbin /opt/homebrew/opt/gnu-getopt/bin /usr/local/opt/gnu-getopt/bin /opt/homebrew/opt/ \
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

debug LOADING zsh.path.Darwin.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setupOSXPaths

# EOF