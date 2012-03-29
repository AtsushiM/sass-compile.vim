"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:sass_compile_cdloop")
    let g:sass_compile_cdloop = 5
endif
if !exists("g:sass_compile_auto")
    let g:sass_compile_auto = 0
endif
if !exists("g:sass_compile_file")
    let g:sass_compile_file = ['scss', 'sass']
endif
if !exists("g:sass_compile_sassdir")
    let g:sass_compile_sassdir = ['scss', 'sass']
endif
if !exists("g:sass_compile_cssdir")
    let g:sass_compile_cssdir = ['css', 'stylesheet']
endif

command! BourbonInstall call sasscompile#BourbonInstall()
command! CompassCreate call sasscompile#CompassCreate()
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
