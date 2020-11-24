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
[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && . $HOME/.nix-profile/etc/profile.d/nix.sh

[ -f $HOME/.local/miniconda3/etc/profile.d/conda.sh ] && . $HOME/.local/miniconda3/etc/profile.d/conda.sh

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
