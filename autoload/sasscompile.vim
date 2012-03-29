"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
"VERSION:  0.9
"LICENSE:  MIT

function! sasscompile#CompassCheck()
    if filereadable('config.rb')
        return 1
    endif
    return 0
endfunction
function! sasscompile#BourbonCheck(dir)
    if isdirectory(a:dir.'/bourbon')
        return 1
    endif
    return 0
endfunction
function! sasscompile#SassCheck()
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

function! sasscompile#CompassCreate()
    let cmd = 'compass create --sass-dir "'.g:sass_compile_sassdir[0].'" --css-dir "'.g:sass_compile_cssdir[0].'"'
    call system(cmd)
    echo cmd
endfunction

function! sasscompile#BourbonInstall()
    let cmd = 'bourbon install'
    call system(cmd)
    echo cmd
endfunction

function! sasscompile#SassCompile()
    let i = 0
    let cmd = ''
    let org = getcwd()
    let dir = expand('%:p:h').'/'
    let check = 0
    while i < g:auto_make_cdloop
        unlet check
        let check = sasscompile#CompassCheck()
        if check == 1
            let cmd = 'compass compile&'
        else
            unlet check
            let check = sasscompile#SassCheck()
            if check != []
                let bourbon = ''
                if sasscompile#BourbonCheck(check[0]) == 1
                    let bourbon =  ' -r ./'.check[0].'/bourbon/lib/bourbon.rb'
                endif

                let cmd = 'sass --update '.check[0].':'.check[1].bourbon.'&'
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
