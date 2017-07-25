#!/usr/bin/python
# -*- coding: UTF-8 -*-
# A simple script for download the novel text and images form
# https://kakuyomu.jp

import os
import sys
from bs4 import BeautifulSoup
from urllib import request

# All the scripts are run on the current vim buffer

ROOT_URL = 'https://kakuyomu.jp'
USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.75 Safari/537.36'
HEADERS = {'User-Agent': USER_AGENT}


def work_url(id):
    return ROOT_URL + '/works/' + str(id)


def get_html_dom(url):
    req = request.Request(url, headers=HEADERS)
    try:
        html = request.urlopen(req).read()
        return BeautifulSoup(html, "html5lib")
    except:
        print(url)


def get_eps_list(id):
    dom = get_html_dom(work_url(id))
    widget_toc_episode = dom.find_all(class_='widget-toc-episode')
    eps_list = []
    for ele in widget_toc_episode:
        ep_href = ele.a.attrs['href']
        ep_title = ele.span.string
        ep = {'href': ep_href, 'title': ep_title}
        eps_list.append(ep)
    return eps_list


def get_episode(ep):
    title = ep['title']
    ep_url = ROOT_URL + ep['href']
    dom = get_html_dom(ep_url)
    text = dom.find(class_='widget-episodeBody').text
    return '* ' + title + '\n\n' + text


def main(id):
    print('开始下载……\n\n')

    print('获取章节链接……\n')

    eps_list = get_eps_list(id)

    eps_len = len(str(len(eps_list)))

    print('下载章节……\n')

    for i, ep in enumerate(eps_list):
        title = ep['title']

        ep_order = str(i + 1).rjust(eps_len, '0')

        print('　　获取第 ' + ep_order +
              ' / ' + str(len(eps_list)) + ' 章 ' + title + ' ……')

        content = get_episode(ep)

        print('　　写入文件……')

        file_name = str(i + 1).rjust(eps_len, '0') + ' ' + title

        with open(file_name + '.txt', mode='w', encoding='utf-8') as f:
            f.write(content)

        print('　　第 ' + ep_order + ' 章保存完成。\n\n')

    print('全部完成！！')


if __name__ == '__main__':
    argvs = sys.argv
    if len(argvs) != 2:
        print('参数不正确，请按照以下格式调用。')
        print('download-kakuyomu <id>')
    else:
        try:
            main(int(argvs[1]))
        except TypeError as e:
            print(e)
            print('id 必须是纯数字。')
