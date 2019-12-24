
from xkeysnail.transform import define_keymap
from xkeysnail.transform import define_modmap
from xkeysnail.transform import K
from xkeysnail.transform import Key

import re

# [Global modemap]
define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL  # xkb-options=['ctrl:nocaps']
})

# [Global keymap]
define_keymap(None, {
    K("KATAKANAHIRAGANA"): K("Shift-F10")  # as MENU key
})

# Keybindings for Web browser
define_keymap(
    re.compile("^(Firefox|Chromium)$"),
    {
        K("C-n"): K("DOWN"),  # override Firefox "New Window"
        K("C-b"): K("LEFT"),  # override Gmail, Google Docs "Bold"
        K("C-p"): K("UP"),  # override Google Docs "Print"
        K("C-f"): K("RIGHT"),  # override Google Docs "Find"

        K("C-a"): K("HOME"),  # For Google Docs
        K("C-e"): K("END"),  # For Google Docs

        K("C-h"): K("BACKSPACE"),  # override Google Docs "Find and replace"
        K("C-d"): K("DELETE"),  # For Google Docs

        K("C-Shift-f"): K("C-f"),  # Replacement of the original C-f
        K("C-Shift-e"): K("C-e"),  # Replacement of the original C-e
        K("C-Shift-d"): K("C-d"),  # Replacement of the original C-d
    },
    "Web browser")
