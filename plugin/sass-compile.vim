"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:sass_compile_cdloop")
    let g:sass_compile_cdloop = 5
endif
if !exists("g:sass_compile_auto")
    let g:sass_compile_auto = 0
endif
if !exists("g:sass_compile_sassdir")
    let g:sass_compile_sassdir = ['scss', 'sass']
endif
if !exists("g:sass_compile_cssdir")
    let g:sass_compile_cssdir = ['css', 'stylesheet']
endif

function! s:CompassCheck()
    if filereadable('config.rb')
        return 1
    endif
    return 0
endfunction
function! s:SassCheck()
    let sass = ''
    for e in g:sass_compile_sassdir
        if isdirectory(e)
            let sass = e
            break
        endif
    endfor

    let css = ''
    for e in g:sass_compile_cssdir
        if isdirectory(e)
            let css = e
            break
        endif
    endfor
    if sass != '' && css != ''
        return [sass, css]
    endif
    return []
endfunction

function! s:CompassCreate()
    let cmd = 'compass create --sass-dir "'.g:sass_compile_sassdir[0].'" --css-dir "'.g:sass_compile_cssdir[0].'"'
    call system(cmd)
    echo cmd
endfunction

function! s:SassCompile()
    let i = 0
    let cmd = ''
    let org = expand('%:p:h')
    let dir = org.'/'
    let check = 0
    while i < g:auto_make_cdloop
        unlet check
        let check = s:CompassCheck()
        if check == 1
            let cmd = 'compass compile&'
        else
            unlet check
            let check = s:SassCheck()
            if check != []
                let cmd = 'sass --update '.check[0].':'.check[1].'&'
            endif
        endif

        if cmd == ''
            let i = i + 1
            let dir = dir.'../'
            exec 'silent cd '.dir
        else
            call system(cmd)
            break
        endif
    endwhile
    exec 'silent cd '.org
endfunction 

command! CompassCreate call s:CompassCreate()
command! SassCompile call s:SassCompile()

" sass auto compile
if g:sass_compile_auto == 1
    for e in g:sass_compile_sassdir
        exec 'au BufWritePost *.'.e.' call <SID>SassCompile()'
    endfor
endif
