function EpubBulid()

    :let a = input("第一步\n请选择文本来源：1、轻国 2、轻国在线 3、DOC  4、贴吧：","1")
    :call inputrestore()

    if a == 1
        :silent call LkClean()
    elseif a == 2
        :silent call LkOLClean()
    elseif a == 3
        :silent call DoctoEpub()
    elseif a == 4
        :silent call TiebaClean()
    endif

    :let l:info = ["标题", "作者", "<title>封面</title>", "<img src=\"images/cover.jpg\" />", "<title>彩图</title>"]
    :call append(0, info)

    :call inputsave()
    :let b = input("第二步\n请选择标题类型：1、第*章/第*幕 2、其他规则类型  3、不规则标题：", "1")
    :call inputrestore()

    if b == 1
        :silent call AddTitles()
    elseif b == 2
        :let c = input("输入标题正则表达式：")
        :execute "silent %s/<p>\\(序\\(章\\|幕\\|\\)\\|后记\\|後記\\|" . c . "\\)<\\/p>/<title>\\1<\\/title>\\r<h1>\\1<\\/h1>/ge"
    elseif b == 3
        :echo "请使用手动方式添加标题"
        :return
    endif

    ":silent call SentenceConnect()

endfunction

function SymbolChange()
python << EOF
 
# -*- coding: UTF-8 -*- 

import vim
import string
import re

b = vim.current.buffer

t = u'\n'.encode("UTF-8").join(b)

t = t.decode("UTF-8")

t = re.sub(u'( |\t|　)+', u' ', t)
t = re.sub(u'[\[“【]', u'「', t)
t = re.sub(u'[\]”】]', u'」', t)
t = re.sub(u'‘', u"『", t)
t = re.sub(u'’', u"』", t)
# t = re.sub(u'[‘’]', u"'", t)
t = string.replace(t, "&", "&amp;")
t = re.sub(u'[<〈]', '&lt;', t) 
t = re.sub(u'[>〉]', '&gt;', t)
t = re.sub(u'…+|。{2,}', '...', t)
t = re.sub(u'^ +', '', t)
t = re.sub(u'(\n)+', '\n', t)
t = string.replace(t, u"：", u":")
t = string.replace(t, u"（", u"(")
t = string.replace(t, u"）", u")")
t = string.replace(t, u"，", u",")
t = string.replace(t, u"！", u"!")
t = string.replace(t, u"？", u"?")

t = t.encode("UTF-8").split('\n')

b[:] = None

b.append(t[1:])

b[0] = None
EOF

:silent %s/^ \+//ge
:silent %s/^$\n//ge
endfunction

function SentenceConnect()
    %s/\([^"!?.)——。！？”……）＊※☆★□■♢\*]\|\d\{2,}\)\zs<\/p>\n<p>//ge
endfunction
		
function HtmltoEpub()
    :silent %s/^.*src="\(.\{-}\)".*$/\[img src="\1" \/\]/ge
    :silent %s/<.\{-}>//ge
    :silent call SymbolChange()
    :silent %s/^$\n\|^[\s,\t]*$\n//ge
    :silent %s/^\(.*$\)/<p>\1<\/p>/ge
    :silent %s/<p>\[\zeimg/</ge
    :silent %s/\/\zs\]<\/p>/>/ge
endfunction

function DoctoEpub()
    %s/[^>]\zs\n//ge
    %s/\n\ze[^<]//ge
    call HtmltoEpub()
    %s/&nbsp;//ge
    %s/<p><\/p>\n//ge
    %s/src="\zs.\{-}\ze\//images/ge
endfunction

function Booksplite()
    let starts=[]
    let starts_num = 0
    let starts_cou = -1
    let c = 1
    g/<title>.*<\/title>/let i=line(".")|call add(starts,i)|let starts_cou+=1
    while starts_num < starts_cou
        let ends_num = starts_num +1
        let ends_line = starts[ends_num] - 1
        execute "silent ".starts[starts_num].",".ends_line."w c".c.".xhtml"
        let starts_num += 1
        let c += 1
    endwhile
    execute "silent ".starts[starts_num].",$"."w c".c.".xhtml"
endfunction

"function LkClean()
    ":let @a=""
    ":silent g/<td.*class="t_f".*>/;/<\/td>/y A
    ":w
    ":e new.xhtml
    ":normal ap
    ":let @a=""
    "normal kdd
"endfunction

function GetImages()
    :silent %s/http.*\(jpg\|png\|gif\)/\r&/g
    :let @a=""
    :silent g/http.*\(jpg\|png\|gif\)/y A
    :tabnew
    :normal "apgg2dd
    :normal ggVG"+y
endfunction

function LkClean()
    :silent %s/\(本帖.*编辑\n\|.*(.*下载次数:.*).*\n\|^.*上传下载附件.*\n\)//ge
    :silent call SymbolChange()
    :silent %s/^\(.*$\)/<p>\1<\/p>/ge
    :silent %s/<p>.*http.*\/\(.*\(jpg\|gif\|png\)\)<\/p>/<img src="images\/\1" \/>/ge
endfunction

function LkOLClean()
    :silent %s/.*img.*cover="/http:\/\/lknovel.lightnovel.cn/ge
    :silent %s/jpg.*/jpg/ge
    :call GetImages()
    :normal gt
    :silent %s/<.\{-}>//ge
    :silent call SymbolChange()
    :silent %s/^\(.*$\)/<p>\1<\/p>/ge
    :silent %s/<p>.*http.*\/\(.*\(jpg\|gif\|png\)\)<\/p>/<img src="images\/\1" \/>/ge
endfunction

function AddTitle()
    :silent t.
    :normal k
    :silent s/^<p>\(.*\)<\/p>$\n^<p>\(.*\)<\/p>$/<title>\2<\/title>\r<h1>\2<\/h1>/e
    :nohl
endfunction

function AddTitles()
    :%s/<p>\(\(序\|终\)\(章\|幕\)\|后记\|後記\|第.\{,3}\(章\|幕\).*\)<\/p>/<title>\1<\/title>\r<h1>\1<\/h1>/ge
endfunction

function TiebaClean()
    :let @a=""
    :silent g/<cc>\_.\{-}<\/cc>/y A
    :w
    :e new.xhtml
    :normal "ap
    :let @a=""
    normal kdd
endfunction

function EpubZip()
    silent ! ~/.vim/bundle/epub-bulid/plugin/py/strucreat.py
endfunction
