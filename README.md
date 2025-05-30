vim-active-numbers
==================

Only show line numbers in the current active window.

<p align="center">
  <img src="https://raw.github.com/AssailantLF/images/master/vimactivenumbers.gif">
</p>

Basic Usage
-----------

Works out of the box, and will follow however you have the `'number'` and
`'relativenumber'` options set.

These are usually set in your vimrc:

    set number relativenumber

It also automatically updates whenever those options are changed.

Optional Unnecessary Commands
-----------------------------

**1. Enable, Disable, or Toggle the plugin entirely:**

    :ActiveNumbers on
    :ActiveNumbers off
    :ActiveNumbers {no-arguments} = toggle

**2. Ignore the current window:**

    :ActiveNumbersIgnore  = window ignored by ActiveNumbers
    :ActiveNumbersIgnore! = window acknowledged by ActiveNumbers

Example: `:ActiveNumbersIgnore | set nu nornu` to keep persistent, non-relative
line numbers which in that window. ActiveNumbers is now ignoring that window.

Another example: `:tabdo windo ActiveNumbersIgnore!` to stop ignoring all windows.

**3. Change the appearance of active line numbers:**

:triangular_flag_on_post: *This command is pointless unless you have a really old version of vim. Just use `:set` rather than this command.* :triangular_flag_on_post:

:SetActiveNumbers {option(s)}

Works just like normal `:set`, but also updates the plugin.

Example: `:SetActiveNumbers rnu!` to toggle relative numbers.

Excluded Filetypes
------------------

Some plugins and filetypes don't need line numbers. Here are the filetypes
ignored by default:

    let g:actnum_exclude =
          \ [ 'unite', 'tagbar', 'startify', 'undotree', 'gundo', 'vimshell', 'w3m' ]

Put this in your vimrc to exclude what you want.

Installation
------------

- [vim-plug](https://github.com/junegunn/vim-plug)
  - `Plug 'auwsmit/vim-active-numbers'`
- [Pathogen](https://github.com/tpope/vim-pathogen)
  - `git clone git://github.com/auwsmit/vim-active-numbers.git ~/.vim/bundle/vim-active-numbers`
- Manual installation:
  - Copy the files to your `.vim` directory (`vimfiles` on Windows)

Related plugins
---------------

* [numbers.vim](https://github.com/myusuf3/numbers.vim)
* [CursorLineCurrentWindow](https://github.com/vim-scripts/CursorLineCurrentWindow)
* [diminactive.vim](https://github.com/blueyed/vim-diminactive)

Thanks
------

I got some ideas and code cues from numbers.vim and CursorLineCurrentWindow.
The basic readme format came from
[sneak.vim](https://github.com/justinmk/vim-sneak).

Bugs
----

See the issue tracker, and if you come across any bugs, please post an issue for it.

License
-------

MIT. See the LICENSE file in this repository.

TODO
----

* Write help docs
* Update gif
