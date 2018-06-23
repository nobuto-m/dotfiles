# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# [Global modemap] Change modifier keys as in xmodmap
define_modmap({Key.CAPSLOCK: Key.LEFT_CTRL})

# Keybindings for Firefox
define_keymap(
    re.compile("^Firefox$"), {
        K("C-n"): K("DOWN"),
        K("C-b"): K("LEFT"),
    }, "Firefox")

# Keybindings for VS Code
define_keymap(
    re.compile("^Code$"), {
        K("C-p"): K("UP"),
        K("C-n"): K("DOWN"),
        K("C-b"): K("LEFT"),
        K("C-f"): K("RIGHT"),
    }, "VS Code")
