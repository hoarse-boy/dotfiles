function fish_user_key_bindings
  fish_vi_key_bindings
  bind -M insert -m default jk force-repaint
  # bind -M insert -m default jk backward-char force-repaint # backward-char will move the cursor back
end
