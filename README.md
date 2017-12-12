# vim-git-project
=========================
### Use Git to init Vim ###

vim-git-project provides functions that helps with initialization of
vim using information provided by the git repo.

## Usage
Given the following project tree (ignore that its a c++ example,
vim-git-project is totally language-agnostic):
```
my-project/
├── build/
│   ├── ...
├── include/
│   ├── my-project.hpp
├── src/
│   ├── my-project.cpp
├── imports/
│   ├── ...

```

**GP_is_repo()** returns 1 if cwd is part of a git repo or else 0.
```
:echo GP_is_repo()
1
```

**GP_get_root_path()** returns the absolute path to the project:
```
:echo GP_get_root_path()
/home/me/my-project
```

**GP_get_root_name()** returns the root name as a string:
```
:echo GP_get_root_name()
my-project
```

**GP_get_include_dirs()** returns a list of subdirs, relative root, that is
part of the git repo:
```
:echo GP_get_include_dirs()
['include', 'src'] 
```

**GP_get_vim_dirs()** returns a string version of GP_get_include_dirs() that
can be added to vim's path variable:
```
:echo GP_get_vim_dirs()
src/**,include/**
```

**GP_get_exclude_dirs()** returns a list of subdirs, relative root, that is not
part of the git repo:
```
:echo GP_get_exclude_dirs()
['build', 'imports'] 
```

**GP_get_ctags_exclude_args()** returns a string version of
GP_get_exclude_dirs() that can be added to a !ctags command:
```
:echo GP_get_ctags_exclude_args()
--exclude=build --exclude=imports
```

**GP_get_files()** returns a list of files that belongs to the git repo. If
a non-empty argument is provided, only files containing the argument will be
returned:
```
:echo GP_get_files('my-project')
['/home/me/my-project/include/my-project.hpp', '/home/me/my-project/include/my-project.cpp'] 
```

## Example
I have this function in my .vimrc to quickly init vim for a new project:

```
function! InitWorkspace()"{{{
    if !GP_is_repo()
        return
    endif

    " Set vim's 'path' variable. Only directories part of git repo is added.
    " Vim's 'path' will be searched when using the |gf|, [f, ]f, ^Wf, |:find|,
    " |:sfind|, |:tabfind| and other commands.
    let &path='.,' . GP_get_vim_dirs()

    " Create ctags index, exclude directories that are not part of git repo.
    exec 'silent! !ctags -R -f .tags ' . GP_get_ctags_exclude_args()

    " Turn off obsession before delete/opening buffers and avoid messing up
    " current session when change dir to another project.
    if ObsessionStatus() == '[$]'
        exec "Obsession"
    endif

    " Delete all buffers provides a fresh start.
    exec "bufdo bd"

    " Open files containing root name as a default start. This is just a naming
    " convention I use for the main app files in any given project.
    " A ':so Session.vim' loads the last workspace if the main app files is not
    " what I want.
    let appFiles = GP_get_files(GP_get_root_name())

    " Prefer open *test* file first.
    for appFile in l:appFiles
        " open the files that contains projName
        if appFile =~ 'test'
            exec 'e ' . appFile
            call fugitive#detect(getcwd())
            filetype detect
        endif
    endfor
    " Open other files in split.
    for appFile in l:appFiles
        if !(appFile =~ 'test')
            exec 'sp ' . appFile
            call fugitive#detect(getcwd())
            filetype detect
        endif
    endfor

    " Move cursor to bottom file, i.e. the *test* file.
    exec 'silent! 3 wincmd j'
endfunction"}}}
```
