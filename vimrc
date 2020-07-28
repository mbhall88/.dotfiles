syntax enable

""""""""""""""""""""""""""""""
""" VUNDLE SET UP
set nocompatible " required for vundle
filetype off " requird for vundle

"  set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

Plugin 'VundleVim/Vundle.vim'
Plugin 'joshdick/onedark.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'Yggdroot/indentline'
Plugin 'itspriddle/vim-shellcheck'
Plugin 'cespare/vim-toml'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'arcticicestudio/nord-vim'
Plugin 'rust-lang/rust.vim'
Plugin 'tpope/vim-unimpaired'

" OSX stupid backspace fix
" set backspace=indent,eol,start

call vundle#end() " required
filetype plugin indent on " required

"""""""""""""""""""""""""""""""""""""
" Configuration Section
"""""""""""""""""""""""""""""""""""""
" set background=dark
" "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
" if (empty($TMUX))
"   if (has("nvim"))
"     "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"     let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"   endif
"   "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"   "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"   " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"   if (has("termguicolors"))
"     set termguicolors
"   endif
" endif

syntax on
colorscheme nord

" Show line numbers
set number
set ruler

" Set Proper Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" enable highlighting for the current line
set cursorline

""" NERD commentor settings
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code
" indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" vertical line for code width
set cc=88

" open new line without going into insert mode
nmap <Enter> o<Esc>

" snakemake syntax highlighting
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

:set backspace=indent,eol,start

" Highlight search results
set hlsearch

" Set incremental search
set incsearch

" Sets how Vim formats text - run `:h fo-table` to see meanings
autocmd FileType * setlocal formatoptions=t formatoptions=q formatoptions=n
"
" Explicitly disable Vim from automatic comment insertion ALWAYS
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set the spelling language
set spelllang=en_au,en_gb

" ==========
" Markdown plugin options - https://github.com/plasticboy/vim-markdown
" ==========
" Highlight YAML front matter as used by Jekyll or Hugo.
let g:vim_markdown_frontmatter = 1
" Highlight TOML front matter as used by Hugo.
let g:vim_markdown_toml_frontmatter = 1
" Highlight JSON front matter as used by Hugo.
let g:vim_markdown_json_frontmatter = 1
" Strikethrough uses two tildes.
let g:vim_markdown_strikethrough = 1
" Allow for the TOC window to auto-fit when it's possible for it to shrink. It never increases its default size (half screen), it only shrinks.
let g:vim_markdown_toc_autofit = 1

