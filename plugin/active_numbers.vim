" ActiveNumbers - Only show line numbers in the active window
" Author:     Austin W. Smith
" Version:    2.3.0

" TODO:
" - update readme gif
" - make help docs

" ==VARIABLES== {{{

if exists('g:loaded_activenumbers')
  finish
endif
let g:loaded_activenumbers = 1

if !exists('g:activenumbers_enabled')
  let g:activenumbers_enabled = 1
endif

" Follow how 'number' & 'relativenumber' are set by user
if !exists('g:activenumbers_nu')
  let g:activenumbers_nu = &number
endif
if !exists('g:activenumbers_rnu')
  let g:activenumbers_rnu = &relativenumber
endif

" Excluded filetypes, if you don't want active numbers in a plugin/filetype
if !exists('g:activenumbers_exclude')
  let g:activenumbers_exclude =
        \ [ 'unite', 'tagbar', 'startify', 'undotree', 'gundo', 'vimshell', 'w3m' ]
endif

" Auto update the plugin when 'number' or 'relativenumber' are changed.
" Can be disabled if it's somehow incompatible with any plugins.
if !exists('g:activenumbers_autoupdate')
  let g:activenumbers_autoupdate = 1
endif

" }}}
" ==FUNCTIONS== {{{

" When a window or buffer are entered:
function! s:OnEnter() abort
  if exists('w:activenumbers_ignore') || !g:activenumbers_enabled
    return
  endif
  if index(g:activenumbers_exclude, &ft) > -1
    setlocal nonumber norelativenumber
  else
    let &number = g:activenumbers_nu
    let &relativenumber = g:activenumbers_rnu
  endif
endfunction

" When a window or buffer are left:
function! s:OnLeave() abort
  if exists('w:activenumbers_ignore') || !g:activenumbers_enabled
        \ || index(g:activenumbers_exclude, &ft) >= 0
    return
  endif
  setlocal nonumber norelativenumber
endfunction

" Update line numbers in all windows
function! s:RefreshWindows() abort
  let currwin=winnr()
  windo call <SID>OnEnter()
  execute currwin . 'wincmd w'
endfunction

" Update when global 'number' and 'relativenumber' are modified/changed
function! s:UpdateOptions(args) abort
  if !g:activenumbers_autoupdate | return | endif
  let opts = split(a:args)
  for opt in opts
    exec 'silent! set '.opt
  endfor
  let g:activenumbers_nu = &number
  let g:activenumbers_rnu = &relativenumber
endfunction

" Toggle/Enable/Disable entire plugin
" :ActiveNumbers <no-arguments> = toggle
" :ActiveNumbers {on|off} = enable|disable
function! s:PluginOnOff(type) abort
  if a:type == '' || a:type == 'toggle'
    call <SID>PluginOnOff(g:activenumbers_enabled ? 'off' : 'on')
  elseif a:type == 'off'
    let g:activenumbers_enabled = 0
    echo 'ActiveNumbers disabled'
  elseif a:type == 'on'
    let g:activenumbers_enabled = 1
    echo 'ActiveNumbers enabled'
    call <SID>RefreshWindows()
  endif
endfunction
command! -complete=customlist,<SID>PluginOnOffCompletion -nargs=? -bar
      \ ActiveNumbers call <SID>PluginOnOff(<q-args>)

function! s:PluginOnOffCompletion(ArgLead, L, P) abort
  if match(a:ArgLead, '^t') == 0
    return [ 'toggle']
  elseif match(a:ArgLead, '^of') == 0
    return [ 'off' ]
  elseif match(a:ArgLead, '^on') == 0
    return [ 'on' ]
  else
    return [ 'toggle', 'off', 'on' ]
  endif
endfunction

" Ignore current window
" :ActiveNumbersIgnore  = window ignored by active-numbers
" :ActiveNumbersIgnore! = window acknowledged by active-numbers
function! s:WindowIgnore(bang) abort
  if !a:bang
    let w:activenumbers_ignore = 1
    echo 'Window ignored by ActiveNumbers'
  else
    if exists('w:activenumbers_ignore')
      unlet w:activenumbers_ignore
    endif
    call <SID>OnEnter()
    echo 'Window acknowledged by ActiveNumbers'
  endif
endfunction
command! -bang -bar ActiveNumbersIgnore call <SID>WindowIgnore(<bang>0)

" :SetActiveNumbers {option}
" works like regular set, also updates the plugin
" only necessary if g:activenumbers_autoupdate is disabled
command! -complete=option -nargs=* SetActiveNumbers
      \ call <SID>UpdateOptions(<q-args>)

" }}}
" ==AUTOCOMMANDS== {{{

augroup activenumbers
  au!
  " it does require a reboot to re-enable auto-update if it was disabled at startup,
  " but that's enough of an edge-case that I don't really mind until someone complains
  if exists('##OptionSet') && g:activenumbers_autoupdate
    au OptionSet number,relativenumber
          \ if v:option_type == 'global' | call <SID>UpdateOptions('') | endif
  endif
  au WinEnter,BufEnter,VimEnter * call <SID>OnEnter()
  au WinLeave,BufLeave * call <SID>OnLeave()
augroup END

" }}}
" vim:set foldmethod=marker:
