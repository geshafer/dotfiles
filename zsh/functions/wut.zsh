wut() {
  nvim --listen $(ide_socket) $(
    git diff --name-status --relative $(git mom) |
      awk '{ split($9, a); if ($1 != "D") { print $2; } }' &&
      git ls-files --others --exclude-standard
  )
}
