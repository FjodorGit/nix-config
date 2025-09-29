function zvm_after_init() {
  # Unbind j and k in normal mode
  zvm_bindkey vicmd "j" undefined-key
  zvm_bindkey vicmd "k" undefined-key
}
