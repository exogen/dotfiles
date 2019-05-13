
# shell options

shopt -s histappend    # append instead of overwrite history
shopt -s cmdhist       # properly save multi-line commands
shopt -s lithist       # don't replace newlines with semicolons in history
shopt -s cdspell       # fix typos when changing directories
shopt -u hostcomplete  # disable hostname completion, which is fine but
                       # interferes with completion of paths containing '@',
                       # like scoped npm modules

# history

export HISTFILESIZE=8000              # write more history
export HISTSIZE=8000                  # remember more history
export HISTCONTROL=ignoreboth         # ignore commands beginning with a space
                                      # and duplicates
export HISTIGNORE='ls:bg:fg:history'  # ignore lame commands
export PROMPT_COMMAND='history -a'    # store history immediately

# colors

export RESET='\e[0m'
export BLACK='\e[0;30m'
export RED='\e[0;31m'
export GREEN='\e[0;32m'
export YELLOW='\e[0;33m'
export BLUE='\e[0;34m'
export PURPLE='\e[0;35m'
export CYAN='\e[0;36m'
export WHITE='\e[0;37m'

export CLICOLOR=1

# configure colors for less (man pages, searching, etc.)

export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)    # red
export LESS_TERMCAP_md=$(tput bold; tput setaf 4)    # blue
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput setaf 7; tput setab 5) # white on magenta
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput setaf 7)    # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# aliases

alias ll="ls -al"
alias ..="cd .."
alias s="s"
alias d="git diff"
alias ag="ag --color-path='32' --color-line-number='33' --color-match='37;45'"
alias get="http --download"

# helpers

function mkcd {
    # Make a directory and change to it.
    mkdir -p "$1" && cd "$1"
}

function sec {
    # Convert seconds since UNIX Epoch to a readable date.
    date -j -r "$1"
}

function ms {
    # Convert milliseconds since UNIX Epoch to a readable date.
    date -j -r "$(($1/1000))"
}

function play {
    # Skip DASH manifest for speed purposes. This might actually disable
    # being able to specify things like 'bestaudio' as the requested format,
    # but try anyway.
    # Get the best audio that isn't WebM, because afplay doesn't support it.
    # Use "$*" so that quoting the requested song isn't necessary.
    youtube-dl --default-search=ytsearch: \
               --youtube-skip-dash-manifest \
               --output="${TMPDIR:-/tmp}/%(title)s-%(id)s.%(ext)s" \
               --restrict-filenames \
               --format="bestaudio[ext!=webm]" \
               --exec=afplay "$*"
}

function mp3 {
    # Get the best audio, convert it to MP3, and save it to the current
    # directory.
    youtube-dl --default-search=ytsearch: \
               --restrict-filenames \
               --format=bestaudio \
               --extract-audio \
               --audio-format=mp3 \
               --audio-quality=1 "$*"
}

function dirdiff {
    diff --unified --new-file --recursive \
        --exclude .eslintcache \
        --exclude .git \
        --exclude coverage \
        --exclude node_modules \
        --exclude package-lock.json \
        --exclude yarn.lock \
        "$1" "$2" ${@:3} | colordiff
}

# completion

if [ -f $(which npm) ]; then
    eval "$(npm completion)"
fi

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if [ -f $(which pip3) ]; then
    eval "$(pip3 completion --bash)"
fi

# path

export PATH="./node_modules/.bin:$PATH:$HOME/bin"

# preferences

export EDITOR=vim

# prompt

function shorten_prompt_cwd {
    CWD=$(echo "$PWD" | sed -e "s,^$HOME,~,")
    # leave the first 10 characters alone
    echo -n "${CWD:0:15}"
    # truncate intermediate directories in the remaining string
    echo "${CWD:15}" | sed -e "s,\([.]*[^/]\)\([^/][^/]*\)/,\1…/,g"
}

export PS1="\n\[${BLUE}\][ \$( shorten_prompt_cwd )\[${GREEN}\]\$( __git_ps1 ' ± %s' | sed -e 's/[.]\{3\}/…/' ) \[${BLUE}\]] \[${YELLOW}\]⚡\[${RESET}\] "

# node environments

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
