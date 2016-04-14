#!/usr/bin/python
# -*- coding: UTF-8 -*- 
# A simple script for downloading novel text

import urllib2
import os
from bs4 import BeautifulSoup


""" The user_agent of my broswer ( Firefox 33.0 )
 avoid the redirect """

#user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:33.0) Gecko/20100101 Firefox/33.0'
user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.75 Safari/537.36'


headers = {'User-Agent': user_agent,'Cookie': 'over18=yes'}

def get_the_dom(url):

    request = urllib2.Request(url, '', headers)

    htm = urllib2.urlopen(request)

    dom = BeautifulSoup(htm)

    return dom

def get_page_index(index_page_url, ele_class):

    URLS = []

    dom = get_the_dom(index_page_url)

    arches = dom.find(class_=ele_class).find_all('a')

    for u in arches:
        url = u['href']
        URLS.append(url)

    return URLS

def get_page_text(page_url, ele_class):

    #TEXT = []

    dom = get_the_dom(page_url)
    
    content = dom.find(class_=ele_class)

    return content

def get_page_text_by_ID(page_url, ele_id):

    dom = get_the_dom(page_url)

    content = dom.find(id=ele_id)

    return content
