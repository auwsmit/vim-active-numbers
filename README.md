## ActiveNumbers

Only show line numbers in the active window.

Clear the clutter of line numbers outside the current window. Line numbers
aren't usually relevant outside of the current file, anyway. It can also help
indicate which window is active.

### Basic Usage

Works out of the box™, and will follow however you have the `'number'` and
`'relativenumber'` options set.

These are usually set in your vimrc:

    set number relativenumber

Alternatively you can set globals to be more explicit:

    let g:active_number = 1
    let g:active_relativenumber = 1

If you want to change how numbers are displayed while Vim is running, just
change them as you would with `set` or `setlocal`.

### Functions

ActiveNumbers comes with two functions for when you need more control.

**Enable, Disable, or Toggle the plugin entirely:**

    :ActiveNumbers on
    :ActiveNumbers off
    :ActiveNumbers <no-arguments> = toggle

**Ignore the current window:**

    :ActiveNumbersIgnore  = window ignored by ActiveNumbers
    :ActiveNumbersIgnore! = window acknowledged by ActiveNumbers

Example: `:ActiveNumbersIgnore | set nu nornu` to have persistent, non-relative
line numbers in the current window.

Another example: `:tabdo windo ActiveNumbersIgnore!` to stop ignoring all windows.

### Excluded Filetypes

Some plugins and filetypes don't need line numbers. Here are the filetypes
ignored by default:

    let g:actnum_exclude =
          \ [ 'unite', 'tagbar', 'startify', 'undotree', 'gundo', 'vimshell', 'w3m' ]

In order to add more to the list, just put a superset of the above in your
vimrc. (Or include a subset if you like micro-optimization :P)

### Installation

- Manual installation:
  - Copy the files to your `.vim` directory (`_vimfiles` on Windows).
- [Pathogen](https://github.com/tpope/vim-pathogen)
  - `cd ~/.vim/bundle && git clone git://github.com/AssailantLF/vim-active-numbers.git`
- [Vundle](https://github.com/gmarik/vundle)
  1. Add `Plugin 'AssailantLF/vim-active-numbers'` to .vimrc
  2. Run `:PluginInstall`
- [NeoBundle](https://github.com/Shougo/neobundle.vim)
  1. Add `NeoBundle 'AssailantLF/vim-active-numbers'` to .vimrc
  2. Run `:NeoBundleInstall`
- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'AssailantLF/vim-active-numbers'` to .vimrc
  2. Run `:PlugInstall`

### Related plugins

* [numbers.vim](https://github.com/myusuf3/numbers.vim)
* [CursorLineCurrentWindow](https://github.com/vim-scripts/CursorLineCurrentWindow)
* [diminactive.vim](https://github.com/blueyed/vim-diminactive)

### Thanks

I got some ideas (namely excluded filetypes) and some source code cues from
numbers.vim and CursorLineCurrentWindow.  I got this readme format from
[Sneak](https://github.com/justinmk/vim-sneak).

### Bugs

None that I know of. If you find any bugs or unexpected behavior, or if you have
a suggestion for improvement, please post an issue.

### License

MIT. See the LICENSE file in this repository.

### TODO

* Write help docs
