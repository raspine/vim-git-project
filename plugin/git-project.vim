" git-project.vim - Use git as project solution
" Author:       Jörgen Scott (jorgen.scott@gmail.com)
" Version:      0.1

if exists("g:loaded_vim_git_project")
    finish
endif
let g:loaded_vim_git_project = 1

function! GP_is_repo()
    return system('git rev-parse') == ''
endfunction

function! GP_get_root()
    if !GP_is_repo()
        return ''
    endif
    return system('git rev-parse --show-toplevel')
endfunction

function! GP_get_include_paths()
    if !GP_is_repo()
        return []
    endif
    return systemlist('git ls-tree HEAD --name-only -d')
endfunction

function! GP_get_vim_paths()
    if !GP_is_repo()
        return ''
    endif
    return join(GP_get_include_paths(), '/**,') . '/**,'
endfunction

function! GP_get_exclude_paths()
    if !GP_is_repo()
        return []
    endif
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

    let l:git_dirs = systemlist('git ls-tree HEAD --name-only -d')

    " get the elements not in git repo
    let l:nonGitdirs = []
    for l:dir in l:alldirs
        if index(l:git_dirs, l:dir) == -1
            let l:nonGitdirs = add(l:nonGitdirs, l:dir)
        endif
    endfor
    return l:nonGitdirs
endfunction

function! GP_get_ctags_exclude_args()
    if !GP_is_repo()
        return ''
    endif
    return '--exclude=' . join(GP_get_exclude_paths(), " --exclude=")
endfunction

