export FZF_DEFAULT_COMMAND="rg --files --sortr=modified"
export GIT_EDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$HOME/_CODE/go/bin:$PATH"

# fzf
# fe [FUZZY PATTERN] - Open the selected file with the default editor
# #   - Bypass fuzzy finder if there's only one match (--select-1)
# #   - Exit if there's no match (--exit-0)
fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --preview 'bat --color=always {}' --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}" && print -s vim "${files[@]}"
}

take() {
    mkdir -p "$1" && cd "$1"
}

r() {
    cd "$(git rev-parse --show-toplevel 2>/dev/null)"
}

tmp () {
    [ "$1" = "view" ] && cd /tmp/workspaces && cd $(ls -t | fzf --preview 'ls -A {}') && return 0
    r="/tmp/workspaces/$(xxd -l3 -ps /dev/urandom)"
    mkdir -p -p "$r" && pushd "$r"
}

recently_modified() {
    recent_file=$(ls -t | head -n1)
    echo "Most recently modified file: $recent_file"
}

compress() {
    if [ -z "$1" ]; then echo "Usage: compress <archive_name.zip> <file1> <file2> ..."
    else zip -r "$1" "${@:2}"
    fi
}

zle			-N		fe
bindkey		'^O' 	fe

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh


export MUSIC_DIR="$HOME/Documents/Musique"

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && . $HOME/.nix-profile/etc/profile.d/nix.sh

[ -f $HOME/.local/miniconda3/etc/profile.d/conda.sh ] && . $HOME/.local/miniconda3/etc/profile.d/conda.sh

alias l='exa -la'
alias hx='helix'
alias tempdir='cd $(mktemp -d)'

# Prompt related stuff
# Get git branch on the right side
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%b'

# Get left prompt
# This uses will determine the color according to if we're in insert mode or not
vim_ins_mode="%F{cyan}> %b"
vim_cmd_mode="%F{red}> %b"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish
PROMPT='%(?.%F{blue}%1~%f.%F{red}%1~%f) %B${vim_mode}%b'

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
# Thanks Ron! (see comments)
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}

setopt AUTO_CD

# Direnv
eval "$(direnv hook zsh)"

# Add some colors for fzf
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#b3b1ad,bg:#0f1419,hl:#59c2ff
 --color=fg+:#dadde0,bg+:#34455a,hl+:#ffcc66
 --color=info:#f9af4f,prompt:#91b362,pointer:#cbccc6
 --color=marker:#f9af4f,spinner:#f9af4f,header:#d4bfff'

# Converge shortcuts
alias gd='cd ~/_CODE/Converge/geodude-hw-app'
alias on='cd ~/_CODE/Converge/onix-hw-app'
alias ts='cd ~/_CODE/Converge/tilt-sensor-hw-app'
alias vim='nvim'

# ZSH
autoload -U compinit && compinit
source $HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=($HOME/.local/share/zsh/plugins/zsh-completions/src $fpath)
fpath=($HOME/.local/share/zsh/completions $fpath)


# History
setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands

SAVEHIST=100000
HISTSIZE=100000
HIST_STAMPS="yyyy-mm-dd"
HISTORY_IGNORE="(ls|cd|pwd|exit|zi|l)*"
HISTFILE=$HOME/.local/share/zsh/.zsh_history

# nnn
export NNN_OPENER="$HOME/.config/nnn/plugins/nuke"
export NNN_BMS="c:$HOME/_CODE/Converge"

# Go
export GOPATH=$HOME/_CODE/go

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
# shellcheck disable=SC2154
if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
    chpwd_functions+=(__zoxide_hook)
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$@[-1]" == "${__zoxide_z_prefix}"?* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@[-1]}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# Completions.
if [[ -o zle ]]; then
    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            _files -/
        elif [[ "${words[-1]}" == '' ]] && [[ "${words[-2]}" != "${__zoxide_z_prefix}"?* ]]; then
            \builtin local result
            # shellcheck disable=SC2086,SC2312
            if result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- ${words[2,-1]})"; then
                result="${__zoxide_z_prefix}${result}"
                # shellcheck disable=SC2296
                compadd -Q "${(q-)result}"
            fi
            \builtin printf '\e[5n'
        fi
        return 0
    }

    \builtin bindkey '\e[0n' 'reset-prompt'
    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete __zoxide_z
fi

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin alias z=__zoxide_z
\builtin alias zi=__zoxide_zi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"

# Enable command editing
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
