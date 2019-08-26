
from xkeysnail.transform import define_keymap
from xkeysnail.transform import define_modmap
from xkeysnail.transform import K
from xkeysnail.transform import Key

import re

# [Global modemap]
define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL  # xkb-options=['ctrl:nocaps']
})

# Keybindings for Firefox
define_keymap(
    re.compile("^Firefox$"),
    {
        K("C-n"): K("DOWN"),  # override Firefox "New Window"
        K("C-b"): K("LEFT"),  # override Gmail, Google Docs "Bold"
        K("C-p"): K("UP"),  # override Google Docs "Print"
        K("C-f"): K("RIGHT"),  # override Google Docs "Find"
        K("C-h"): K("BACKSPACE"),  # override Google Docs "Find and replace"
        K("C-Shift-f"): K("C-f"),  # Firefox "Find in this page"
        K("C-a"): K("HOME"),  # For Google Docs
        K("C-e"): K("END"), # For Google Docs
        K("C-d"): K("DELETE"), # For Google Docs
        K("C-Shift-d"): K("C-d"), # For Google Meets
    },
    "Firefox")
