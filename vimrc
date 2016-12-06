"#######################################################
"
" 1. Get vundle by this:
"    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"
" 2. Run:BundleInstall
"
" 3. vim-go need to download src from : http://gopm.io
"    then you need to modify the file: ./container/intsets/popcnt_amd64.s 
"
" 4. vim-godef needs godef binary, it can be found in github.com
"
"#######################################################
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'c.vim'
Bundle 'a.vim'
Bundle 'taglist.vim'
Bundle 'winmanager'
Bundle 'flazz/vim-colorschemes'
Bundle 'vim-misc'
Bundle 'xolox/vim-colorscheme-switcher'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'fatih/vim-go'
Bundle 'dgryski/vim-godef'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'godlygeek/tabular'
Bundle 'majutsushi/tagbar'
Bundle 'vim-cscope'

filetype plugin indent on

" configurations 
set ignorecase
set expandtab
set tabstop=4
set softtabstop=4
set autoindent
set smartindent
set shiftwidth=4
set incsearch
set hlsearch
set nu

syntax on

" color scheme
set t_Co=256
let g:molokai_original=1
let g:rehash256=1
"colorscheme inkpot
colorscheme molokai
"colorscheme monokai-chris

let g:C_FormatDate            = '%F'
let g:C_FormatTime            = '%T'
let g:C_FormatYear            = '%Y'

" key mapping
let mapleader=","
nmap <leader>x :wq<CR>
nmap <leader>z :q!<CR>
nmap <leader>w :NERDTreeToggle<CR>
nmap <F4> :qa!<CR>
nmap <C-h> :vertical res +1<CR>
nmap <C-l> :vertical res -1<CR>

au filetype c,cpp,java,sh nmap <leader>t :TlistToggle<CR>
"au filetype javascript colorscheme monokai-chris
"au filetype go colorscheme inkpot

au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" for tagbar(golang)
let g:tagbar_left = 1
let g:tagbar_width = 30
"let g:tagbar_compact = 1
let g:tagbar_type_go = { 
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" for golang environment
autocmd FileType go nmap <F5> :TagbarToggle<CR>
let g:godef_same_file_in_same_window=1
let g:godef_split=1
let g:go_fmt_command="goimports"
au filetype go nmap <leader>p :GoImports<CR>
au filetype go nmap <leader>l :GoLint<CR>
au filetype go nmap <leader>r :GoRun<CR>
au filetype go nmap <leader>re :GoReferrers<CR>
au filetype go nmap <leader>c :GoCallees<CR>
au filetype go nmap <leader>d :GoDoc<CR>
au filetype go nmap <leader>b :GoBuild<CR>
au filetype go nmap <leader>i :GoInfo<CR>
au filetype go nmap <leader>f :GoFiles<CR>
au filetype go nmap <leader>e :GoErrCheck<CR>
au filetype go nmap <leader>t :TagbarToggle<CR>

" download go packages
"     go get -d github.com/golang/tools
"     go install golang.org/x/tools/cmd/oracle
"     go install golang.org/x/tools/cmd/gorename
"     go install golang.org/x/tools/cmd/goimports

" this only works on mac osx system
" let Tlist_Ctags_Cmd='/usr/local/bin/ctags' 
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1


"#######################################################
