function EpubBuild() "{{{1

    :let a = input("第一步\n请选择文本来源：1、轻国 2、轻国在线 3、DOC  4、贴吧：","1")
    :call inputrestore()

    if a == 1
        :silent call LkClean()
    elseif a == 3
        :silent call EpubClean()
    elseif a == 3
        :silent call LkOLClean()
    elseif a == 4
        :silent call DoctoEpub()
    elseif a == 5
        :silent call TiebaClean()
    endif

    :let l:info = ["标题", "作者", "<title>封面</title>", "<img src=\"images/cover.jpg\" />", "<title>彩图</title>"]
    :call append(0, info)

    :call inputsave()
    :let b = input("第二步\n请选择标题类型：1、第*章/第*幕 2、其他规则类型  3、不规则标题：", "1")
    :call inputrestore()

    if b == 1
        :silent call AddTitles("")
    elseif b == 2
        :let c = input("输入标题正则表达式：")
        :exec 'call AddTitles("' . c . '")'
    elseif b == 3
        :echo "请使用手动方式添加标题"
        :return
    endif

    ":silent call SentenceConnect()

endfunction "}}}1

function SymbolChange() "{{{1

    silent %s/[１２３４５６７８９０]/\={'１':'1','２':'2','３':'3','４':'4','５':'5','６':'6','７':'7','８':'8','９':'9','０':'0'}[submatch(0)]/ge
    silent %s/[ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ]/\={'Ａ':'A','Ｂ':'B','Ｃ':'C','Ｄ':'D','Ｅ':'E','Ｆ':'F','Ｇ':'G','Ｈ':'H','Ｉ':'I','Ｊ':'J','Ｋ':'K','Ｌ':'L','Ｍ':'M','Ｎ':'N','Ｏ':'O','Ｐ':'P','Ｑ':'Q','Ｒ':'R','Ｓ':'S','Ｔ':'T','Ｕ':'U','Ｖ':'V','Ｗ':'W','Ｘ':'X','Ｙ':'Y','Ｚ':'Z'}[submatch(0)]/ge
python << EOF
 
# -*- coding: UTF-8 -*- 

import vim
import string
import re

b = vim.current.buffer

t = u'\n'.encode("UTF-8").join(b)

t = t.decode("UTF-8")

def symbolchange(t):

    t = re.sub(u'( |\t|　)+', u' ', t)
    t = re.sub(u'[\[“【]', u'「', t)
    t = re.sub(u'[\]”】]', u'」', t)
    t = re.sub(u'‘', u"『", t)
    t = re.sub(u'’', u"』", t)
    # t = re.sub(u'[‘’]', u"'", t)
    #t = string.replace(t, "&", "&amp;")
    #t = re.sub(u'[<〈]', '&lt;', t) 
    #t = re.sub(u'[>〉]', '&gt;', t)
    t = re.sub(u'…+|。{2,}', '...', t)
    t = re.sub(u'^ +', '', t)
    t = re.sub(u'(\n)+', '\n', t)
    t = string.replace(t, u"：", u":")
    t = string.replace(t, u"（", u"(")
    t = string.replace(t, u"）", u")")
    t = string.replace(t, u"，", u",")
    t = string.replace(t, u"！", u"!")
    t = string.replace(t, u"？", u"?")

    return t

t = symbolchange(t)

t = t.encode("UTF-8").split('\n')

b[:] = None

b.append(t[1:])

b[0] = None
EOF

:silent %s/^ \+//ge
:silent %s/^$\n//ge
endfunction "}}}1

