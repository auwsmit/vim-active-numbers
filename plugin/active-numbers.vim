" ActiveNumbers - Only show line numbers in the active window
" Author:     Austin W. Smith
" Version:    2.0.0

if exists('g:loaded_activenumbers')
  finish
endif
let g:loaded_activenumbers = 1

" ==VARIABLES==

" Plugin enabled by default
if !exists('g:actnum_enabled')
  let g:actnum_enabled = 1
endif

" Take over 'number' & 'relativenumber'
if !exists('g:active_number')
  let g:active_number = &number
endif
if !exists('g:active_relativenumber')
  let g:active_relativenumber = &relativenumber
endif

" Excluded filetypes
if !exists('g:actnum_exclude')
  let g:actnum_exclude =
        \ [ 'unite', 'tagbar', 'startify', 'undotree', 'gundo', 'vimshell', 'w3m' ]
endif

" ==FUNCTIONS==

function! s:OnEnter() abort
  if exists('w:actnum_ignore') || !g:actnum_enabled
    return
  endif
  if index(g:actnum_exclude, &ft) > -1
    setlocal nonumber norelativenumber
  else
    let &number = g:active_number
    let &relativenumber = g:active_relativenumber
  endif
endfunction

function! s:OnLeave() abort
  if exists('w:actnum_ignore') || !g:actnum_enabled
        \ || index(g:actnum_exclude, &ft) >= 0
    return
  endif
  setlocal nonumber norelativenumber
endfunction

function! s:RefreshWindows() abort
  let currwin=winnr()
  windo call <SID>OnEnter()
  execute currwin . 'wincmd w'
endfunction

" Toggle/Enable/Disable entire plugin
" :ActiveNumbers <no-arguments> = toggle
" :ActiveNumbers {on|off} = enable|disable
function! s:PluginOnOff(type) abort
  if a:type == ''
    call <SID>PluginOnOff(g:actnum_enabled ? 'off' : 'on')
  else
    if a:type == 'off'
      let g:actnum_enabled = 0
      echo 'ActiveNumbers disabled'
    elseif a:type == 'on'
      let g:actnum_enabled = 1
      echo 'ActiveNumbers enabled'
      call <SID>RefreshWindows()
    endif
  endif
endfunction
command! -complete=customlist,<SID>PluginOnOffCompletion -nargs=? -bar
      \ ActiveNumbers call <SID>PluginOnOff(<q-args>)

" please let me know if there's a less verbose way to do this
" it only needs to complete 2 very short words T_T
function! s:PluginOnOffCompletion(ArgLead, L, P) abort
  if match(a:ArgLead, '^on') == 0
    return [ 'on' ]
  elseif match(a:ArgLead, '^of') == 0
    return [ 'off' ]
  else
    return [ 'off', 'on' ]
  endif
endfunction

" Ignore current window
" :ActiveNumbersIgnore  = window ignored by active-numbers
" :ActiveNumbersIgnore! = window acknowledged by active-numbers
function! s:WindowIgnore(bang) abort
  if !a:bang
    let w:actnum_ignore = 1
    echo 'Window ignored by ActiveNumbers'
  else
    if exists('w:actnum_ignore')
      unlet w:actnum_ignore
    endif
    call <SID>OnEnter()
    echo 'Window acknowledged by ActiveNumbers'
  endif
endfunction
command! -bang -bar ActiveNumbersIgnore call <SID>WindowIgnore(<bang>0)

" :SetActiveNumbers {option}
" works like regular set, also updates the plugin
function! s:ChangeNumbers(args) abort
  let opts = split(a:args)
  for opt in opts
    exec 'set '.opt
  endfor
  let g:active_number = &number
  let g:active_relativenumber = &relativenumber
  call <SID>RefreshWindows()
endfunction
command! -complete=option -nargs=* SetActiveNumbers call <SID>ChangeNumbers(<q-args>)

" ==AUTOCOMMANDS==

augroup active_numbers
  au!
  au User Startified call <SID>OnEnter()
  au WinEnter,BufEnter,VimEnter * call <SID>OnEnter()
  au WinLeave,BufLeave * call <SID>OnLeave()
augroup END
