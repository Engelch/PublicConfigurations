debug LOADING zsh.git.sh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ ! -z $NO_zshGit ] && debug exiting zsh.git.sh && return 

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

# EOF
