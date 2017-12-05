" git-project.vim - Use git as project solution
" Author:       Jörgen Scott (jorgen.scott@gmail.com)
" Version:      0.1

if exists("g:loaded_vim_git_project")
    finish
endif
let g:loaded_vim_git_project = 1

function! GP_get_paths()
    let l:files = systemlist('git ls-tree HEAD --name-only -d')
    let l:path = ''
    for l:file in l:files
        let l:path .= l:file . '/**,'
    endfor
    return l:path
endfunction

function! GP_get_root()
    return system('git rev-parse --show-toplevel')
endfunction

