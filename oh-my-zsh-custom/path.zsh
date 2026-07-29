# Custom binaries from the dotfiles repo
export PATH="$DOTFILES/oh-my-zsh-custom/bin:$PATH"

# Auto-add ./node_modules/.bin to PATH when present, so locally
# installed CLI tools (vitest, eslint, etc.) run without pnpm exec.
autoload -Uz add-zsh-hook
_local_node_bin=""
_update_local_node_bin() {
  if [[ -n "$_local_node_bin" ]]; then
    PATH="${PATH//:$_local_node_bin/}"
    PATH="${PATH//$_local_node_bin:/}"
  fi
  if [[ -d "$PWD/node_modules/.bin" ]]; then
    _local_node_bin="$PWD/node_modules/.bin"
    export PATH="$_local_node_bin:$PATH"
  else
    _local_node_bin=""
  fi
}
add-zsh-hook chpwd _update_local_node_bin
_update_local_node_bin
