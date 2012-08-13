if exists('g:loaded_ctrlp_launcher') && g:loaded_ctrlp_launcher
  finish
endif
let g:loaded_ctrlp_launcher = 1

if !exists('g:filename_ctrlp_launcher')
	let g:filename_ctrlp_launcher = '~/.ctrlp-launcher'
endif

let s:launcher_var = {
\  'init':   'ctrlp#launcher#init()',
\  'exit':   'ctrlp#launcher#exit()',
\  'accept': 'ctrlp#launcher#accept',
\  'lname':  'launcher',
\  'sname':  'launcher',
\  'type':   'path',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:launcher_var)
else
  let g:ctrlp_ext_vars = [s:launcher_var]
endif

function! ctrlp#launcher#init()
  let file = fnamemodify(expand(g:filename_ctrlp_launcher), ':p')
  let s:list = filereadable(file) ? filter(map(readfile(file), 'split(iconv(v:val, "utf-8", &encoding), "\\t\\+")'), 'len(v:val) > 0 && v:val[0]!~"^#"') : []
  let s:list += [["--edit-menu--", "split ".g:filename_ctrlp_launcher]]
  return map(copy(s:list), 'v:val[0]')
endfunc

function! ctrlp#launcher#accept(mode, str)
  let cmd = filter(copy(s:list), 'v:val[0] == a:str')[0][1]
  call ctrlp#exit()
  redraw!
  exe cmd
endfunction

function! ctrlp#launcher#exit()
  if exists('s:list')
    unlet! s:list
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#launcher#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
