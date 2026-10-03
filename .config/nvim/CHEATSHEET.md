# Neovim keymap cheat sheet

**Space → k** (N) opens this sheet; `:close` closes its split.

**N** normal · **I** insert · **V** visual · **S** select · **O** operator-pending (after `d`/`c`/`y`) · **T** terminal input.
Keys like `gd` are sequential; `Ctrl+j` is held together; capitals require Shift.

## Dialogs and pickers

### Snacks pickers (search, notifications, selection)

File-opening actions require a file result.

| Keys                                                    | Mode / focus                | Action                                                    |
| ------------------------------------------------------- | --------------------------- | --------------------------------------------------------- |
| `Ctrl+c`                                                | I, input                    | Cancel and close immediately                              |
| `Esc`                                                   | I, input                    | Leave insert mode                                         |
| `Esc` or `q`                                            | N, input/list/preview       | Cancel and close                                          |
| `Enter`                                                 | N/I, input; N, list         | Confirm the current result                                |
| `Shift+Enter`                                           | N/I, input; N, list         | Choose a destination window, then jump                    |
| `Down` / `Up`, `Ctrl+j` / `Ctrl+k`, `Ctrl+n` / `Ctrl+p` | N/I, input; N, list         | Next / previous result                                    |
| `j` / `k`, `gg` / `G`                                   | N, input/list               | Next / previous, first / last result                      |
| `Tab` / `Shift+Tab`                                     | N/I, input; N/V, list       | Toggle selection and move next / previous                 |
| `Ctrl+a`                                                | N/I, input; N, list         | Toggle selection of all results                           |
| `Ctrl+Down` / `Ctrl+Up`                                 | N/I, input                  | Next / previous search-history entry                      |
| `Ctrl+d` / `Ctrl+u`                                     | N/I, input; N, list         | Scroll the result list down / up                          |
| `Ctrl+f` / `Ctrl+b`                                     | N/I, input; N, list         | Scroll the preview down / up                              |
| `Alt+p` / `Alt+m`                                       | N/I, input; N, list         | Toggle preview / maximize                                 |
| `Alt+h` / `Alt+i`                                       | N/I, input; N, list         | Toggle hidden / ignored files                             |
| `Alt+f`                                                 | N/I, input; N, list         | Toggle following symlinks                                 |
| `Alt+r`                                                 | N/I, input                  | Toggle regex matching                                     |
| `Ctrl+g`                                                | N/I, input                  | Toggle live search                                        |
| `Ctrl+g`                                                | N, list                     | Print the result's path                                   |
| `Alt+w`                                                 | N/I, input; N, list/preview | Cycle focus between picker windows                        |
| `/`                                                     | N, input/list               | Switch between input and list                             |
| `i`                                                     | N, list/preview             | Focus the input field                                     |
| `Ctrl+s` / `Ctrl+v` / `Ctrl+t`                          | N/I, input; N, list         | Open in horizontal split / vertical split / new tab       |
| `Ctrl+q`                                                | N/I, input; N, list         | Send results to quickfix                                  |
| `Ctrl+w`                                                | I, input                    | Delete the previous word                                  |
| `Ctrl+r`, then `%` / `#`                                | I, input                    | Insert current / alternate buffer filename                |
| `Ctrl+r`, then `Ctrl+w` / `Ctrl+a`                      | I, input                    | Insert word / WORD under the original cursor              |
| `Ctrl+r`, then `Ctrl+l`                                 | I, input                    | Insert the original cursor's line                         |
| `Ctrl+r`, then `Ctrl+f` / `Ctrl+p`                      | I, input                    | Insert filename under the original cursor / its full path |
| `Ctrl+w`, then `H` / `J` / `K` / `L`                    | N, input/list               | Move the picker layout left / bottom / top / right        |
| `zt` / `zz` / `zb`                                      | N, list                     | Scroll the current result to top / center / bottom        |
| `Alt+d`                                                 | N/I, input; N, list         | Inspect the result item                                   |
| `?`                                                     | N, input/list               | Show help for that picker window                          |

### Snacks text prompts (rename, breakpoint conditions)

