" vim-git-project.vim - Use git as project solution
" Author:       Jörgen Scott (jorgen.scott@gmail.com)
" Version:      0.1

if exists("g:loaded_vim_git_project")
    finish
endif
let g:loaded_vim_git_project = 1

function! GP_is_repo()
    return system('git rev-parse') == ''
endfunction

function! GP_get_root_path()
    if !GP_is_repo()
        return ''
    endif
    return substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
endfunction

function! GP_get_root_name()
    if !GP_is_repo()
        return ''
    endif
    return fnamemodify(GP_get_root_path(), ':t')
endfunction

function! GP_get_include_dirs()
    if !GP_is_repo()
        return []
    endif
    return systemlist('git ls-tree HEAD --name-only -d')
endfunction

function! GP_get_vim_dirs()
    if !GP_is_repo()
        return ''
    endif
    return join(GP_get_include_dirs(), '/**,') . '/**,'
endfunction

function! GP_get_exclude_dirs()
    if !GP_is_repo()
        return []
    endif

    let l:alldirs = []
    let l:files = globpath(GP_get_root_path() . '/', '*', 0, 1)

    for l:file in l:files
        if isdirectory(l:file)
            let l:dir = fnamemodify(l:file, ':t')
            let l:alldirs = add(l:alldirs, l:dir)
        endif
    endfor

    let l:git_dirs = systemlist('git ls-tree HEAD --name-only -d')

    " return the directories not in git repo
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
    return '--exclude=' . join(GP_get_exclude_dirs(), " --exclude=")
endfunction

function! GP_get_files(matchStr)
    if !GP_is_repo()
        return []
    endif
    let l:allFiles = systemlist('git ls-files')
    let l:matchedFiles = []
    for l:file in l:allFiles
      if l:file =~ a:matchStr
          let l:matchedFiles = add(l:matchedFiles, l:file)
      endif
    endfor
    return l:matchedFiles
endfunction

" vim:set ft=vim sw=4 sts=2 et:
