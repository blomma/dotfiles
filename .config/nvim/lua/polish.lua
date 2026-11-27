-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Neovim 0.12's redesigned message and cmdline UI (experimental). With
-- cmdheight = 0 the legacy UI raises a "Press ENTER" prompt whenever messages
-- need more than one line; ui2 collapses them behind a `[+x]` indicator
-- instead. `g<` shows recent messages in full.
local ui2 = require "vim._core.ui2"
ui2.enable {}

-- Loading a session closes every window, ui2's hidden message windows too, and
-- ends with an `:edit`. Its LSP detach redraws, and ui2 then tries to reopen its
-- windows while the buffer is closing, failing with E1159 ("Cannot open a float
-- when closing the buffer"). Reopen them before that `:edit`.
require("resession").add_hook("post_load", function() ui2.check_targets() end)
