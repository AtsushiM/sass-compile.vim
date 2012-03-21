"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:auto_make_file")
    let g:auto_make_file = []
endif
if !exists("g:auto_make_cdloop")
    let g:auto_make_cdloop = 5
endif
if !exists("g:auto_make_makefile")
    let g:auto_make_makefile = 'Makefile'
endif

function! s:FileCheck()
    let i = 0
    let org = expand('%:p:h')
    let dir = org.'/'
    while i < g:auto_make_cdloop
        if !filereadable(dir.g:auto_make_makefile)
            let i = i + 1
            let dir = dir.'../'
        else
            exec 'silent cd '.dir
            let dir = getcwd()
            exec 'silent cd '.org
            break
        endif
    endwhile

    if i == g:auto_make_cdloop
        return ''
    else
        return dir
    endif
endfunction
function! s:Make()
    let dir = getcwd()
    let check = s:FileCheck()
    if check != ''
        exec 'silent cd '.check
        let cmd = 'make&'
        silent call system(cmd)
        exec 'silent cd '.dir
    endif
endfunction

command! Make call s:FPMake()

" auto make
if g:auto_make_file != []
    for e in g:auto_make_file
        exec 'au BufWritePost *.'.e.' call <SID>Make()'
    endfor
endif
