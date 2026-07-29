# Switch SSH + git signing between 1Password and a hardware key (YubiKey)

YUBI_PUB="$HOME/.ssh/id_ed25519_sk.pub"
OP_SSH_SIGN="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"

use-1p-key() {
  export SSH_MODE=1p

  # Commit signing → 1Password
  git config --global gpg.format ssh
  git config --global gpg.ssh.program "$OP_SSH_SIGN"

  echo "✅ Mode: 1Password"
  echo "   SSH + signing now use 1Password"
}

use-device-key() {
  export SSH_MODE=yubi

  # Commit signing → YubiKey
  git config --global gpg.format ssh
  git config --global gpg.ssh.program ""
  git config --global user.signingkey "$YUBI_PUB"

  echo "✅ Mode: Device key (YubiKey)"
  echo "   SSH + signing now use YubiKey"
}

ssh-mode() {
  echo "Current SSH_MODE : ${SSH_MODE:-1p (default)}"
  echo "Signing key      : $(git config --global --get user.signingkey)"
  echo "gpg.ssh.program  : $(git config --global --get gpg.ssh.program || echo 'system ssh')"
}
