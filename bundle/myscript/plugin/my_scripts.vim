autocmd! bufwritepost _vimrc source %

function SendSelectedToCMD() "{{{1
    normal vy
    :silent %s,<C-R>",,ge
endfunction "}}}1

function Explores(name) "{{{1
    let file = expand("%:p")
    exec ":update " . file
    let l:browsers = {
        \"ch":"E:/Program Files/chromeplus/chrome.exe",
        \"ff":"E:/Program Files/Mozilla Firefox/firefox.exe"
    \}
	exec ":silent !start ". "\"" . l:browsers[a:name] . "\"" . " file://" . "\"%:p\""
endfunction "}}}1

function KeepCV() "{{{1
    KeepLines .*\n.*声 -.*
    :silent %s,.*声\ze - \|^$\n,,ge
endfunction "}}}1

command! KeepCV call KeepCV()

function PreSymbloClean() "{{{1
    :silent %s/\( -\|:\| :\|：\|　\|\t\).*//ge
endfunction "}}}1

function AfterSymbloClean() "{{{1
    :silent %s/.*\(- \|:\|: \|：\|　\|\t\)//ge
endfunction "}}}1

function ListSplit() "{{{1
    :silent %s/\s\+$\|　\+$//ge
    :silent %s/\( - \|:\| :\|: \|：\|　\+\|\t\+\)/\r    /ge
    :silent %s/<dd>/\r    /ge
    :silent %s/^$\n\|<.\{-}>//ge
    :call append(line('$'),'')
    :silent g/^ \+\|^　\+\|^\t\+/m$
endfunction "}}}1

command! ListSplit call ListSplit()

function StaffTrans() "{{{1
    :silent %s/^ \+//ge
    :silent %s/^原作$/原作/ge
    :silent %s/^企画$/计划/ge
    :silent %s/^原案$/原案/ge
    :silent %s/^\(ディレクター\|監督\)$/导演/ge
    :silent %s/^総監督$/总导演/ge
    :silent %s/^監修$/监修/ge
    :silent %s/シリーズディレクター/系列导演/ge
    :silent %s/シリーズ構成/剧本统筹/ge
    :silent %s/脚本/剧本/ge
    :silent %s/キャラクター原案/人物原案/ge
    :silent %s/キャラクターデザイン/角色设定/ge
    :silent %s/協力/协力/ge
    :silent %s/総作画監督/总作画指导/ge
    :silent %s/プロップデザイン/道具设定/ge
    :silent %s/^設定$/设定/ge
    :silent %s/^メカニックデザイン$/机械设定/ge
    :silent %s/^クリーチャーデザイン$/生物设定/ge
    :silent %s/^エフェクトディレクター$/特效指导/ge
    :silent %s/^色彩設計$/色彩设计/ge
    :silent %s/^色彩設定$/色彩设定/ge
    :silent %s/^美術設定$/美术设定/ge
    :silent %s/^美術監督$/美术指导/ge
    :silent %s/^美術$/美术/ge
    :silent %s/^撮影$/摄影/ge
    :silent %s/^撮影監督$/摄影指导/ge
    :silent %s/^CG\(\|I\)\(監督\|ディレクター\)$/CG\1指导/ge
    :silent %s/^CGモデリングディレクター$/CG建模指导/ge
    :silent %s/^編集$/剪辑/ge
    :silent %s/デザインワークス/设计/ge
    :silent %s/音響監督/音响指导/ge
    :silent %s/音響効果/音响效果/ge
    :silent %s/音響/音响/ge
    :silent %s/効果/效果/ge
    :silent %s/音楽/音乐/ge
    :silent %s/音楽制作/音乐制作/ge
    :silent %s/プロデューサー/制片人/ge
    :silent %s/製作\|プロデュース/出品/ge
    :silent %s/プランニングマネージャー/策划经理/ge
    :silent %s/アニメーション制作/动画制作/ge
    :silent %s/^制作$/动画制作/ge
endfunction "}}}1

command! StaffTrans call StaffTrans()

function DateTrans() "{{{1

    silent %s/\t/\r    /ge

    function! Checklines(sym, ln)
        let l:date = ""
        let l:lnum = 1
        let l:dic  ={}

        while l:lnum <= line("$")
            let l:lcon = getline(l:lnum)
            if match(l:lcon, '^[^ ]') > -1
                let l:nlcon = getline(l:lnum + a:ln)  "get the onair date
                if match(l:nlcon, a:sym) > -1      "check if a date
                    let l:date = l:nlcon           "store the new date
                else
                    let l:dic[l:lcon] = l:date   "build the none date TVsite : date
                endif
            endif
            let l:lnum += 1
        endwhile
        return l:dic
    endfunction

    for [l:ndtv, l:date] in items(Checklines('\d\{4}年', 1))
        exec "%s/" . l:ndtv . "/&\r" . l:date . "/e"
    endfor

    for [l:nttv, l:time] in items(Checklines('[金木水火土日月]曜', 2))
        exec "%s/" . l:nttv . "\\n.*/&\r" . l:time . "/e"
    endfor

    call append(line("$"),"")
    g/    /m$
    call append(line("$"),"")
    g/[金木水火土日月]曜/m$

    %s/ - /\r&
    call append(line("$"),"")
    g/ - /m$

    :silent %s/\d\zs[年月]\ze\d/\//ge
    :silent %s/\d\zs日.*//ge
    :silent %s/24\ze:/0/e
    :silent %s/25\ze:/1/e
    :silent %s/26\ze:/2/e
    :silent %s/27\ze:/3/e
    :silent %s/28\ze:/4/e
    :silent %s/[金木水火土日月]曜 \| - \|（.\{-}）//e
    :silent %s/（.*）//e
    :silent %s/ //ge

    let v:errmsg = ""
    silent! /\d\{4}.*\n^$\n\+/
    while v:errmsg == ""
        silent! %s/\v(\d{4}.*\n)\zs\n\ze\n/\1/g
    endwhile

    :silent %s/^\d\{4}.*\n\zs\n//e
    :call setline(line('$')+1,'')
    :g/\d\{4}/m$
    :norm dd
endfunction "}}}1

command! DateTrans call DateTrans()

function! KeepLines(pattern) "{{{1
    let pattern = a:pattern
    let hits = []
    "exec '%s/' . pattern . '/\=len(add(hits, submatch(0))) ? submatch(0): ""/ge'
    exec '%s/' . pattern . '/\=add(hits, submatch(0))/ge'
    let str = join(hits, "\n") . "\n"
    %d
    put! = str
endfunction "}}}1
command! -nargs=1 KeepLines call KeepLines(<f-args>)
