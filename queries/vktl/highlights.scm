(comment) @comment
;(builtin) @function.builtin
(word) @type
(_ namespace: (word) @namespace)
(plain) @character
(field name: (word) @field)
(field_type
  mask_ref: (word) @conditional
  bit_no: (num) @number)
(type_param
  type: (type_ref "Type" @function.builtin))
(type_param
  type: (type_ref "#" @function.builtin))
(type_param
  name: (word) @parameter)
;(new_type
;  param: (word) @parameter)
(type_ref "#" @function.builtin)
(rpc_type) @label
(types_anchor) @label
(functions_anchor) @label
;(name) @type
;(constructor_name) @constructor
(tag) @tag
;(types_anchor) @keyword
