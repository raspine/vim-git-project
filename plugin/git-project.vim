" git-project.vim - Use git as project solution
" Author:       Jörgen Scott (jorgen.scott@gmail.com)
" Version:      0.1

" if exists("g:loaded_vim_git_project")
"     finish
" endif
" let g:loaded_vim_git_project = 1

function! GP_get_paths()
    let l:git_files = systemlist('git ls-tree HEAD --name-only -d')
    let l:path = ''
    for l:file in l:git_files
        let l:path .= l:file . '/**,'
    endfor
    return l:path
endfunction

function! GP_get_root()
    return system('git rev-parse --show-toplevel')
endfunction

function! GP_get_ctags_exclude_args()
    let l:currPath = getcwd()
    let l:projRoot =  GP_get_root()
    exec 'cd ' . l:projRoot
    let l:alldirs = []
    let l:files = globpath('.', '*', 0, 1)
    exec 'cd' . l:currPath

    for l:file in l:files
        if isdirectory(l:file)
            let l:dir = fnamemodify(l:file, ':t')
            let l:alldirs = add(l:alldirs, l:dir)
        endif
    endfor

    echo l:alldirs
    let l:git_files = systemlist('git ls-tree HEAD --name-only -d')
endfunction

