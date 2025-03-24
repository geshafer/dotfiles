ide_socket() {
  echo "/tmp/nvim-$(basename $PWD)"
}

ide() {
  nvim --listen $(ide_socket)
}
