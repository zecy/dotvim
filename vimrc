"Vim Plugin Manger{{{1
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
set lazyredraw "执行宏的时候不要更新显示
set autoread
set spr "Splite the new windows at right
set nocompatible
set wildmenu

"color molokai
"let g:molokai_original=0
"color iceberg
"color pencil
"color xoria256
color solarized
se background=light

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
"set gfw=方正准圆_GBK:h10
set guifont=Monaco:h13
"set guifont=Anonymous_Pro:h11
"set guifont=Anonymice_Powerline:h11:cANSI
"set gfw=Monaco:h10
"set guifont=Source_Code_Pro:h10.5
"set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
"set guifont=Ubuntu_Mono:h12:cANSI
"set guifont=Inconsolata:h10:cANSI
"set guifont=PragmataPro:h10:cANSI
"set gfw=Yahei_Mono:h10:cANSI
"set guifont=Meslo_LG_S_DZ:h10:cANSI
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

nnoremap j gj
nnoremap k gk

"Convinent >
nnoremap < <<
nnoremap > >>

"Shift > enhance
vnoremap < <gv
vnoremap > >gv

"Symblo Auto Complete

"inoremap ( ()<left>
"inoremap < <><left>
"inoremap " ""<left>
"inoremap [ []<left>
"inoremap { {}<left>

"paragraph jump enhance

vmap { {j
vmap } }k

"CSS File Auto Jump
autocmd FileType css inoremap <buffer> { {}<left><CR><esc>O

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
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
set complete-=i

"}}}
"}}}
"自定义函数{{{1

"选中内容进行全局替换{{{2
vmap qq y:%s/<C-R>"//g
"}}}

"选中同级缩进{{{2

nnoremap vi vitoj0ok$

"}}}

"快速定位到修改点{{{2

noremap gn /'TARGETS'<CR>:nohl<CR>9xi

"}}}

"调用不同浏览器{{{2

nmap <leader>ff :call Explores("ff")<CR>
nmap <leader>ch :call Explores("ch")<CR>

"}}}

"Full Screen{{{2

let g:MyVimLib = 'gvimfullscreen.dll'
map <F12> <Esc>:call libcallnr(g:MyVimLib, "ToggleFullScreen", 0)<CR>
"au GUIEnter * call libcallnr('vimtweak.dll', "SetAlpha", 240)

"}}}

"清除SRT字幕内容 {{{2
nmap <F2> :call Clean_Srt()<CR>
function! Clean_Srt()
    "文本处理
    silent %s/^\d\+\n\d\{2}:.*-->.*\n//ge "删除序号和时间轴
    silent %s/<.\{-}>//ge                 "删除尖括号内容
    silent %s/^$\n//ge                    "删除隔行
    silent %s/[^.!?]\zs\n/ /ge            "拼接断行
    silent %s/\n/&&/g                     "重新添加隔行

    "保存副本
    let filename = substitute(bufname("%"), ".srt", "", "")
    exec "w " . filename . ".cleaned.txt"
endfunction

"}}}

"小窗口

function! SmallScreen()
    se lines=15 | se columns=70
endfunction

"}}}

"}}}

"==================插件设置==========================

"插件设置{{{1

:filetype plugin on
:filetype plugin indent on

"ACP{{{2
  "let g:acp_mappingDriven = 0
"}}}

"Neocomplete {{{2

	let g:acp_enableAtStartup = 0
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_smart_case = 1

"}}}

"Airline {{{2

let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_iminsert=1
let g:airline_theme='solarized'
let g:airline_inactive_collapse=1

"let g:airline_section_a       (mode, paste, iminsert)
"let g:airline_section_b       (hunks, branch)
"let g:airline_section_c       (bufferline or filename)
"let g:airline_section_gutter  (readonly, csv)
"let g:airline_section_x       (tagbar, filetype, virtualenv)
"let g:airline_section_y       (fileencoding, fileformat)
"let g:airline_section_z       (percentage, line number, column number)
"let g:airline_section_warning (syntastic, whitespace)

"}}}

"CtrlP {{{2
    map <c-p> :CtrlPMRU<CR>
"}}}

"Vim Outilner{{{2
au! filetype votl map <buffer> <C-a> ,,cx
au filetype votl normal zM
"}}}

"NERDTree{{{2
map <F10> :NERDTree<CR>
"}}}

"Indent Lines {{{2
let g:indentLine_char = '|'
"}}}

"mystatusline {{{2
"}}}2

"Markdown{{{2

let g:vim_markdown_no_default_key_mappings=1
let g:vim_markdown_math=1
let g:vim_markdown_frontmatter=1

au! filetype md inoremap <buffer>  <C-i> ![]()<left>

"}}}

"Voom{{{2
map <F11> :Voom<CR>
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
