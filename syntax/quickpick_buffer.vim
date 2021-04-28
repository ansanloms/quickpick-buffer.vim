if exists("b:current_syntax")
  finish
endif

syntax match QuickpickBufferDirectory /\v(^.{6})\s(.{1})\s(.{30})\s(.*$)/ oneline
syntax match QuickpickBufferFilename /\v(^.{6})\s(.{1})\s(.{30})/ contained containedin=QuickpickBufferDirectory oneline
syntax match QuickpickBufferStatus /\v(^.{6})\s(.{1})/ contained containedin=QuickpickBufferFilename oneline
syntax match QuickpickBufferBufnr /\v(^.{6})/ contained containedin=QuickpickBufferStatus oneline

highlight def link QuickpickBufferDirectory Directory
highlight def link QuickpickBufferFilename Title
highlight def link QuickpickBufferStatus Normal
highlight def link QuickpickBufferBufnr Number

let b:current_syntax = "quickpick.buffer"
