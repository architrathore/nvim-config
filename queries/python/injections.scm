(call
  function:
    (attribute
      attribute: (identifier) @sql (#eq? @sql  "sql")
    )
  arguments:
    (argument_list
      (string 
        (string_content) @injection.content (#set! injection.language "sql")
      )
    )
)
