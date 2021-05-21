let s:command = ""

function! quickpick#pickers#buffer#open(bang) abort
  call quickpick#open({
  \ "items": s:get_items(a:bang),
  \ "key": "view",
  \ "filetype": "quickpick_buffer",
  \ "on_accept": function("s:on_accept"),
  \})

  inoremap <buffer><silent> <Plug>(quickpick-buffer-set-open-command-tab) <ESC>:<C-u>call <SID>open_with_command("tab split")<CR>
  nnoremap <buffer><silent> <Plug>(quickpick-buffer-set-open-command-tab) :<C-u>call <SID>open_with_command("tab split")<CR>

  inoremap <buffer><silent> <Plug>(quickpick-buffer-set-open-command-split) <ESC>:<C-u>call <SID>open_with_command("split")<CR>
  nnoremap <buffer><silent> <Plug>(quickpick-buffer-set-open-command-split) :<C-u>call <SID>open_with_command("split")<CR>

  inoremap <buffer><silent> <Plug>(quickpick-buffer-set-open-command-vsplit) <ESC>:<C-u>call <SID>open_with_command("vsplit")<CR>
  nnoremap <buffer><silent> <Plug>(quickpick-buffer-set-open-command-vsplit) :<C-u>call <SID>open_with_command("vsplit")<CR>

  if !hasmapto("<Plug>(quickpick-buffer-set-open-command-tab)")
    imap <silent> <buffer> <C-t> <Plug>(quickpick-buffer-set-open-command-tab)
    nmap <silent> <buffer> <C-t> <Plug>(quickpick-buffer-set-open-command-tab)
  endif

  if !hasmapto("<Plug>(quickpick-buffer-set-open-command-split)")
    imap <silent> <buffer> <C-s> <Plug>(quickpick-buffer-set-open-command-split)
    nmap <silent> <buffer> <C-s> <Plug>(quickpick-buffer-set-open-command-split)
  endif

  if !hasmapto("<Plug>(quickpick-buffer-set-open-command-vsplit)")
    imap <silent> <buffer> <C-v> <Plug>(quickpick-buffer-set-open-command-vsplit)
    nmap <silent> <buffer> <C-v> <Plug>(quickpick-buffer-set-open-command-vsplit)
  endif
endfunction

function! s:get_items(bang) abort
  return map(filter(getbufinfo(), {
  \ idx, val -> empty(a:bang) ? val["listed"] == v:true : v:true
  \}), {v -> {
  \ "view": printf("% 6d", v:val["bufnr"])
  \   . " "
  \   . (v:val["changed"] == v:true ? "+" : (v:val["bufnr"] == bufnr() ? "%" : " "))
  \   . " "
  \   . printf("%-30s", (fnamemodify(v:val["name"], ":t") == "" ? "[No Name]" : fnamemodify(v:val["name"], ":t")))
  \   . " "
  \   . fnamemodify(v:val["name"], ":~:h"),
  \ "buffer": v:val,
  \}})
endfunction

function! s:on_accept(data, name) abort
  call quickpick#close()

  let l:cmd = "buffer " . a:data["items"][0]["buffer"]["bufnr"]
  if s:command != ""
    let l:cmd = s:command . " | " . l:cmd
    let s:command = ""
  endif

  execute l:cmd
endfunction

function! s:open_with_command(command) abort
  let s:command = a:command
  call feedkeys("\<CR>")
endfunction
