"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
"VERSION:  0.9
"LICENSE:  MIT

if !executable('sass')
    echohl ErrorMsg
    echo 'requires sass.'
    echohl None
    finish
endif

if exists("g:loaded_sass_compile")
    finish
endif

let g:loaded_sass_compile = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:sass_compile_file")
    let g:sass_compile_file = ['scss', 'sass']
endif
if !exists("g:sass_compile_auto")
    let g:sass_compile_auto = 0
endif

command! CompassCreate call sasscompile#CompassCreate()
command! CompassConfig call sasscompile#CompassConfig()
command! SassCompile call sasscompile#SassCompile()

" sass auto compile
function! s:SetAutoCmd()
    if g:sass_compile_auto == 1
        for e in g:sass_compile_file
            exec 'au BufWritePost *.'.e.' call sasscompile#SassCompile()'
        endfor
    endif
endfunction
au VimEnter * call s:SetAutoCmd()

let &cpo = s:save_cpo
