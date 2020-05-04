source $VIMRUNTIME/vimrc_example.vim

" Color scheme.
color desert

set nowrap " Don't wrap lines.

" 4 spaces per indentation level, no tabs.
set softtabstop=4
set shiftwidth=4
set expandtab

" C++'s public/private/protected keywords don't increase indentation level.
set cinoptions+=g0

set colorcolumn=80

" In insert mode, press F2 to enter 'paste mode'.
" Now you can paste text from elsewhere and _not_ mess up indentation.
" Nice and easy, right?
" Press F2 again to exit 'paste mode'.
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Backup files are written to ~/.vimtmp/backup/.
" I'm not sure how the whole thing's gonna work out in case of concurrent
" writes to multiple files with the same name, since backup file names will
" collide due to a long-standing Vim issue.
" Vim treats `backupdir` option inconsistently: if its value ends with two
" slashes, Vim doesn't convert the absolute path of the file being backed up
" to its backup file name (replacing directory separators with % signs) as it
" does with swap and 'persisent undo' files, but rather simply appends ~ to
" the end of file's name.
" For some reason it still works this way when there're two slashes at the
" end, so I'm gonna stick with this, hoping that this problem gets fixed in
" the future.
set backupdir=~/.vimtmp/backup//
set nobackup
set writebackup

" Swap files are written to ~/.vimrc/swap/.
set directory=~/.vimtmp/swap//
set swapfile

" 'Persistent undo' files are written to ~/.vimrc/undo/.
if has('persistent_undo')
    set undodir=~/.vimtmp/undo//
    set undofile
endif

" Enable current-directory .vimrc files.
set exrc
set secure

" Case-insensitive (more precisely, so-called smart) search.
set ignorecase
set smartcase

" White on a bright background, ridiculous!
hi IncSearch ctermfg=0
hi Search    ctermfg=0

hi MatchParen ctermfg=0

hi Error    ctermfg=0
hi ErrorMsg ctermfg=0

hi DiffAdd    ctermfg=0
hi DiffChange ctermfg=0
hi DiffDelete ctermfg=0
hi DiffText   ctermfg=0

hi SpellBad   ctermfg=0
hi SpellCap   ctermfg=0
hi SpellRare  ctermfg=0
hi SpellLocal ctermfg=0

" Highlight current line.
set cursorline
"set cursorcolumn

" Insert newline without entering insert mode.
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
