# TypeScript commands
#
# Every scripts/bin/<name>.ts becomes a `<name>` command. Drop a file in and
# that's it — no symlink, no chmod. Node runs .ts natively.
#
# Node only strips types from files that actually end in .ts, so an
# extensionless executable on PATH can't work — zsh does the name mapping
# instead, by defining one function per script.

for _ts_command in $DOTFILES/scripts/bin/*.ts(N); do
  functions[${_ts_command:t:r}]="node ${(q)_ts_command} \"\$@\""
done
unset _ts_command

# Scripts added after this shell started aren't functions yet — catch them on
# first use, so a brand-new command works without `reload`.
command_not_found_handler() {
  local script="$DOTFILES/scripts/bin/$1.ts"

  if [[ -f $script ]]; then
    functions[$1]="node ${(q)script} \"\$@\""
    "$@"
    return $?
  fi

  print -u2 "zsh: command not found: $1"
  return 127
}