| Keys          | Mode | Action                                                  |
| ------------- | ---- | ------------------------------------------------------- |
| `Ctrl+c`      | I    | Cancel and close immediately                            |
| `Esc`         | I    | Dismiss completion if open; otherwise leave insert mode |
| `Esc`         | N    | Dismiss completion if open; otherwise cancel and close  |
| `q`           | N    | Cancel and close                                        |
| `Enter`       | N/I  | Accept completion if open; otherwise confirm the input  |
| `Up` / `Down` | N/I  | Previous / next input-history entry                     |
| `Tab`         | I    | Select the next completion or start completion          |
| `Ctrl+w`      | I    | Delete the previous word                                |

`q` closes the notification-history window opened with `:lua require("snacks").notifier.show_history()`.

## Editing and windows

| Keys                                                 | Mode | Action                                                     |
| ---------------------------------------------------- | ---- | ---------------------------------------------------------- |
| `Ctrl+s`                                             | N/V  | Force-write the current file if changed                    |
| `Ctrl+q`                                             | N    | Quit the current window, discarding its unsaved changes    |
| `\|`                                                 | N    | Create a vertical split                                    |
| `\`                                                  | N    | Create a horizontal split                                  |
| `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l`            | N    | Move to the left / below / above / right split             |
| `Ctrl+Up` / `Ctrl+Down` / `Ctrl+Left` / `Ctrl+Right` | N    | Resize the split in that direction                         |
| `Tab` / `Shift+Tab`                                  | V/S  | Indent / unindent and keep the selection                   |
| `jk` or `jj` within 300 ms                           | I    | Leave insert mode                                          |
| `gcc`                                                | N    | Toggle a line comment                                      |
| `gc` + motion                                        | N    | Toggle comments over a motion, e.g. `gcip` for a paragraph |
| `gc`                                                 | V    | Toggle comments over the selection                         |
| `gco` / `gcO`                                        | N    | Add a comment below / above and start typing               |
| `gc`                                                 | O    | Comment text object, e.g. `dgc` deletes a comment block    |

## Text movement and selection

In visual mode, motions extend the selection. Add counts where supported: `3w` moves three words, `5j` moves five lines.

### Line and word motions (N/V/O)

| Keys                  | Action                                                           |
| --------------------- | ---------------------------------------------------------------- |
| `h` / `l`             | Move one character left / right                                  |
| `0` / `^`             | First character / first non-blank character of the line          |
| `$` / `g_`            | Last character / last non-blank character of the line            |
| `g0` / `g$`           | Start / end of the displayed line when text wraps                |
| `w` / `b` / `e`       | Next word start / previous word start / forward to a word end    |
| `W` / `B` / `E`       | Same word motions, treating punctuation as part of the word      |
| `ge` / `gE`           | Previous word end / previous whitespace-separated word end       |
| `f<char>` / `F<char>` | Find a character forward / backward on this line                 |
| `t<char>` / `T<char>` | Stop just before / after a character forward / backward          |
| `;` / `,`             | Repeat the last `f`/`F`/`t`/`T` in the same / opposite direction |
| `%`                   | Jump to the matching delimiter or paired keyword                 |

### Moving through the buffer

| Keys                  | Mode  | Action                                                         |
| --------------------- | ----- | -------------------------------------------------------------- |
| `j` / `k`             | N/V   | Down / up a displayed line; with a count, move by actual lines |
| `gj` / `gk`           | N/V/O | Down / up a displayed line, even with a count                  |
| `gg` / `G`            | N/V/O | First / last line of the buffer                                |
| `42G` or `42gg`       | N/V/O | Go to line 42                                                  |
| `Ctrl+d` / `Ctrl+u`   | N/V   | Down / up half a screen                                        |
| `Ctrl+f` / `Ctrl+b`   | N/V   | Down / up a screen                                             |
| `H` / `M` / `L`       | N/V/O | Top / middle / bottom of the window                            |
| `{` / `}`             | N/V/O | Previous / next paragraph                                      |
| `(` / `)`             | N/V/O | Previous / next sentence                                       |
| `/text`, then `Enter` | N/V/O | Search forward for text                                        |
| `?text`, then `Enter` | N/V/O | Search backward for text                                       |
| `n` / `N`             | N/V/O | Repeat the search in the same / opposite direction             |
| `*` / `#`             | N     | Search forward / backward for the word under the cursor        |
| `Ctrl+o` / `Ctrl+i`   | N     | Back / forward through previous jumps                          |
| `zz` / `zt` / `zb`    | N/V   | Scroll the cursor's line to the center / top / bottom          |

### Selecting text

