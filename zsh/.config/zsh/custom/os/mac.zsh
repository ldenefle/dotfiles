eval $(/opt/homebrew/bin/brew shellenv)

export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" --no-use
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  nvm "$@"
}

export PATH="/opt/homebrew/opt/llvm/bin:$PATH:/Applications/Docker.app/Contents/Resources/bin/"

alias vim="nvim"

function chpwd() {
  if [[ -f .zsh-enter ]]; then
    source .zsh-enter
  fi
}
