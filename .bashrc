alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias del='rm -rf'
alias fzf='fzf --preview="bat --color=always {}"'
alias n=nvim
alias v=vim
alias g=git
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gc='git commit -m'
alias gp='git push'
alias x=clear
alias mk=mkdir
alias b='cd ..'
alias load='source ~/.bashrc'
alias themes='cd /home/ash/.config/nvim/lua/ashish/plugins/themes/'
alias sem='cd /mnt/c/users/KIIT0001/Desktop/CODE/semester/'
alias config='cd /mnt/c/users/KIIT0001/AppData/Roaming/alacritty/'
set bell-style mute
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE="ls:ll:cd:pwd:clear:history:exit"
export HISTTIMEFORMAT="%F %T "

export CLICOLOR=2
export LSCOLORS=GxFxCxDxBxegedabagaced
export GREP_COLORS='mt=1;33'

shopt -s nocaseglob
shopt -s checkwinsize
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s expand_aliases
shopt -s extglob


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


mkcd() {
  mkdir -p "$1" && cd "$1"
}
#git/gh starts
create-pr() {
  if [ -z "$1" ]; then

    echo "Usage: create-pr \"Your commit message\""
    return 1
  fi
  gh pr create --base main --head master --title "$1"
}

# Function to list GitHub Pull Requests with optional filters
list-pr() {
  if [ -z "$1" ]; then
    gh pr list
  else
    gh pr list --state "$1"

  fi
}

# Function to merge a GitHub Pull Request by number
merge-pr() {
  if [ -z "$1" ]; then
    echo "Usage: merge-pr <PR_number>"
    return 1
  fi
  echo "Merging Pull Request #$1..."
  gh pr merge "$1" --merge
}

#git pr ended here

#to run code 
run() {
  if [ -z "$1" ]; then
    echo "Usage: run <filename.{c,cpp,cxx,cc,c++,java,go}>"
    return 1
  fi

  EXT="${1##*.}"
  BASENAME="${1%.*}"

  case "$EXT" in
    c)
      gcc -std=c11 "$1" && ./a.out
      ;;
    cpp|cc|cxx|c++)
      g++ -std=c++20 "$1" && ./a.out
      ;;
    java)
      javac "$1" && java "$BASENAME"
      ;;
    go)
      go run "$1"
      ;;
    *)
      echo "Error: Unsupported file extension. Use .c, .cpp, .cc, .cxx, .c++, .java, or .go"
      return 1
      ;;
  esac
}


garbage() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: delete_files <extension_to_delete> <extension_to_ignore>"
        return 1
    fi

    EXTENSION_TO_DELETE=$1
    EXTENSION_TO_IGNORE=$2

    find . -type f -name "*.$EXTENSION_TO_DELETE" ! -name "*.$EXTENSION_TO_IGNORE" -delete

    echo "Deleted all *.$EXTENSION_TO_DELETE files, ignoring *.$EXTENSION_TO_IGNORE files."
}



eval "$(oh-my-posh init bash --config ~/.poshthemes/robbyrussell.omp.json)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# fnm
FNM_PATH="/home/ash/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi



# Add color to man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'



[ -f ~/.fzf.bash ] && source ~/.fzf.bash
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export PATH=$PATH:/usr/local/go/bin
