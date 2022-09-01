# load completion
autoload -Uz compinit && compinit

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# key bindings
bindkey "^R" history-incremental-search-backward
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# history
HISTSIZE=100000000
SAVEHIST=100000000
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS

# configure colors for less (man pages, searching, etc.)
export CLICOLOR=1
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
alias s="git status"
alias d="git diff"
alias ag="ag --color-path='32' --color-line-number='33' --color-match='37;45'"
alias get="http --download"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# path
export PATH="./node_modules/.bin:$PATH:$HOME/.bin"

# node version manager
eval "$(fnm env)"

# tab title settings for iTerm
DISABLE_AUTO_TITLE="true"

precmd() {
  # Sets the tab title to current directory, not full path
  echo -ne "\e]1;${PWD##*/}\a"
}

# prompt

# enable command substitution in prompts
setopt PROMPT_SUBST

# add __git_ps1 command
source ~/.bin/git-prompt.sh

# trim cwd to a nice length
function shorten_prompt_cwd {
    CWD=$(echo "$PWD" | sed -e "s,^$HOME,~,")
    # leave the first 10 characters alone
    echo -n "${CWD:0:15}"
    # truncate intermediate directories in the remaining string
    echo "${CWD:15}" | sed -e "s,\([.]*[^/]\)\([^/][^/]*\)/,\1…/,g"
}

export PROMPT='%F{blue}[ $(shorten_prompt_cwd) ]%F{green}$(__git_ps1 " ± %s" | sed -e "s/[.]\{3\}/…/") %F{yellow}⚡%f'