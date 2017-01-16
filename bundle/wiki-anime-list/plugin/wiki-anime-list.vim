function WALFormat ()
    :silent call KeepLines('<h2.*mw-headline.*>\|<table class="wikitable"\_.\{-}<\/table>')
    :silent g`th\|tr\|table`d
    :silent %s`<td></td>`""`ge
    :silent %s`<.\{-}>``ge
    :silent %s`\[編集]``ge
    :silent g`^$`d
    :silent %s`^\d\+月`\r&`ge
    :silent %s`^\(\d\+月.*\)\n\(.*\)\n\(.*\)\n.*\n\(.*\)`\1,\2,\3,\4`ge
    :silent g`^$`d
    :silent %s`^\(\d\{4}\)年.*`\r\1\r`ge
    let @a = ""
    let @a = 'veyjjV}:s`^\d\+月`"年&`ggv:s` - \(\d\+月\)` - "年\1'
    :silent g`^\d\{4}\n`norm @a
    :silent exec "w " . getline(2) . ".csv"
endfunction
