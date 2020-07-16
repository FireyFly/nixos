" Based on ggVGd's pastebox

fun! PasteToBox()
  let originalFileName =  fnamemodify(bufname("%"), ":t")
  let outFileNamePlain = substitute(
                         \ substitute(originalFileName, '^\.', '', 'g'),
                         \ '^$', '_tmp', 'g')
  let outFileName = outFileNamePlain . '.html'

  let outCommandPlain = substitute(g:pasteboxWriteCommand, '{}', outFileNamePlain, 'g')
  let outCommand      = substitute(g:pasteboxWriteCommand, '{}', outFileName, 'g')

  execute "w! !" . outCommandPlain

  TOhtml

  exec '%s:<title>\zs.*\ze</title>:'.originalFileName.':'
  exec '%s/javascript:toggleFold("\([^"]\+\)");/&return false/ge'
  exec "normal /style\<CR>jj3dd\<C-o>o<link rel=\"stylesheet\" href=\"vimstyle.css\" />\<Esc>"

  echo outFileName
  execute 'w! !' . outCommand
  bd!
endf

command! Up :call PasteToBox()