| Keys                         | Mode | Action                                                         |
| ---------------------------- | ---- | -------------------------------------------------------------- |
| `v`                          | N    | Start a character selection, then move                         |
| `V`                          | N    | Select the line; move to select more whole lines               |
| `Ctrl+v`                     | N    | Start a rectangular selection, then move                       |
| `v0` / `v$`                  | N    | Select from the cursor to the start / end of the line          |
| `ggVG`                       | N    | Select the whole buffer                                        |
| `VG` / `Vgg`                 | N    | Select whole lines to the end / start of the buffer            |
| `vG$` / `vgg0`               | N    | Select from the cursor to the end / start of the buffer        |
| `viw` / `vaw`                | N    | Select a word / a word with surrounding whitespace             |
| `viW` / `vaW`                | N    | Select a whitespace-separated word / include surrounding space |
| `vip` / `vap`                | N    | Select a paragraph / include surrounding blank lines           |
| `vi"` / `va"`, `vi'` / `va'` | N    | Select inside quotes / include the quotes                      |
| `vib` / `vab`                | N    | Select inside parentheses / include the parentheses            |
| `viB` / `vaB`                | N    | Select inside braces / include the braces                      |
| `gv`                         | N    | Reselect the previous selection                                |
| `o`                          | V    | Move to the other end of the selection                         |
| `Esc`                        | V    | Cancel the selection                                           |
| `y` / `d` / `c`              | V    | Copy / delete / change the selected text                       |

Text objects also follow operators: `diw` deletes a word; `ci"` changes text inside quotes.

## Navigation (N)

`ö` replaces `[`, `ä` replaces `]`; the original bracket shortcuts also work.

| Keys                     | Action / condition                                                                                     |
| ------------------------ | ------------------------------------------------------------------------------------------------------ |
| `öb` / `äb`              | Previous / next buffer                                                                                 |
| `öB` / `äB`              | First / last buffer; with a count, go to that buffer number                                            |
| `öt` / `ät`              | Previous / next tab page                                                                               |
| `öq` / `äq`              | Previous / next quickfix entry                                                                         |
| `öQ` / `äQ`              | First / last quickfix entry                                                                            |
| `ö` / `ä`, then `Ctrl+q` | Previous / next file in the quickfix list                                                              |
| `öl` / `äl`              | Previous / next location-list entry                                                                    |
| `öL` / `äL`              | First / last location-list entry                                                                       |
| `ö` / `ä`, then `Ctrl+l` | Previous / next file in the location list                                                              |
| `ö` / `ä`, then `Ctrl+t` | Previous / next tag in the preview window                                                              |
| `öd` / `äd`              | Previous / next diagnostic                                                                             |
| `öe` / `äe`              | Previous / next error                                                                                  |
| `öw` / `äw`              | Previous / next warning                                                                                |
| `öy` / `äy`              | Previous / next symbol, after Aerial attaches                                                          |
| `öY` / `äY`              | Previous / next symbol at a higher outline level, after Aerial attaches                                |
| `ör` / `är`              | Previous / next highlighted LSP reference in the current buffer                                        |
| `öT` / `äT`              | Previous / next TODO comment                                                                           |
| `ö` / `ä`, then `Space`  | Add an empty line above / below the cursor                                                             |
| `<b` / `>b`              | Move the current buffer left / right in the buffer ordering                                            |
| `öa` / `äa`              | Previous / next argument-list file, without Treesitter argument motions                                |
| `öA` / `äA`              | First / last argument-list file (count selects numbered argument), without Treesitter argument motions |

Counts work when supported, e.g. `3äb` advances three buffers.

## Code and diagnostics

LSP actions require an attached language server supporting the action.

| Keys                           | Mode  | Action                                                     |
| ------------------------------ | ----- | ---------------------------------------------------------- |
| `gd` / `gD`                    | N     | Definition / declaration                                   |
| `gI` or `gri`                  | N     | Implementations                                            |
| `gy` or `grt`                  | N     | Type definition                                            |
| `grr`                          | N     | References                                                 |
| `grn`                          | N     | Rename the symbol                                          |
| `gra`                          | N/V   | Code actions                                               |
| `grx`                          | N     | Run CodeLens                                               |
| `gO`                           | N     | Document symbols                                           |
| `K`                            | N     | Hover documentation; press again to focus the hover window |
| `gK`                           | N     | Signature help                                             |
| `Ctrl+s`                       | I/S   | Signature help                                             |
| `gl`                           | N     | Show diagnostics for the current line                      |
| `Ctrl+w`, then `d` or `Ctrl+d` | N     | Show the diagnostic float for the current line             |
| `öD` / `äD`                    | N     | First / last diagnostic in this buffer                     |
| `öc` / `äc`                    | N/V/O | Previous / next change in a diff buffer                    |

