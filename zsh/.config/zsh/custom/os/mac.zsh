eval $(/opt/homebrew/bin/brew shellenv)

source $(brew --prefix nvm)/nvm.sh

export PATH="/opt/homebrew/opt/llvm/bin:$PATH:/Applications/Docker.app/Contents/Resources/bin/"

alias vim="nvim"

function chpwd() {
  if [[ -f .zsh-enter ]]; then
    source .zsh-enter
  fi
}
