; extends

; Inject SQL into any Python string that looks like SQL.
; Matches triple-quoted strings too (they are still `string` with `string_content`).
(string
  (string_content) @injection.content
  (#set! injection.language "sql")
  (#set! injection.combined))
