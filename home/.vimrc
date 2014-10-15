"General Settings
set cindent
set cinoptions=g0
set smartindent
set title
set mouse=a
set ttymouse=xterm2

"Language Settings
set encoding=utf8
set fileencoding=utf8
set hlg=ja

"Edit Settings
set tabstop=4
set shiftwidth=4
set expandtab     "replace tab to spaces
set showmatch     "auto complete )
set matchtime=1   "wait time for showmatch
set backspace=indent,eol,start
set virtualedit=block

"Display Settings
set number
set list
set listchars=eol:↲
set ruler
set wrap
set shellslash

"Search Settings
set hlsearch       "enable highligt
set incsearch      "enable incremental search
set smartcase      "enable smart case
set grepprg=grep\ -nH\ $*

"Plugin Settings
filetype on
filetype plugin on
filetype plugin indent on
filetype indent on
syntax on

"Color Scheme
" colorscheme mirodark
colorscheme lucius
set background=dark


"split like tmux
noremap <C-w>% :vsp<CR>
noremap <C-w>" :sp<CR>
noremap <C-w>p :tabp<CR>
noremap <C-w>n :tabn<CR>
noremap <C-w>c :tabnew<CR>

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
else
    set clipboard& clipboard+=unnamed
endif

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
                \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction
au BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

source <sfile>:h/.vim/neobundles.vim

"vimfiler Settings
nnoremap <C-n>t :VimFilerExplorer<CR>
" close vimfiler automatically when there are only vimfiler open
autocmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
let s:hooks = neobundle#get_hooks("vimfiler")
function! s:hooks.on_source(bundle)
    " vimfiler specific key mappings
    autocmd FileType vimfiler call s:vimfiler_settings()
    function! s:vimfiler_settings()
        "let g:vimfiler_as_default_explorer = 1
        let g:vimfiler_enable_auto_cd = 1
        "let g:vimfiler_ignore_pattern = "^\%(.git\|.DS_Store\)$"
        " ^^ to go up
        nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
        " use R to refresh
        nmap <buffer> R <Plug>(vimfiler_redraw_screen)
        " overwrite C-l
        nmap <buffer> <C-l> <C-w>l
    endfunction
endfunction

"Quickrun Settings
silent! nmap <unique> <C-r> <Plug>(quickrun)
let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
    let g:loaded_quicklaunch = 1
    let g:quickrun_config = {
                \ "*": {"runner": "remote/vimproc"},
                \ 'split': '{"rightbelow 10sp"}' ,
"                \ 'tex': {
"                \       'command': 'ptex2pdf',  
"                \       'exec': ['%c -l -ot "-synctex=1 -interaction=nonstopmode" %s', 'open %s:r.pdf']
"                \  },
                \ }
"    if executable('makelatex')
"        let g:quickrun_config.tex = {'command' : 'makelatex'}
"    elseif executable('platex')
"        let g:quickrun_config.tex = {'command' : 'platex'}
"    endif
endfunction

"autocmd FileType tex noremap <buffer> <F5> :w<CR> :!makelatex -shell-escape "%" && evince %:p:r.pdf<CR>
"autocmd FileType tex noremap <buffer> <F5> :w<CR> :!makelatex <C-R>%<CR>




""Gist.vim Settings
"let s:hooks = neobundle#get_hooks("gist-vim")
"function! s:hooks.on_source(bundle)
"    let g:gist_show_privates = 1
"    let g:gist_privates = 1
"endfunction

"neocomplete Settings
let s:hooks = neobundle#get_hooks("neocomplete.vim")
function! s:hooks.on_source(bundle)
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_at_startup = 1
endfunction

autocmd BufRead /tmp/crontab.* :set nobackup nowritebackup
set expandtab

"Load local Settings
"source $HOME/.vimrc_local

set cursorline
set nobackup

" スペース+'.'で.vimrc_localを開く
nnoremap <Space>. :<C-u>tabedit ~/.vimrc_local<CR>

" スペース+','で.vimrcを開く
nnoremap <Space>, :<C-u>tabedit ~/.vimrc<CR>

" 検索時に大文字小文字に関わらず検索する
set ignorecase
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd

"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
 "   (例: DOS/Windows/MacOS)
 "
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
    set tags=./tags,tags
endif

set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー


" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()


"改行時にコメント自動で挿入するのを解除
autocmd FileType * setlocal formatoptions-=ro

"zencoding
let g:user_zen_expandabbr_key = '<c-r>'


"*****************************************************************************"
"NeoBundle.vimのプラグイン
filetype off
set nocompatible " be iMproved
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundle "mattn/emmet-vim"
NeoBundle 'thinca/vim-quickrun'
NeoBundle "Shougo/neocomplete.vim"
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'git://git.code.sf.net/p/vim-latex/vim-latex'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'Shougo/neosnippet.git'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-surround'
"NeoBundle 'kana/vim-fakeclip'
"NeoBundle 'Shougo/neobundle.vim.git'