## Leap

Type two target characters, then a displayed label if needed.

| Keys                  | Mode        | Action                              |
| --------------------- | ----------- | ----------------------------------- |
| `s`                   | N/V/O       | Leap forward in the current window  |
| `S`                   | N/V/O       | Leap backward in the current window |
| `gs`                  | N/V/O       | Leap to a target in another window  |
| `Enter` / `Backspace` | During Leap | Next / previous target              |
| `Esc`                 | During Leap | Cancel                              |

## Text objects and code structure

### Treesitter text objects

Requires a parser and matching language captures. In **V/O**, `a` includes surroundings; `i` selects contents.

| Around / inside | Structure            |
| --------------- | -------------------- |
| `ak` / `ik`     | Block                |
| `ac` / `ic`     | Class                |
| `a?` / `i?`     | Conditional          |
| `af` / `if`     | Function             |
| `ao` / `io`     | Loop                 |
| `aa` / `ia`     | Argument / parameter |

`vif` selects a function body; `daa` deletes an argument.

Movement: **N/V/O**. Swapping: **N**.

| Previous / next start | Previous / next end | Swap previous / next | Structure            |
| --------------------- | ------------------- | -------------------- | -------------------- |
| `ök` / `äk`           | `öK` / `äK`         | `<K` / `>K`          | Block                |
| `öf` / `äf`           | `öF` / `äF`         | `<F` / `>F`          | Function             |
| `öa` / `äa`           | `öA` / `äA`         | `<A` / `>A`          | Argument / parameter |

`2äf` jumps two function starts; `väf` extends a visual selection to the next function start.

### Matching groups and node selection

| Keys        | Mode  | Action                                         |
| ----------- | ----- | ---------------------------------------------- |
| `ö%` / `ä%` | N/V/O | Previous / next unmatched group (Matchit)      |
| `ön` / `än` | V     | Select previous / next Treesitter node         |
| `öN` / `äN` | V     | Grow selection to previous / next sibling node |
| `öö` / `ää` | N/V/O | Previous / next section start in a text buffer |

### Snacks indentation scopes

| Keys        | Mode  | Action                          |
| ----------- | ----- | ------------------------------- |
| `ii` / `ai` | V/O   | Inside / full indentation scope |
| `öi` / `äi` | N/V/O | Top / bottom edge of the scope  |

## Completion and automatic pairs

### Blink completion and LuaSnip (I)

Keys fall back to their usual behavior when no completion/snippet action applies.

| Keys                                     | Action                                                                                       |
| ---------------------------------------- | -------------------------------------------------------------------------------------------- |
| `Ctrl+Space`                             | Show completion, then show/hide its documentation                                            |
| `Ctrl+n` / `Ctrl+p`                      | Next / previous completion; show the menu if hidden                                          |
| `Down` / `Up`, `Ctrl+j` / `Ctrl+k`       | Next / previous completion                                                                   |
| `Enter`                                  | Accept the selected completion                                                               |
| `Ctrl+y`                                 | Select and accept a completion                                                               |
| `Ctrl+e`                                 | Hide completion                                                                              |
| `Ctrl+u` / `Ctrl+d`, `Ctrl+b` / `Ctrl+f` | Scroll documentation up / down                                                               |
| `Tab`                                    | Next completion; otherwise next snippet field; otherwise trigger completion when appropriate |
| `Shift+Tab`                              | Previous completion; otherwise previous snippet field                                        |

### Command-line completion

| Keys                                  | Action                                                           |
| ------------------------------------- | ---------------------------------------------------------------- |
| `Tab` / `Shift+Tab`                   | Show completion and insert a candidate, or cycle next / previous |
| `Ctrl+Space`                          | Show completion                                                  |
| `Ctrl+n` / `Ctrl+p`, `Right` / `Left` | Next / previous completion                                       |
| `Ctrl+y`                              | Select and accept a completion                                   |
| `Ctrl+e`                              | Cancel completion and restore the original text                  |
| `End`                                 | Hide completion                                                  |

### nvim-autopairs

