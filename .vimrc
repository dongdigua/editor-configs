                        " comments start at column 25 :)
" General {
set nu
syntax on
set encoding=utf-8
set noswapfile
set clipboard+=unnamed  " 共享系统剪切板
set mouse=a
filetype plugin on      " 识别插件的文件类型
set cursorline          " 高亮当前行
set list                " 显示换行符
" General }

" Keys {
nmap <f3> :NERDTreeToggle<CR>
nmap '' :PlugInstall<CR>
" Keys }

" Format {
set tabstop=2           " 主要为了elixir
set smarttab            " bs时更快
set autoindent
set shiftwidth=2        " nnd, 需要手动跟tabstop同步
" Format }

" Plug {
call plug#begin('/home/digua/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhartington/oceanic-next'
Plug 'joshdick/onedark.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'elixir-editors/vim-elixir'
call plug#end()
let g:airline_theme='oceanicnext'
colorscheme onedark
" Plug }

" GUI {
" set lines=30 columns=140
set guioptions-=T       " toolbar
set guioptions-=m       " menubar
set guioptions-=L
set guioptions-=r
set guioptions-=b
set guioptions-=e
set guifont=Source\ Code\ Pro\ 14   " in linux
hi Normal ctermfg=252 ctermbg=none
" GUI }
