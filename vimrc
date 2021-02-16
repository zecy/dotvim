"Vim Plugin Manger{{{1
"let g:pathogen_disabled = ['airline']
call pathogen#infect()
"source! $HOME/.vim/vimrc
"}}}
"基本设置{{{1
set lines=25 columns=80
set magic
set ai
set ts=4 sw=4 sts=4 et
set expandtab
set dy=lastline "显示最多行，不用@@
set nobackup
set history=1000
set showmatch
"set lazyredraw "执行宏的时候不要更新显示
set autoread
set spr "Splite the new windows at right
set nocompatible
set wildmenu
set showcmd
"set cpo+=> "附加到寄存器时，在附加文本之前加上换行符。

"color molokai
"let g:molokai_original=0
"color iceberg
"color pencil
"color xoria256
colorscheme gruvbox-material

filetype indent on

"真的很smart, 搜索时全小写相当于不区分大小写，只要有一个大写字母出现，则区分大小写
"simple idea, great achievement!
set ignorecase smartcase
set hlsearch

"保存折叠等视图
"au BufWinLeave * silent mkview
"au BufWinEnter * silent loadview

sy on
se smc=100 "set max highlight columns = 100
set autochdir
"set noimdisable

set formatoptions=B

set shortmess=atI "No Welcome Screen
set vb t_vb=

"autocmd InsertEnter * set noimdisable
"autocmd InsertLeave * set imdisable

"界面设置{{{2
set guioptions=e "菜单、左右滚动条、新的标签栏
set ru "标尺信息
set nu "标尺信息
"set statusline=%F%m%r%h%w\ [%l/%L,%v]\ [%p%%] "状态栏内容
set laststatus=2 "状态栏出现在倒数第二行。
set cursorline "高翔当前行,设置在zzz.vim

"}}}
"设置字体{{{2
set gfw=Inziu_IosevkaCC_Slab_SC:h11.5
set guifont=Cascadia_Mono:h10 " Win 下用 _ 代表空格
"set guifont=Source\ Code\ Pro\ for\ Powerline:h13 " OSX 下使用反斜杠处理空格
set backspace=indent,eol,start
"解决有时只显示一半双字节字符的问题
set ambiwidth=double
"}}}

"键位设置{{{2
nnoremap <esc> :noh<return><esc>
nmap <C-h> ^
nmap <C-l> $
nmap <C-TAB> gt

"MS Like Notepad
vmap <C-C> "+y
imap <C-V> <esc>"+gpa
"imap <C-A> <esc>ggVG

" Use CTRL-S for saving, also in Insert mode
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Emacs
inoremap <C-b> <left>
inoremap <C-f> <right>
inoremap <C-n> <esc>gja
inoremap <C-p> <esc>gka
inoremap <C-e> <esc>A
inoremap <C-a> <esc>I


"Convinent >
nnoremap < <<
nnoremap > >>
nnoremap V 0v$h

"Shift > enhance
vnoremap < <gv
vnoremap > >gv

"CMD Line
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>

"Symblo Auto Complete

"inoremap ( ()<left>
"inoremap < <><left>
"inoremap " ""<left>
"inoremap [ []<left>
"inoremap { {}<left>

"paragraph jump enhance

"vmap { {j
"vmap } }k

