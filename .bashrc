fastfetch
alias chat="eval $HOME/Projects/chat-Gpt-Cli/chat"
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias del='rm -rf'
alias fzf='fzf --preview="bat --color=always {}"'
alias cd='z'
alias n=nvim
alias v=vim
alias g=git
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias x=clear
alias mk=mkdir
alias b='cd ..'
alias load='source ~/.bashrc'
alias themes='cd $HOME/.config/nvim/lua/ashish/plugins/themes/'
alias nf='nvim $(fzf)'
alias cp='cp -i'                           # Interactive copy
alias mv='mv -i'                           # Interactive move
alias rm='rm -I --preserve-root'           # Safer remove
alias ln='ln -i'                           # Interactive link
alias code="/mnt/c/Users/KIIT0001/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"

# ===== SHELL OPTIONS =====
set bell-style mute
shopt -s histappend
shopt -s cmdhist
shopt -s nocaseglob
shopt -s checkwinsize
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s expand_aliases
shopt -s extglob

# ===== HISTORY CONFIGURATION =====
PROMPT_COMMAND='history -a'
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE="ls:ll:cd:pwd:clear:history:exit"
export HISTTIMEFORMAT="%F %T "

# ===== COLOR CONFIGURATION =====
export CLICOLOR=2
export LSCOLORS=GxFxCxDxBxegedabagaced
export GREP_COLORS='mt=1;33'

# Add color to man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ===== KEY BINDINGS =====
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ===== HOMEBREW =====
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ===== FUNCTIONS =====
# System monitoring
sysinfo() {
    echo "=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Load: $(cat /proc/loadavg | cut -d' ' -f1-3)"
    echo "Memory: $(free -h | grep '^Mem' | awk '{print $3"/"$2}')"
    echo "Disk: $(df -h / | tail -1 | awk '{print $3"/"$2" ("$5" used)"}')"
    echo "Users: $(who | wc -l) logged in"
}

# Make directory and change to it
mkcd() {
    mkdir -p "$1" && cd "$1"
}
# Toggle the Visibility of github repositories

toggle_visibility() {
  local user="ashish2508"
  local repo="$1"
  current_visibility=$(gh repo view "$user/$repo" --json visibility -q '.visibility')

  if [[ "$current_visibility" == "PUBLIC" ]]; then
    gh repo edit "$user/$repo" --visibility=private --accept-visibility-change-consequences
    echo "$repo is now PRIVATE"
  elif [[ "$current_visibility" == "PRIVATE" ]]; then
    gh repo edit "$user/$repo" --visibility=public --accept-visibility-change-consequences
    echo "$repo is now PUBLIC"
  else
    echo "Unknown visibility: $current_visibility"
  fi
}

# Run code files with automatic compilation/interpretation
run() {
    [[ -z "$1" ]] && {
        echo "Usage: run <filename>"
        echo "Supported: .c, .cpp, .cc, .cxx, .c++, .java, .go, .py, .js, .ts, .rs, .rb, .php, .sh"
        return 1
    }

    [[ ! -f "$1" ]] && { echo "Error: File '$1' not found"; return 1; }

    local file="$1"
    local ext="${file##*.}"
    local basename="${file%.*}"
    local start_time end_time duration

    start_time=$(date +%s.%N)

    case "$ext" in
        c)
            gcc -std=c17 -Wall -Wextra -O2 "$file" -o "$basename" && "./$basename"
            ;;
        cpp|cc|cxx|c++)
            g++ -std=c++20 -Wall -Wextra -O2 "$file" -o "$basename" && "./$basename"
            ;;
        java)
            javac "$file" && java "$basename"
            ;;
        go)
            go run "$file"
            ;;
        py)
            python3 "$file"
            ;;
        js)
            if command -v bun &> /dev/null; then
                bun "$file"
            else
                node "$file"
            fi
            ;;
        ts)
            if command -v bun &> /dev/null; then
                bun run "$file"
            elif command -v tsx &> /dev/null; then
                tsx "$file"
            elif command -v ts-node &> /dev/null; then
                ts-node "$file"
            else
                echo " Error: Install bun, tsx, or ts-node for TypeScript execution"
                return 1
            fi
            ;;
        rs)
            rustc -O "$file" -o "$basename" && "./$basename"
            ;;
        rb)
            ruby "$file"
            ;;
        php)
            php "$file"
            ;;
        sh)
            bash "$file"
            ;;
        *)
            echo " Error: Unsupported file extension '$ext'"
            echo "Supported: .c, .cpp, .cc, .cxx, .c++, .java, .go, .py, .js, .ts, .rs, .rb, .php, .sh"
            return 1
            ;;
    esac

    local exit_code=$?
    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "unknown")

    if [[ $exit_code -eq 0 ]]; then
        echo "${duration}sec"
    else
        echo "Exited with code $exit_code"
    fi

    return $exit_code
}

# ===== PROMPT CONFIGURATION =====
eval "$(oh-my-posh init bash --config ~/.poshthemes/robbyrussell.omp.json)"

# FNM (Fast Node Manager)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "`fnm env`"
fi

# ===== LANGUAGE RUNTIMES AND TOOLS =====
# Go
export GOROOT="$HOME/sdk/go1.24.4"
export PATH="$GOROOT/bin:$HOME/go/bin:$PATH"

# Rust
source "$HOME/.cargo/env"

# Bun
export PATH="$HOME/.bun/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ===== SYSTEM PATHS =====
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/snap/bin"
export PATH="/home/linuxbrew/.linuxbrew/bin/lua-language-server:$PATH"

# ===== ENVIRONMENT VARIABLES =====
export CODE="/mnt/c/Users/KIIT0001/Desktop/CODE/"
export DONT_PROMPT_WSL_INSTALL=1
export BASHRC_LOADED=1

# ===== ZOXIDE (BETTER CD) =====
eval "$(zoxide init bash)"

. "$HOME/.cargo/env"

# fnm
FNM_PATH="/home/ash/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# pnpm
export PNPM_HOME="/home/ash/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# Set it to the correct bob-managed path
export VIMRUNTIME=/home/ash/.local/share/bob/v0.11.3/share/nvim/runtime