| Keys                             | Mode             | Action                                                                   |
| -------------------------------- | ---------------- | ------------------------------------------------------------------------ |
| Opening bracket / quote          | I                | Insert its matching partner when the pairing rules apply                 |
| Matching closing bracket / quote | I                | Skip over an existing closing partner when appropriate                   |
| `Backspace`                      | I                | Remove both sides of an empty pair                                       |
| `Alt+e`                          | I                | Fast-wrap text after an opening bracket/quote; select a displayed target |
| `h` / `l`, `$`                   | During fast-wrap | Choose before / after the target, or the line-end target                 |
| `Esc`                            | During fast-wrap | Cancel                                                                   |

## Git hunks (Gitsigns buffers)

| Keys        | Mode | Action                                   |
| ----------- | ---- | ---------------------------------------- |
| `ög` / `äg` | N    | Previous / next Git hunk                 |
| `öG` / `äG` | N    | First / last Git hunk                    |
| `ig`        | V/O  | Select the Git hunk, e.g. `vig` or `dig` |

## Neo-tree file explorer (N, filesystem tree)

| Keys                                    | Action                                                                   |
| --------------------------------------- | ------------------------------------------------------------------------ |
| `Enter`                                 | Open a file / expand or collapse a directory                             |
| `h` / `l`                               | Collapse or go to parent / expand, enter child, or open file             |
| `S` / `s` / `t`                         | Open in horizontal split / vertical split / new tab                      |
| `w`                                     | Open using the window picker                                             |
| `O` or `Shift+Enter`                    | Open with the system's default application                               |
| `P`                                     | Toggle preview                                                           |
| `Ctrl+f` / `Ctrl+b`                     | Scroll the preview down / up                                             |
| `C` / `z`                               | Close this node / all expanded nodes                                     |
| `R`                                     | Refresh the tree                                                         |
| `a` / `A`                               | Add file / directory                                                     |
| `d`                                     | Delete selected file(s) or directory(s)                                  |
| `r` / `b`                               | Rename / rename basename without extension                               |
| `y` / `x` / `p`                         | Copy / cut / paste through Neo-tree's clipboard                          |
| `Ctrl+r`                                | Clear Neo-tree's clipboard                                               |
| `c` / `m`                               | Copy / move to a typed destination                                       |
| `Y`                                     | Choose a filename/path/URI to copy to the system clipboard               |
| `Tab`                                   | Toggle selection of an item                                              |
| `Ctrl+Shift+i` / `Ctrl+;`               | Invert / clear selection                                                 |
| `Ctrl+s`                                | Jump to an item using labels                                             |
| `/` / `D`                               | Fuzzy-find files / directories                                           |
| `#` / `f`                               | Fuzzy-sort / filter on submission                                        |
| `Ctrl+x`                                | Clear the filter                                                         |
| `H`                                     | Toggle hidden/filtered items                                             |
| `Backspace` / `.`                       | Navigate up / make the selected directory the root                       |
| `i`                                     | Show file details                                                        |
| `e`                                     | Toggle automatic tree-window width                                       |
| `o`                                     | Show the ordering menu                                                   |
| `oc` / `od` / `om` / `on` / `os` / `ot` | Order by created time / diagnostics / modified time / name / size / type |
| `T`                                     | Show the terminal submenu                                                |
| `Tf` / `Th` / `Tv`                      | New floating / horizontal / vertical terminal in the selected directory  |
| `Esc`                                   | Close a preview or floating tree window                                  |
| `q`                                     | Close the tree window                                                    |
| `?`                                     | Show the full tree keymap help                                           |

### Neo-tree fuzzy finder

| Keys                         | Action                     |
| ---------------------------- | -------------------------- |
| `Down` / `Ctrl+n` / `Ctrl+j` | Next result                |
| `Up` / `Ctrl+p` / `Ctrl+k`   | Previous result            |
| `Esc`                        | Close                      |
| `Shift+Enter`                | Close, keeping the filter  |
| `Ctrl+Enter`                 | Close, clearing the filter |

## Neogit (N, status tab)

