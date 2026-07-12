;extends

; The bundled query only highlights (backslash_escape) nodes with
; @string.escape -- it never conceals them, so escaped markdown from LSP
; docs (e.g. gopls doc-comment links like `\[\*PathError\]`) shows its
; backslashes literally. `backslash_escape` is one atomic 2-char node with
; no children, so #offset! shrinks the capture to just the backslash byte,
; leaving the escaped character itself visible and unconcealed.
((backslash_escape) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))
