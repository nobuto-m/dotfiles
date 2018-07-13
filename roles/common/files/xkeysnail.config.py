
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
        K("C-a"): K("HOME"),
        K("C-e"): K("END"),
    },
    "Firefox")

# Keybindings for VS Code
define_keymap(
    re.compile("^Code$"), {
        K("C-p"): K("UP"),
        K("C-n"): K("DOWN"),
        K("C-b"): K("LEFT"),
        K("C-f"): K("RIGHT"),
        K("C-a"): K("HOME"),
        K("C-e"): K("END"),
        K("C-h"): K("BACKSPACE"),
        K("C-k"): [K("END"), K("Shift-HOME"), K("C-x")],
    }, "VS Code")
