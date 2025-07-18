vim-active-numbers
==================

Only show line numbers in the current active window. Save some screen space.

<p align="center">
  <img src="https://raw.github.com/AssailantLF/images/master/vimactivenumbers.gif">
</p>

Basic Usage
-----------

Works out of the box, and will follow however you have the `'number'` and
`'relativenumber'` options set.

These are usually set in your vimrc:

    set number relativenumber

It also automatically updates whenever those options are changed
(doesn't update with `:setlocal`).

Optional Commands
-----------------

**1. Enable or Disable the plugin entirely:**

    :ActiveNumbers toggle | <no args>
    :ActiveNumbers on
    :ActiveNumbers off

**2. Ignore the current window:**

    :ActiveNumbersIgnore  = window ignored by ActiveNumbers
    :ActiveNumbersIgnore! = window acknowledged by ActiveNumbers

Example: `:ActiveNumbersIgnore | setlocal nu nornu` to keep persistent,
non-relative line numbers in that window which ActiveNumbers will ignore.

Another example: `:tabdo windo ActiveNumbersIgnore!` to stop ignoring all windows.

**3. Change the appearance of active line numbers:**

    :SetActiveNumbers {option(s)}

This command is only necessary if you disable auto-updating via the
`g:activenumbers_autoupdate` option.

Works just like normal `:set`, but also updates the plugin.

Example: `:SetActiveNumbers rnu!` to toggle relative numbers.

Filetype and Plugin Exceptions
------------------------------

For compatibility with specific filetypes and/or plugins, these options are available:

**1. Exclude specific filetypes (these are the defaults).**

    let g:activenumbers_exclude = [ 'unite', 'tagbar', 'startify', 'undotree', 'gundo', 'vimshell', 'w3m' ]

Let me know if there's something you want to be added as a default.

**2. Disable auto-updating options.**

Enabled by default, this updates the plugin whenever `'number'` or
'`relativenumber`' are updated globally (not `:setlocal`). This can cause
problems if any plugins ever change global line number options.

When auto-updating is disabled, you can use the `:SetActiveNumbers` just like
`:set` to update the plugin's 'active' line numbers without having to reload Vim.

    let g:activenumbers_autoupdate = 0

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
