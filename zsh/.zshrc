function zvm_after_lazy_keybindings() {
  # Unbind j and k in normal mode
  zvm_bindkey vicmd "j" undefined-key
  zvm_bindkey vicmd "k" undefined-key
  zvm_bindkey vicmd " " undefined-key
}
