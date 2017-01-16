# -*- coding:utf-8 -*-
# 百度贴吧爬虫

import re
import getpage

def getPageNum(url):
    pattern = re.compile(u'共(\d+)页', re.S)
    content = getpage.get_page_text(url, 'l_reply_num').get_text()
    result  = re.search(pattern, content)
    if result:
        return result.group(1)
    else:
        return None

f = open('index.txt','r')
urls = f.read().split('\n')
f.close()

#chapters = urls[-2].split('/')[-1]
chapter_len = str(len(urls))

print "开始下载……"

for i, u in enumerate(urls, start=1):

    num_format = '%0' + chapter_len + 'd'

    chapter = num_format%int(i)

    u = u + '?see_lz=1'

    title  = getpage.get_page_text(u, 'core_title_txt')   # 'novel_view' is the class of article block

    pageNum = getPageNum(u).encode('utf-8')                     # get the page number, return unicode

    content = []

    for j in range(int(pageNum)):

        text  = getpage.get_page_texts(u + '&pn=' + str(j), 'd_post_content')   # 'novel_view' is the class of article block

        for t in text:
            for s in t.stripped_strings:
                content.append(s)                         # output the text whitout tags, the result is unicode

    title   = title.get_text()                             # output the text whitout tags, the result is unicode

    titles  = unicode(title)                               # covert the 'tag' to 'unicode'

    texts   = u'\n'.join(content)                           # convert the list to uicode str

    chap_con = titles + u'\n\n' + texts


    chap_out = open( chapter + ' ' + titles + '.txt','w' )

    chap_out.write( chap_con.encode('utf-8') )

    chap_out.close

    print "完成第 " + chapter + " / " + chapter_len + " 个帖子"

print "下载完成\n共 " + chapter_len + " 个帖子"
