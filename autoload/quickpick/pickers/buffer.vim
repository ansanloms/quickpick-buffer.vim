function! quickpick#pickers#buffer#open(bang) abort
  call quickpick#open({
  \ "items": s:get_items(a:bang),
  \ "key": "view",
  \ "filetype": "quickpick_buffer",
  \ "on_accept": function("s:on_accept"),
  \})
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
  execute "buffer " . a:data["items"][0]["buffer"]["bufnr"]
endfunction
