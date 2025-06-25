# Load Composer tools
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Load custom binaries
export PATH="$HOME/.oh-my-zsh/custom/bin:$PATH"

# Load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# Load Yarn global installed binaries
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="/usr/local/sbin:$PATH"

# Use project specific binaries before global ones
#export PATH="node_modules/.bin:vendor/bin:$PATH"

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
