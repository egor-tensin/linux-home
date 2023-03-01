source $VIMRUNTIME/vimrc_example.vim

" -----------------------------------------------------------------------------
" File display
" -----------------------------------------------------------------------------

filetype plugin on
syntax enable

"set background=dark
set background=light
colorscheme solarized

" Don't wrap lines.
set nowrap

" -----------------------------------------------------------------------------
" Indentation
" -----------------------------------------------------------------------------

" 4 spaces per indentation level, no tabs.
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype indent on

" C++'s public/private/protected keywords don't increase indentation level.
set cinoptions+=g0

" -----------------------------------------------------------------------------
" User interface
" -----------------------------------------------------------------------------

" Highlight current line/column.
set cursorline
"set cursorcolumn
" Show current line/column number in the status bar.
set ruler
" Show line numbers on the left.
set number
" Add a vertical ruler.
set colorcolumn=80
" Show a few lines of context around the cursor.
set scrolloff=5

" -----------------------------------------------------------------------------
" Key bindings
" -----------------------------------------------------------------------------

" In insert mode, press F2 to enter 'paste mode'. Now you can paste text from
" elsewhere and _not_ mess up indentation. Nice and easy, right? Press F2 again
" to exit 'paste mode'.
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Insert newline without entering insert mode.
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" -----------------------------------------------------------------------------
" System settings
" -----------------------------------------------------------------------------

" Backup files are written to ~/.vimtmp/backup/. I'm not sure how the whole
" thing's gonna work out in case of concurrent writes to multiple files with
" the same name, since backup file names will collide due to a long-standing
" Vim issue.
"
" Vim treats `backupdir` option inconsistently: if its value ends with two
" slashes, Vim doesn't convert the absolute path of the file being backed up
" to its backup file name (replacing directory separators with % signs) as it
" does with swap and 'persisent undo' files, but rather simply appends ~ to
" the end of file's name. For some reason it still works this way when there're
" two slashes at the end, so I'm gonna stick with this, hoping that this
" problem gets fixed in the future.
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

" -----------------------------------------------------------------------------
" Search
" -----------------------------------------------------------------------------

set ignorecase
set smartcase
set hlsearch
set incsearch

" -----------------------------------------------------------------------------
" Directories
" -----------------------------------------------------------------------------

" Disable opening directories, netrw is too confusing.
" https://unix.stackexchange.com/q/297844
for f in argv()
  if isdirectory(f)
    echomsg "Cowardly refusing to edit directory: " . f
    quit
  endif
endfor

let loaded_netrwPlugin=1

" -----------------------------------------------------------------------------
" Clipboard
" -----------------------------------------------------------------------------

" Access X clipboard.
set clipboard=unnamedplus
