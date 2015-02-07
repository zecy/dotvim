# -*- coding: UTF-8 -*- 

import vim
import string
import re

b = vim.current.buffer

b = b.decode("UTF-8")

pattern_list = repl_list = []

pattern_list.append(re.compile(u'( |\t|　)+'))
reg[1][0] = re.compile(u'[\[\]“”「」『』【】]')
reg[2][0] = re.compile(u'[‘’]')

reg[0][1] = u' '
reg[1][1] = u'"'
reg[2][1] = u"'"

%s/&/\&amp;/ge

reg[3][0] = re.compile(u'[<〈]')
reg[3][1] = u'&lt;'

reg[4][0] = re.compile(u'[>〉]')
reg[4][1] = '&gt;'

reg[5][0] = re.compile(u'……\|。\{2,}')
reg[5][1] = u'...'

reg[6][0] = re.compile('u^ \+')
reg[6][1] = ''

reg[7][0] = re.compile(u'^[\s]*$\n')
reg[7][1] = ''
