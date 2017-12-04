" git-project.vim - Use git as project solution
" Author:       Jörgen Scott (jorgen.scott@gmail.com)
" Version:      0.1

if exists("g:loaded_vim_git_project")
    finish
endif
let g:loaded_vim_git_project = 1

function! s:gp_get_path()
    let l:files = systemlist('git ls-tree HEAD --name-only -d')
    let l:path = ''
    for l:file in l:files
        let l:path .= l:file . '/**,'
    endfor
    return l:path
endfunction

