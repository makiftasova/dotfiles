if exists("b:current_syntax")
  finish
endif

syntax match log_trace /\v\c.*(trace):.*/
syntax match log_debug /\v\c.*(dbg|debug):.*/
syntax match log_information /\v\c.*(inf|info|information):.*/
syntax match log_warning /\v\c.*(warn|warning):.*/
syntax match log_error  /\v\c.*(crit|critical|err|error):.*/
syntax match log_emerg  /\v\c.*(emerg|emergency):.*/

highlight default link log_trace NonText
highlight default link log_debug Normal
highlight default link log_information QuickFixLine
highlight default link log_warning ModeMsg
highlight default link log_error WarningMsg
highlight default link log_emerg ErrorMsg
