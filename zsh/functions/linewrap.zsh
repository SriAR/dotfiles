linewrap() {
  nvim -c "setlocal textwidth=72" \
       -c "setlocal formatoptions+=t" \
       -c "setlocal spell spelllang=en_us" \
       -c "setlocal linebreak"
}