" jedi-vim
"NeoBundle 'davidhalter/jedi-vim'
let g:jedi#popup_on_dot = 0
NeoBundleLazy "davidhalter/jedi-vim", {
            \ "autoload": {
            \   "filetypes": ["python", "python3", "djangohtml"],
            \ },
            \ "build": {
            \   "mac": "pip install jedi",
            \   "unix": "pip install jedi",
            \ }}

filetype plugin indent on
"*****************************************************************************"

"python用設定
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
set nobackup
set guifont=Ricty:h14
au BufEnter *.py setlocal indentkeys+=0#
autocmd FileType python :inoremap # a<C-H># 

" NERDTreeを開く
"nmap <C-n> :NERDTreeToggle<CR>


"neocomplcache
let g:neocomplcache_enable_at_startup = 1

" クリップボードとvimを共有
set clipboard=unnamed,autoselect
set clipboard+=unnamed
set clipboard+=autoselect

set t_Co=256

"lightline.vim設定
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode'
        \ }
        \ }

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
                \  &ft == 'unite' ? unite#get_status_string() :
                \  &ft == 'vimshell' ? vimshell#get_status_string() :
                \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
    try
        if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
            return fugitive#head()
        endif
    catch
    endtry
    return ''
endfunction

function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" Esc Esc でハイライトOFF
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>

nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?                
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#

augroup auto_comment_off
        autocmd!
            autocmd BufEnter * setlocal formatoptions-=ro
augroup END


""
"" Vim-LaTeX
""
filetype plugin on
filetype indent on
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 1
let g:Imap_DeleteEmptyPlaceHolders = 1
let g:Imap_StickyPlaceHolders = 0
let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_FormatDependency_pdf = 'pdf'
let g:Tex_FormatDependency_pdf = 'dvi,pdf'
"let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
let g:Tex_FormatDependency_ps = 'dvi,ps'
let g:Tex_CompileRule_pdf = '/usr/texbin/ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/pdflatex -synctex=1
"-interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/lualatex -synctex=1
"-interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/luajitlatex -synctex=1
"-interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/xelatex -synctex=1
"-interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/dvipdfmx $*.dvi'
"let g:Tex_CompileRule_pdf = '/usr/local/bin/ps2pdf $*.ps'
let g:Tex_CompileRule_ps = '/usr/texbin/dvips -Ppdf -o $*.ps $*.dvi'
let g:Tex_CompileRule_dvi = '/usr/texbin/uplatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
let g:Tex_BibtexFlavor = '/usr/texbin/upbibtex'
"let g:Tex_BibtexFlavor = '/usr/texbin/bibtex'
"let g:Tex_BibtexFlavor = '/usr/texbin/bibtexu'
let g:Tex_MakeIndexFlavor = '/usr/texbin/mendex $*.idx'
"let g:Tex_MakeIndexFlavor = '/usr/texbin/makeindex $*.idx'
"let g:Tex_MakeIndexFlavor = '/usr/texbin/texindy $*.idx'
let g:Tex_UseEditorSettingInDVIViewer = 1
let g:Tex_ViewRule_pdf = '/usr/bin/open'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a Skim.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXShop.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXworks.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a Firefox.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a "Adobe Reader.app"'


" powerlineのフォント設定
let g:Powerline_symbols = 'fancy'

" emmet-vim
"let g:user_emmet_leader_key='<c-t>'

" 文字コード
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8

" Unite
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" バッファーと履歴
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>


" Neosnippet" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: "\<TAB>"

"" For snippet_complete marker.
"if has('conceal')
"    set conceallevel=2 concealcursor=i
"endif

" vim-latexマクロ展開
" let b:Imap_FreezeImap=1
let b:Imap_FreezeImap=0

"Conceal機能を無効化
let g:tex_conceal=''

" beamerをコンパイル
autocmd FileType tex noremap <buffer> <F9> :w<CR> :!beamer <C-R>%<CR>

" completefuncを上書き
let g:neocomplcache_force_overwrite_completefunc = 1


" if_luaが有効ならneocompleteを使う
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

"" neocomplete
"if neobundle#is_installed('neocomplete')
"    " neocomplete用設定
"    let g:neocomplete#enable_at_startup = 1
"    let g:neocomplete#enable_ignore_case = 1
"    let g:neocomplete#enable_smart_case = 1
"    if !exists('g:neocomplete#keyword_patterns')
"        let g:neocomplete#keyword_patterns = {}
"    endif
"    let g:neocomplete#keyword_patterns._ = '\h\w*'
"elseif neobundle#is_installed('neocomplcache')
"    " neocomplcache用設定
"    let g:neocomplcache_enable_at_startup = 1
"    let g:neocomplcache_enable_ignore_case = 1
"    let g:neocomplcache_enable_smart_case = 1
"    if !exists('g:neocomplcache_keyword_patterns')
"        let g:neocomplcache_keyword_patterns = {}
"    endif
"    let g:neocomplcache_keyword_patterns._ = '\h\w*'
"    let g:neocomplcache_enable_camel_case_completion = 1
"    let g:neocomplcache_enable_underbar_completion = 1
"endif


" note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