function SentenceConnect() "{{{1
    %s/\([^"!?.)——。！？”……）＊※☆★□■♢\*]\|\d\{2,}\)\zs<\/p>\n<p>//ge
endfunction "}}}1
		
function HtmltoEpub() "{{{1
    :silent %s/^.*src="\(.\{-}\)".*$/\[img src="\1" \/\]/ge
    :silent %s/<.\{-}>//ge
    :silent call SymbolChange()
    :silent %s/^$\n\|^[\s,\t]*$\n//ge
    :silent %s/^\(.*$\)/<p>\1<\/p>/ge
    :silent %s/<p>\[\zeimg/</ge
    :silent %s/\/\zs\]<\/p>/>/ge
endfunction "}}}1

function DoctoEpub() "{{{1
    %s/[^>]\zs\n//ge
    %s/\n\ze[^<]//ge
    call HtmltoEpub()
    %s/&nbsp;//ge
    %s/<p><\/p>\n//ge
    %s/src="\zs.\{-}\ze\//images/ge
endfunction "}}}1

function Booksplite() "{{{1
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
endfunction "}}}1

function GetImages() "{{{1
    :silent %s/http.*\(jpg\|png\|gif\)/\r&\r/g
    :let @a=""
    :silent g/http.*\(jpg\|png\|gif\)/y A
    :tabnew
    :normal "apgg2dd
    :sort u
    :normal ggVG"+y
endfunction "}}}1

function LkClean() "{{{1
    :silent %s/\(本帖.*编辑\n\|.*(.*下载次数:.*).*\n\|^.*上传下载附件.*\n\)//ge
    :silent call SymbolChange()
    :silent %s/^\(.*$\)/<p>\1<\/p>/ge
    :silent %s/<p>.*http.*\/\(.*\(jpg\|gif\|png\)\)<\/p>/<img src="images\/\1" \/>/ge
endfunction "}}}1

function LkOLClean() "{{{1
    :silent call DownloadLKOL()
    :call GetImages()
    :normal gt
    :silent call SymbolChange()
    :silent %s/^\(.*$\)/<p>\1<\/p>/ge
    :silent %s/<p>.*http.*\/\(.*\(jpg\|gif\|png\)\)<\/p>/<img src="images\/\1" \/>/ge
endfunction "}}}1

function EpubClean() "{{{1

    :silent g/\vxml|http|html|head|link|body|script|meta/d
    :silent %s`<br />\|<div.\{-}>\|</div>\|<span.\{-}>\|</span>\| alt=".\{-}"\|\.\./``ge
    :silent g`<p></p>\|<title></title>\|^$`d
    :silent call SymbolChange()

endfunction "}}}

function AddTitle() "{{{1
    :silent t.
    :normal k
    :silent s/^<p>\(.*\)<\/p>$\n^<p>\(.*\)<\/p>$/<title>\2<\/title>\r<h1>\2<\/h1>/e
    :nohl
endfunction "}}}1

function AddTitles(pattern) "{{{1

    if a:pattern != ""
        exec "%s`<p>\\(" . a:pattern . "\\)</p>`<title>\\1</title>\\r<h1>\\1</h1>`g"
    else
        %s`\v\<p\>([序终終间][章幕]|幕间|后记|後記|第.{,3}[章幕话].*)\</p\>`<title>\1</title>\r<h1>\1</h1>`ge
    endif

endfunction "}}}1

function TitleCheck() "{{{1

    vimgrep /<title>/ %
    copen

endfunction "}}}1

function TiebaClean() "{{{1
    :let @a=""
    :silent g/<cc>\_.\{-}<\/cc>/y A
    :w
    :e new.xhtml
    :normal "ap
    :let @a=""
    normal kdd
endfunction "}}}1

function DownloadLKOL() "{{{1
" download the novel from http://lknovel.lightnovel.cn

python << EOF
#!/usr/bin/python
# -*- coding: UTF-8 -*- 
# A simple script for download the novel text and images form www.lightnovel.cn

import vim
import os
import sys
sys.path.append('/Users/zecy/.vim/bundle/epub-build/plugin/py')
import getpage

# All the scripts are run on the current vim buffer
b = vim.current.buffer

# Website url
#lk = 'http://lknovel.lightnovel.cn'
lk = 'www.linovel.com'

url = b[0] # put the index page url on the first on the current buffer and get it
chapters = len(b)

indexs = getpage.get_page_index(url, 'lk-chapter-list') # get all the chapter page url from index page

# get the article from each chapter page

image_urls = []

for u in indexs:
    text = getpage.get_page_text(u, 'mt-20')   # 'mt-20' is the class of article block
    images = text.find_all('img')              # get all the lines the contain image urls

    # get the image url from attr and put it into innerHTML
    for image in images:
        image_url = lk + image['data-cover']
        image.string = image_url
        image_urls.append(image_url)
    
    content = text.get_text()                  # output the text whitout tags, the result is unicode
    #content = symbolchange(content)            # format the symbols
    texts   = unicode(content).split(u'\n')       # covert the 'tag' to 'unicode', an split to 'list'
    b.append(texts)                            # output the article to vimbuffer

EOF
endfunction "}}}1

function DownloadSyosetu() "{{{1
" download the novel from http://syosetu.com/
" 从「小説家になろう」下载小说
" 用法：
" 1、从小说目录页源代码中获取所有需要下载的章节
" 2、运行函数，会调用 vim 命令抽取出所有 url 部分
" 3、自动把 url 组装成域名开始下载

" VimL 部分，整理源代码。

silent v/href/d
silent %s,.*href="\(.*\)">.*,http://ncode.syosetu.com\1,e
silent ! ~/.vim/bundle/epub-build/plugin/py/download-syosetu.py

" Python 部分，用于下载
"python << EOF
"#!/usr/bin/python
"# -*- coding: UTF-8 -*- 
"# A simple script for download the novel text and images form www.lightnovel.cn
"
"import vim
"import os
"import sys
"sys.path.append('/Users/zecy/.vim/bundle/epub-build/plugin/py')
"import getpage
"
"# All the scripts are run on the current vim buffer
"b = vim.current.buffer
"
"urls = b[0:] # put the index page url on the first on the current buffer and get it
"
"chapters = len(b)
"
"b[:] = None
"
"# get the article from each chapter page
"
"
"for i, u in enumerate(urls, start=1):
"    title = getpage.get_page_text(u, 'novel_subtitle')   # 'novel_subtitle' is the class of article block
"    text  = getpage.get_page_text(u, 'novel_view')       # 'novel_view' is the class of article block
"    
"    title   = '* ' + title.get_text()                # output the text whitout tags, the result is unicode
"    content = text.get_text()                 # output the text whitout tags, the result is unicode
"    titles  = unicode(title)                  # covert the 'tag' to 'unicode', an split to 'list'
"    texts   = unicode(content).split(u'\n')   # covert the 'tag' to 'unicode', an split to 'list'
"    b.append(titles)                          # output the article to vimbuffer
"    b.append(texts)                           # output the article to vimbuffer
"
"vim.command("echo('完成第 " + str(i) + " / " + str(chapters) + " 章')")
"
"EOF
endfunction "}}}1

function EpubZip() "{{{1
    silent ! ~/.vim/bundle/epub-build/plugin/py/strucreat.py
endfunction "}}}1