"CSS File Auto Jump
autocmd! FileType css inoremap <buffer> { {}<left><CR><esc>O

"Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

"}}}
"解决乱码问题{{{2
set fileformat=unix
set fileformats=unix,dos
set encoding=utf-8 
set fileencodings=utf-8,utf-16le,utf-16,gbk,cp936,gb2312,big5,euc-jp,latin-1   
"if has("win32")  
    "set fileencoding=chinese   
"else    
    "set fileencoding=utf-8 
"endif   
source $VIMRUNTIME/delmenu.vim   
source $VIMRUNTIME/menu.vim  
language messages zh_CN.utf-8
"}}}
"代码自动补全{{{2

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"set complete-=i

"}}}
"}}}
"自定义函数{{{1

"选中内容进行全局替换{{{2
vmap qq y:%s`<C-R>"``g<left><left>
"}}}

"智能行首{{{1
"如果段落有缩进，先去到段落首位
"再按一次去到行首
function! ToggleHomeZero()
    let pos = getpos('.')
    execute "normal! ^"
    if pos == getpos('.')
        execute "normal! 0"
    endif
endfunction
nnoremap 0 :call ToggleHomeZero()<CR>
"}}}1

"==================插件设置==========================

"插件设置{{{1

:filetype plugin on
:filetype plugin indent on

"ACP{{{2
  "let g:acp_mappingDriven = 0
"}}}

"Neocomplete {{{2

	"let g:acp_enableAtStartup = 0
	"let g:neocomplete#enable_at_startup = 1
	"let g:neocomplete#enable_smart_case = 1
    "

"}}}

"Airline {{{2

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

"}}}

"CtrlP {{{2
    map <c-p> :CtrlPMRU<CR>
"}}}

"Vim Outilner{{{2
au! BufRead,BufNewFile *.votl set filetype=votl
au! filetype votl map <buffer> <C-a> ,,cx
au filetype votl normal zM
"}}}

"NERDTree{{{2
map <F10> :NERDTree<CR>
"}}}

"Indent Lines {{{2
let g:indentLine_char = '|'
"}}}

"solarized{{{2

"color solarized
"se background=light
"let g:solarized_visibility= "high"

"}}}2


"Markdown{{{2

let g:vim_markdown_no_default_key_mappings=1
let g:vim_markdown_math=1
let g:vim_markdown_frontmatter=0

autocmd! filetype md map <F11> :Voom markdown<CR>
autocmd! filetype mkd map <F11> :Voom markdown<CR>

"autocmd! filetype md inoremap <buffer> <C-I> ![](./)<left>
"autocmd! filetype mkd inoremap <buffer> <C-I> ![](./)<left>

"}}}

"Voom{{{2
map <F11> :Voom<CR>
let g:voom_python_versions = [3,2]
"}}}

"Emmet 扩展设施{{{2
"
let g:user_emmet_leader_key = '<c-e>'

let g:user_emmet_settings = {
            \  'html' : {
            \    'indentation' : '    '
            \  },
            \}

let g:user_emmet_settings = {
            \  'indentation' : '  ',
            \  'php' : {
            \    'aliases' : {
            \      'req' : 'require '
            \    },
            \    'snippets' : {
            \      'php' : "<?php |;?>",
            \    }
            \  },
            \
            \  'bbcode' : {
            \    'aliases' : {
            \      'req' : 'require ',
            \      'co' : 'color ',
            \    },
            \    'snippets' : {
            \      'b' : "[b]|[/b]",
            \      'img' : "[img]|[/img]",
            \      'url' : "[url=|][u][/u][/url]",
            \      'color' : "[color=|][/color]",
            \      'q' : "[quote]|[/quote]",
            \      'indent' : "[indent]|[/indent]",
            \      'size' : "[size=|][/size]",
            \      'list' : "[list]|\n[/list]",
            \    }
            \  },
            \}
"}}}

"Repeat{{{2
"silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
"}}}

"EasyMotion{{{2
"let g:EasyMotion_leader_key = ';'
"}}}

"PowerLine{{{2
    "let g:Powerline_stl_path_style = 'short'

    "module" : "powerline.segments.common",
    "name": "weather",
    "exclude_modes": ["nc"],
    "draw_soft_divider": true,
    "priority": 10
"}}}

"Yankring{{{2
"nnoremap <silent> <c-y> :YRShow<CR>
"}1}

"Colorizer{{{2
    let g:colorizer_auto_color = 0
    let g:colorizer_auto_filetype='css'
"}1}

"Javascript Libraries Syntax{{{2

autocmd BufReadPre *.js let b:javascript_lib_use_jquery     = 1
autocmd BufReadPre *.js let b:javascript_lib_use_angularjs  = 1

"}}}

"FencView {{{2
    let g:fencview_autodetect = 0
"}}}
"
"}}}
