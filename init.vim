" General {
set nu
set nohls
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
" Keys }

" Format {
set tabstop=4
set smarttab            " bs时更快
set autoindent
set shiftwidth=4        " nnd, 需要手动跟tabstop同步
set expandtab
filetype plugin indent on
autocmd FileType elixir setlocal shiftwidth=2 softtabstop=2 expandtab
" Format }

" Color {
hi Normal ctermfg=252 ctermbg=none
" Color }

" Plug {
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhartington/oceanic-next'
Plug 'joshdick/onedark.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'elixir-editors/vim-elixir'
Plug 'gcmt/wildfire.vim'
Plug 'mg979/vim-visual-multi'
Plug 'sainnhe/everforest'
Plug 'rhysd/vim-color-spring-night'
Plug 'hachy/eva01.vim' " Evangelion!
call plug#end()

nmap <f3> :NERDTreeToggle<CR>
nmap '' :PlugInstall<CR>

if has('termguicolors')
    " important!
    set termguicolors
endif

let g:everforest_transparent_background=2
colorscheme everforest
set background=dark
" Plug }

" GUI {
" set lines=30 columns=140
set guioptions-=T       " toolbar
set guioptions-=m       " menubar
set guioptions-=L
set guioptions-=r
set guioptions-=b
set guioptions-=e
set guifont=JetBrainsMono\ Nerd\ Font:h15  " in linux

if exists("g:neovide")
    let g:everforest_transparent_background=0
    colorscheme everforest
    let g:neovide_cursor_vfx_mode = "railgun"
    let g:neovide_transparency = 0.9
endif
" GUI }
