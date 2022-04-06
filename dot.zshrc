
# install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH/." -o ! -z $ownPrompt ] ; then 
    unset ZSH
    unset fg
    declare -A fg
    fg[red]=$(tput setaf 1)
    fg[yellow]=$(tput setaf 3)
    reset_color=$(tput setaf 7)
else
    # Set name of the theme to load --- if set to "random", it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    #ZSH_THEME="robbyrussell"
    ZSH_THEME="agnoster"

    # Set list of themes to pick from when loading at random
    # Setting this variable when ZSH_THEME=random will cause zsh to load
    # a theme from this variable instead of looking in $ZSH/themes/
    # If set to an empty array, this variable will have no effect.
    # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

    # Uncomment the following line to use case-sensitive completion.
    # CASE_SENSITIVE="true"

    # Uncomment the following line to use hyphen-insensitive completion.
    # Case-sensitive completion must be off. _ and - will be interchangeable.
    # HYPHEN_INSENSITIVE="true"

    # Uncomment one of the following lines to change the auto-update behavior
    # zstyle ':omz:update' mode disabled  # disable automatic updates
    # zstyle ':omz:update' mode auto      # update automatically without asking
    # zstyle ':omz:update' mode reminder  # just remind me to update when it's time

    # Uncomment the following line to change how often to auto-update (in days).
    zstyle ':omz:update' frequency 2

    # Uncomment the following line if pasting URLs and other text is messed up.
    # DISABLE_MAGIC_FUNCTIONS="true"

    # Uncomment the following line to disable colors in ls.
    # DISABLE_LS_COLORS="true"

    # Uncomment the following line to disable auto-setting terminal title.
    # DISABLE_AUTO_TITLE="true"

    # Uncomment the following line to enable command auto-correction.
    # ENABLE_CORRECTION="true"

    # Uncomment the following line to display red dots whilst waiting for completion.
    # You can also set it to another string to have that shown instead of the default red dots.
    # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
    # Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
    # COMPLETION_WAITING_DOTS="true"

    # Uncomment the following line if you want to disable marking untracked files
    # under VCS as dirty. This makes repository status check for large repositories
    # much, much faster.
    # DISABLE_UNTRACKED_FILES_DIRTY="true"

    # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # You can set one of the optional three formats:
    # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # or set a custom format using the strftime function format specifications,
    # see 'man strftime' for details.
    # HIST_STAMPS="mm/dd/yyyy"
    HIST_STAMPS="yyyy-mm-dd"

    # Would you like to use another custom folder than $ZSH/custom?
    # ZSH_CUSTOM=/path/to/new-custom-folder

    # Which plugins would you like to load?
    # Standard plugins can be found in $ZSH/plugins/
    # Custom plugins may be added to $ZSH_CUSTOM/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    plugins=(rails git ruby)

    source $ZSH/oh-my-zsh.sh
fi


export PROFILES_CONFIG_DIR=$(ls -l $HOME/.zshrc | awk '{ print $NF }' | xargs dirname)
PROFILES_CONFIG_DIR=$(cd; cd $PROFILES_CONFIG_DIR; /bin/pwd) # assure it is an absolute path
debug PROFILES_CONFIG_DIR: $PROFILES_CONFIG_DIR

function main() {
    local files
   umask 002 # umask for group work
   loadSource pre
   # potentially reread .zshenv, but required as oh-my-zsh seems to destroy the PATH variable.
    # Optimised just to reread the cached path file

    case $- in
        *i*) #  "This shell is interactive"
            for files in $PATHFILE $PROFILES_CONFIG_DIR/Zsh/zsh.common.*.sh; do
                if [ -f $files ] ; then
                    debug .zshrc sourcing $files
                    source $files
                else
                    echo WARNING: cannot find $files 1>&2
                fi 
            done 
            # load os-specifics
            if [ -f "$PROFILES_CONFIG_DIR/Zsh/zsh.os.$(uname).sh" ] ; then
                debug8 OS is $(uname)
                source "$PROFILES_CONFIG_DIR/Zsh/zsh.os.$(uname).sh"
            else
                err4 No OS-specific path file "$PROFILES_CONFIG_DIR/Zsh/zsh.os.$(uname).sh" found
            fi
            # prompts
            NEWLINE=$'\n'
            if [ ! -z $ownPrompt ] ; then
                setopt PROMPT_SUBST
                PROMPT='%(?..%F{red}%?%F{white} • )%F{green}%n@%m%F{white} • %* • %F{yellow}$(gitContents)%F{white} • %F{red}$AWS_PROFILE%F{white} • %{%F{cyan}%c%{%F{white}%}'${NEWLINE}%F{black}
                RPROMPT=
            fi
            bindkey '^R' history-incremental-pattern-search-backward # history-incremental-search-backward
            realUserForHadm
            [ -z $NO_loadPost ]             && loadSource post
            ;;
        *) #echo "This is a script";;
            ;;
    esac
}

main $@
return 0

# EOF
