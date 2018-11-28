#!/usr/bin/python
# -*- coding: UTF-8 -*- 
# A simple script for download the novel text and images form www.lightnovel.cn

import os
import sys
import getpage

# All the scripts are run on the current vim buffer

f = open('index.txt','r')
urls = f.read().split('\n')
f.close()

urls = urls[:-1]

chapters = str(len(urls))
chapter_len = str(len(chapters))

# get the article from each chapter page

print("开始下载……")

for i, u in enumerate(urls, start=1):

    num_format = '%0' + chapter_len + 'd'

    chapter = num_format%int(u.split('/')[-2])

    title = getpage.get_page_text(u, 'novel_subtitle')     # 'novel_subtitle' is the class of article block

    text  = getpage.get_page_text_by_ID(u, 'novel_honbun')   # 'novel_view' is the class of article block
    
    titles   = title.get_text()                             # output the text whitout tags, the result is unicode

    texts = text.get_text()                              # output the text whitout tags, the result is unicode

    titles = titles.replace(u'/',u'／')

    chap_con = u'* ' + chapter + ' ' + titles + u'\n\n' + texts


    chap_out = open(chapter + ' ' + titles + '.txt','w')
    #chap_out.write(chap_con.encode('utf-8'))
    chap_out.write(chap_con)
    chap_out.close

    print("完成第 " + chapter + " / " + chapters + " 章 ")

print("下载完成\n共 " + chapters + " 章")
