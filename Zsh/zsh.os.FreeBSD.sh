function setupBSD() { 
   debug4 setupBSD
   alias proc='ps auxww | egrep -i '
   alias o=xdg-open
   alias open=o
   alias xlock='xlock -remote -mode blank -allowroot'
   alias xl=xlock
}

debug LOADING zsh.os.FreeBSD.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setupBSD

# EOF