| Keys                           | Action                                                     |
| ------------------------------ | ---------------------------------------------------------- |
| `Tab` / `za`                   | Expand/collapse the current section, file, or hunk         |
| `zo` / `zc`                    | Open / close the fold                                      |
| `1` / `2` / `3` / `4`          | Set the detail depth                                       |
| `zC` / `zO`                    | Collapse to depth 1 / expand to depth 4                    |
| `s` / `u`                      | Stage / unstage the item or selected lines                 |
| `S` / `U`                      | Stage changes to tracked files / unstage all staged files  |
| `Ctrl+s`                       | Stage all files                                            |
| `x`                            | Discard changes to the item or selected lines              |
| `-`                            | Reverse the selected change                                |
| `K` / `R`                      | Untrack / rename the file                                  |
| `Enter` / `Shift+Enter`        | Go to / peek at the file                                   |
| `Ctrl+v` / `Ctrl+x` / `Ctrl+t` | Open file in vertical split / horizontal split / tab       |
| `{` / `}`                      | Previous / next hunk header                                |
| `öc` / `äc`                    | Open or scroll previous / next item                        |
| `Ctrl+k` / `Ctrl+j`            | Peek up / down                                             |
| `Ctrl+p` / `Ctrl+n`            | Previous / next section                                    |
| `Ctrl+r`                       | Refresh status                                             |
| `y` / `Y`                      | Show refs / copy the selected identifier                   |
| `$` / `Q`                      | Git command history / enter a Git command                  |
| `gp` / `o`                     | Go to parent repo / open the commit or branch in a browser |
| `c` / `b` / `l`                | Commit / branch / log popup                                |
| `f` / `p` / `P`                | Fetch / pull / push popup                                  |
| `d` / `Z`                      | Diff / stash popup                                         |
| `r` / `m` / `v`                | Rebase / merge / revert popup                              |
| `A` / `X`                      | Cherry-pick / reset popup                                  |
| `M` / `t` / `w`                | Remote / tag / worktree popup                              |
| `B` / `i` / `L`                | Bisect / ignore / margin popup                             |
| `I`                            | Initialize a Git repository                                |
| `q`                            | Close Neogit                                               |
| `?`                            | Show the popup/action menu                                 |

### Commit and rebase editors

| Keys                        | Context / mode            | Action                                          |
| --------------------------- | ------------------------- | ----------------------------------------------- |
| `Ctrl+c`, then `Ctrl+c`     | Commit/rebase editor, N/I | Submit                                          |
| `Ctrl+c`, then `Ctrl+k`     | Commit/rebase editor, N/I | Abort                                           |
| `Alt+p` / `Alt+n` / `Alt+r` | Commit editor, N          | Previous message / next message / reset message |
| `p` / `r` / `e` / `s` / `f` | Rebase editor, N          | Pick / reword / edit / squash / fixup           |
| `x` / `d` / `b`             | Rebase editor, N          | Execute / drop / break                          |
| `gk` / `gj`                 | Rebase editor, N          | Move a commit up / down                         |
| `Enter`                     | Rebase editor, N          | Open the commit                                 |
| `öc` / `äc`                 | Rebase editor, N          | Open or scroll previous / next item             |
| `q`                         | Commit/rebase editor, N   | Close the editor                                |

## Rust and C++ plugin windows (N)

| Keys                | Context                                       | Action                                                 |
| ------------------- | --------------------------------------------- | ------------------------------------------------------ |
| `q` / `Esc`         | Rust hover or code-action window              | Close                                                  |
| `Enter`             | Rust hover window                             | Run the action under the cursor, when present          |
| `Enter`             | Rust code-action window                       | Confirm the selected action                            |
| `q` / `Esc`         | crates.nvim popup                             | Hide the popup                                         |
| `Enter`             | Crate information / versions / features popup | Open URL / insert version / toggle feature             |
| `s`                 | Crate versions popup                          | Insert version using the opposite smart-insert setting |
| `yy`                | Crate popup                                   | Copy the value on the current line                     |
| `gd` or `K`         | Crate popup                                   | Go to the item on the current line                     |
| `Ctrl+i` / `Ctrl+o` | Crate popup                                   | Forward / back in popup history                        |
| `q`                 | clangd AST or symbol-info window              | Close                                                  |
| `q` / `Esc`         | CMake output window                           | Toggle the output window closed                        |

## Symbols outline (Aerial, N)

