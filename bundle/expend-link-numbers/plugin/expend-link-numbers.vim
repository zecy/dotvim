function ExpLinkNumbers(...) 
    if a:0 > 0
        let l:pages = a:1
    else
        let l:pages = input("你忘记输入总页数了！\n请输入总页数：", "")
        redraw!
    endif

    silent call ChecknHentai()
    silent exec 'normal ggyy'.(l:pages-1).'p'
    silent exec 'let i=1|g`\v(http[s]?://.*/)\d+(\..*)`s``\=submatch(1).i.submatch(2)`|let i=i+1'
    silent normal ggVG$"+y
    echo "已复制 ".line('$')." 行到剪贴板"
endfunction
command! -nargs=* Exp call ExpLinkNumbers(<f-args>)

function ChecknHentai()
    let l:url=getline("1")
    if(match(l:url, 'nhentai') > 0)
        silent 1,1s`\vhttps://t.nhentai.net/galleries/(\d+)/1t.(jpg|png)`https://i.nhentai.net/galleries/\1/1.\2`e
    endif
endfunction
