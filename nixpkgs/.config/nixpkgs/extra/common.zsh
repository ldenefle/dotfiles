# fe [FUZZY PATTERN] - Open the selected file with the default editor
# #   - Bypass fuzzy finder if there's only one match (--select-1)
# #   - Exit if there's no match (--exit-0)
fe() {
  local files
	IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
	[[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

zle			-N		fe
bindkey		'^O' 	fe

export MUSIC_DIR="$HOME/Documents/Musique"

 export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
. $HOME/.local/miniconda3/etc/profile.d/conda.sh

[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && $HOME/.nix-profile/etc/profile.d/nix.sh

alias gd='cd ~/_CODE/geodude-hw-app'
alias on='cd ~/_CODE/onix-hw-app'
alias l='exa -la'


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
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{blue}%1~%f%b ${vim_mode}'

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
# Thanks Ron! (see comments)
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}
