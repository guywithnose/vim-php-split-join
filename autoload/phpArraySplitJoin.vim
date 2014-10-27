function! s:getChar()
  return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

" Break a PHP array onto multiple lines
function! phpArraySplitJoin#splitArray()
  let oldSearch = @/

  execute "normal yi[`[i\<return>\<esc>"
  call search('\v\=\>\s+', 'e', line('.'))
  while col('.') !=# col('$') - 1
    if s:getChar() ==# ","
      execute "normal a\<return>\<esc>"
    elseif s:getChar() ==# "'"
      execute "normal yi'`]"
    elseif s:getChar() ==# '"'
      execute 'normal yi"`]'
    elseif s:getChar() ==# "(" || s:getChar() ==# "["
      execute "normal %"
    endif
    execute 'normal l'
  endwhile

  execute 'normal 0'
  if search('\v([^,])\](.)$', '', line('.')) " There isn't already a trailing comma
    silent s/\v([^,])\](.)$/\1,\r\]\2/e
  else
    silent s/\v,\](.)$/,\r\]\1/e
  endif
  silent normal =a]

  let @/ = oldSearch
endfunction

" Join a PHP array onto one line
function! phpArraySplitJoin#joinArray()
  let oldSearch = @/

  execute "normal va[\<esc>"
  '<,'>join
  s/\v\[ /[/g
  s/\v, \]/]/g

  let @/ = oldSearch
endfunction
