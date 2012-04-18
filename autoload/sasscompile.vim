"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:sass_compile_cdloop")
    let g:sass_compile_cdloop = 5
endif
if !exists("g:sass_compile_sassdir")
    let g:sass_compile_sassdir = ['scss', 'sass', 'css', 'stylesheet']
endif
if !exists("g:sass_compile_cssdir")
    let g:sass_compile_cssdir = ['css', 'stylesheet']
endif
if !exists("g:sass_compile_aftercmd")
    let g:sass_compile_aftercmd = ''
endif

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
    let css = ''
    for e in g:sass_compile_cssdir
        if isdirectory(e)
            let css = e
            break
        endif
    endfor
    return css
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
    let fdir = expand('%:p:h')
    let dir = fdir.'/'
    let check = 0
    while i < g:sass_compile_cdloop
        unlet check
        let check = sasscompile#CompassCheck()
        if check == 1
            let cmd = 'compass compile'
        else
            unlet check
            let check = sasscompile#SassCheck()
            if check != ''
                let bourbon = ''
                if sasscompile#BourbonCheck(check) == 1
                    let bourbon =  ' -r '.fdir.'/bourbon/lib/bourbon.rb'
                endif

                let cmd = 'sass --update '.fdir.':'.check.bourbon
            endif
        endif

        if cmd == ''
            let i = i + 1
            let dir = dir.'../'
            exec 'silent cd '.dir
        else
            if g:sass_compile_aftercmd != ''
                let cmd = cmd.g:sass_compile_aftercmd
            endif
            let cmd = cmd.'&'
            call system(cmd)
            break
        endif
    endwhile
    exec 'silent cd '.org
endfunction 