| Keys                     | Action                                              |
| ------------------------ | --------------------------------------------------- |
| `Enter`                  | Jump to the symbol                                  |
| `Ctrl+v` / `Ctrl+s`      | Jump in vertical / horizontal split                 |
| `p`                      | Scroll the source to the symbol                     |
| `Ctrl+j` / `Ctrl+k`      | Next / previous symbol and scroll the source        |
| `öy` / `äy`, `öY` / `äY` | Previous / next symbol, or symbol at a higher level |
| `o` / `za`, `O` / `zA`   | Toggle fold / toggle recursively                    |
| `l` / `zo`, `L` / `zO`   | Open fold / open recursively                        |
| `h` / `zc`, `H` / `zC`   | Close fold / close recursively                      |
| `zr` / `zm`              | Increase / decrease fold level                      |
| `zR` / `zM`              | Open / close all folds                              |
| `zx` / `zX`              | Synchronize folds with the source                   |
| `q`                      | Close the outline                                   |
| `?` or `g?`              | Show outline keymap help                            |

## Debugger and terminals

### Debugger function keys (N)

| Keys          | Action                    |
| ------------- | ------------------------- |
| `F5`          | Start / continue          |
| `F6`          | Pause                     |
| `F9`          | Toggle breakpoint         |
| `F10` / `F11` | Step over / into          |
| `Shift+F11`   | Step out                  |
| `Shift+F5`    | Terminate                 |
| `Shift+F9`    | Conditional breakpoint    |
| `Ctrl+F5`     | Restart the current frame |

**DAP UI (N):** `Enter` expands; `o` opens; `d` removes; `e` edits; `r` sends to REPL; `t` toggles; `w` adds a watch (where supported).

**DAP REPL (N):** `öö` / `ää` jump to the previous / next `dap>` prompt.

### ToggleTerm

| Keys                                      | Mode              | Action                                                           |
| ----------------------------------------- | ----------------- | ---------------------------------------------------------------- |
| `F7` or `Ctrl+'`                          | N/I/T             | Toggle the terminal; `Ctrl+'` requires terminal support          |
| Count + `F7`, e.g. `2F7`                  | N                 | Toggle the numbered terminal                                     |
| `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l` | T, split terminal | Move to a neighboring window                                     |
| `Ctrl+\`, then `Ctrl+n`                   | T                 | Leave terminal input mode and enter normal mode                  |
| `öö` / `ää`                               | N/V/O in terminal | Previous / next shell prompt; requires OSC 133 shell integration |

In a floating terminal, `Ctrl+h/j/k/l` are sent to the program.

## Dashboard and scratch buffers

Dashboard: **N**.

| Keys            | Action                                 |
| --------------- | -------------------------------------- |
| `f` / `n` / `g` | Find file / new file / find text       |
| `r` / `p` / `c` | Recent files / projects / config files |
| `s`             | Load last session                      |
| `h`             | Switch dashboard artwork               |
| `l` / `q`       | Open Lazy / quit Neovim                |

**Lua Snacks scratch buffer (N/V):** `Enter` executes the buffer or selection.

## Plugin and tool managers

### Lazy plugin manager (N)

| Keys                | Action                                              |
| ------------------- | --------------------------------------------------- |
| `Enter`             | Toggle plugin details                               |
| `K` or `gx`         | Open the link under the cursor                      |
| `d`                 | Show the diff                                       |
| `öö` / `ää`         | Previous / next plugin                              |
| `I` / `i`           | Install missing plugins / selected plugin           |
| `U` / `u`           | Update all / selected plugin, updating the lockfile |
| `C` / `c`           | Check updates for all / selected plugin             |
| `S`                 | Sync: install, clean, and update                    |
| `X` / `x`           | Clean unused plugins / delete the selected plugin   |
| `R` / `r`           | Restore all / selected plugin from the lockfile     |
| `L` / `gl`          | Show recent update logs for all / selected plugin   |
| `gb`                | Rebuild the selected plugin                         |
| `P` / `D` / `H`     | Profiling / debug view / home                       |
| `Ctrl+s` / `Ctrl+f` | Sort / filter the profiling view                    |
| `Ctrl+c`            | Abort running tasks                                 |
| `q` / `?`           | Close / show help                                   |

### Mason tool manager (N)

| Keys            | Action                                                   |
| --------------- | -------------------------------------------------------- |
| `Enter`         | Expand a package / toggle its installation log           |
| `i` / `u` / `X` | Install / update or reinstall / uninstall a package      |
| `c` / `C`       | Check selected package version / check outdated packages |
| `U`             | Update all installed packages                            |
| `Ctrl+c`        | Cancel an installation                                   |
| `Ctrl+f`        | Apply a language filter                                  |
| `g?`            | Toggle help                                              |
