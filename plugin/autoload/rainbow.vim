" read file vim73/rgb.txt for all named colors
let s:guifgs = exists('g:rainbow_guifgs')? g:rainbow_guifgs : [
            \ 'RoyalBlue3', 'DarkOrange3', 'SeaGreen3', 'FireBrick',
            \ ]
            "\ 'DarkOrchid3', 'RoyalBlue3', 'SeaGreen3',
            "\ 'DarkOrange3', 'FireBrick',

let s:ctermfgs = exists('g:rainbow_ctermfgs')? g:rainbow_ctermfgs : [
            \ 'darkmagenta', 'darkgreen', 'darkblue',
            \ 'darkcyan', 'darkred', 'darkgray',
            \ ]

let s:max = has('gui_running')? len(s:guifgs) : len(s:ctermfgs)

func! rainbow#load(...)
    if exists('b:loaded')
        cal rainbow#clear()
    endif
    let b:loaded = (a:0 < 1) ? [['(',')'],['\[','\]'],['{','}']] : a:1
    if b:loaded == []
        unlet b:loaded
        return
    endif
    let str = 'TOP'
    for each in range(1, s:max)
        let str .= ',lv'.each
    endfor
    let cmd = 'syn region %s matchgroup=%s start=+%s+ end=+%s+ containedin=%s contains=%s'
    for [left , right] in b:loaded
        for each in range(1, s:max - 1)
            exe printf(cmd, 'lv'.each, 'lv'.each.'c', left, right, 'lv'.(each+1) , str)
        endfor
        exe printf(cmd, 'lv'.s:max, 'lv'.s:max.'c', left, right, 'lv1' , str)
    endfor
    for id in range(1 , s:max)
        let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
        let guifg = s:guifgs[(s:max - id) % len(s:guifgs)]
        exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
    endfor
endfunc

func! rainbow#clear()
    if !exists('b:loaded')
        return
    endif
    unlet b:loaded
    for each in range(1 , s:max)
        exe 'syn clear lv'.each
    endfor
endfunc

func! rainbow#toggle()
    if exists('b:loaded')
        cal rainbow#clear()
    else
        cal rainbow#load()
    endif
endfunc

