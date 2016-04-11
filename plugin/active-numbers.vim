" ActiveNumbers - Only show line numbers in the active window
" Author:     Austin W. Smith
" Version:    1.1.1

if exists('g:loaded_activenumbers')
  finish
endif
let g:loaded_activenumbers = 1

" ==VARIABLES==

" Plugin enabled by default {{{
if !exists('g:actnum_enabled')
  let g:actnum_enabled = 1
endif
" }}}

" Take over 'number' & 'relativenumber' {{{
" Set active-numbers globals to match what 'nu' & 'rnu' would be,
" unless globals were predefined by the user.
if !exists('g:active_number')
  let g:active_number = &number
endif
if !exists('g:active_relativenumber')
  let g:active_relativenumber = &relativenumber
endif
" }}}

" Excluded filetypes {{{
" these don't need line numbers
if !exists('g:actnum_exclude')
  let g:actnum_exclude =
        \ [ 'unite', 'tagbar', 'startify', 'undotree', 'gundo', 'vimshell', 'w3m' ]
endif
" }}}

" ==FUNCTIONS==

" On Window Enter {{{
function! s:OnEnter()
  if exists('w:actnum_ignore') || !g:actnum_enabled
    return
  endif
  if index(g:actnum_exclude, &ft) == -1
    let &number = g:active_number
    let &relativenumber = g:active_relativenumber
  else
    setlocal nonumber norelativenumber
  endif
endfunction
" }}}

" On Window Leave {{{
function! s:OnLeave()
  if exists('w:actnum_ignore') || !g:actnum_enabled
        \ || index(g:actnum_exclude, &ft) >= 0
    return
  endif
  if g:active_number
    if !&l:number
      " user did :set nonumber
      let g:active_number = 0
    endif
  elseif &l:number
    " user did :set number
    let g:active_number = 1
  endif
  if g:active_relativenumber
    if !&l:relativenumber
      " user did :set norelativenumber
      let g:active_relativenumber = 0
    endif
  elseif &l:relativenumber
    " user did :set relativenumber
    let g:active_relativenumber = 1
  endif
  setlocal norelativenumber nonumber
endfunction
" }}}

" Toggle/Enable/Disable entire plugin {{{
" :ActiveNumbers <no-arguments> = toggle
" :ActiveNumbers on|off = enable|disable
function! s:PluginOnOff(type)
  if a:type == ''
    call <SID>PluginOnOff(g:actnum_enabled ? 'off' : 'on')
  else
    if a:type == 'off'
      let g:actnum_enabled = 0
      echo 'ActiveNumbers disabled'
    elseif a:type == 'on'
      let g:actnum_enabled = 1
      echo 'ActiveNumbers enabled'
      " refresh windows
      let currwin=winnr()
      tabdo windo call <SID>OnEnter()
      execute currwin . 'wincmd w'
    endif
  endif
endfunction
command! -complete=customlist,<SID>PluginOnOffCompletion -nargs=? -bar
      \ ActiveNumbers call <SID>PluginOnOff(<q-args>)

" pretty flexible custom completion
" please let me know if there's a less verbose way to do this
" it only needs to complete 2 very short words T_T
function! s:PluginOnOffCompletion(ArgLead, L, P)
  if match(a:ArgLead, '^on') == 0
    return [ 'on' ]
  elseif match(a:ArgLead, '^of') == 0
    return [ 'off' ]
  else
    return [ 'off', 'on' ]
  endif
endfunction
" }}}

" Ignore current window {{{
" :ActiveNumbersIgnore  = window ignored by active-numbers
" :ActiveNumbersIgnore! = window acknowledged by active-numbers
function! s:WindowIgnore(bang)
  if !a:bang
    let w:actnum_ignore = 1
    echo 'Window ignored by ActiveNumbers'
  else
    if exists('w:actnum_ignore')
      unlet w:actnum_ignore
    endif
    echo 'Window acknowledged by ActiveNumbers'
  endif
endfunction
command! -bang -bar ActiveNumbersIgnore call <SID>WindowIgnore(<bang>0)
" }}}

" ==AUTOCMDS==

augroup active_numbers
  au!
  au User Startified call <SID>OnEnter()
  au WinEnter,BufEnter,VimEnter * call <SID>OnEnter()
  au WinLeave,BufLeave * call <SID>OnLeave()
augroup END

" vim: set foldmethod=marker:
