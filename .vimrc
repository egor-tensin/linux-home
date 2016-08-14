source $VIMRUNTIME/vimrc_example.vim

color desert
set expandtab
set shiftwidth=4
set softtabstop=4
highlight ColorColumn ctermbg=darkgrey

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set exrc
set secure

set nobackup
set noswapfile
set noundofile
set nowritebackup
