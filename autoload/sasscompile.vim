"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

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

function! sasscompile#CompassConfig()
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
            let cmd = 'e '.dir.'config.rb'
        endif

        if cmd == ''
            let i = i + 1
            let dir = dir.'../'
            exec 'silent cd '.dir
        else
            break
        endif
    endwhile
    exec 'silent cd '.org
    exec cmd
endfunction

function! sasscompile#CompassCreate()
    let cmd = 'compass create --sass-dir "'.g:sass_compile_sassdir[0].'" --css-dir "'.g:sass_compile_cssdir[0].'" --output-style compressed'
    call system(cmd)

    " cache config
    let configfile = readfile('config.rb')
    let configfile = add(configfile, 'cache = false')
    call writefile(configfile, 'config.rb', 'b')

    " remove cache
    call system('rm -rf .sass-cache')

    " remove sass & css
    call system('rm -rf '.g:sass_compile_sassdir[0].'/ie.scss')
    call system('rm -rf '.g:sass_compile_sassdir[0].'/print.scss')
    call system('rm -rf '.g:sass_compile_sassdir[0].'/ie.sass')
    call system('rm -rf '.g:sass_compile_sassdir[0].'/print.sass')
    call system('rm -rf '.g:sass_compile_cssdir[0].'/ie.css')
    call system('rm -rf '.g:sass_compile_cssdir[0].'/print.css')

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
    let compassFlg = 0

    while i < g:sass_compile_cdloop
        unlet check
        let check = sasscompile#CompassCheck()
        if check == 1
            let cmd = 'compass compile'
            let compassFlg = 1
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
            let compileFlg = 1

            if compassFlg == 1
                let configfile = readfile('config.rb')

                if configfile[0] == '# auto-compile stopped.'
                    let compileFlg = 0
                endif
            endif

            if compileFlg == 1
                if g:sass_compile_beforecmd != ''
                    call system(g:sass_compile_beforecmd)
                endif
                if g:sass_compile_aftercmd != ''
                    let cmd = "sasscompileresult=$(".cmd."|sed s/'\[[0-9]*m'/''/g|tr '\\n' '__'|tr ' ' '_')\n ".g:sass_compile_aftercmd
                endif
                let cmd = '('.cmd.')&'
                call system(cmd)
            endif
            break
        endif
    endwhile
    exec 'silent cd '.org
endfunction

let &cpo = s:save_cpo
