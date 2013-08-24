"==============================================================================
"Script Title: rainbow parentheses improved
"Script Version: 2.51
"Author: luochen1990
"Last Edited: 2012 Nov 18
"Simple Configuration:
"   first, put "rainbow.vim"(this file) to dir vim73/plugin or vimfiles/plugin
"   second, add the follow sentences to your .vimrc or _vimrc :
"
"           let g:rainbow_active = 1
"           let g:rainbow_operators = 1
"
"   third, restart your vim and enjoy coding.
"Advanced Configuration:
"   an advanced configuration allows you to define what parentheses to use
"   for each type of file . you can also determine the colors of your
"   parentheses by this way (read file vim73/rgb.txt for all named colors) .
"       e.g. this is an advanced config (add these sentences to your vimrc):
"
"           let g:rainbow_active = 1
"           let g:rainbow_operators = 2
"
"           let g:rainbow_load_separately = [
"           \   [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"           \   [ 'tex' , [['(', ')'], ['\[', '\]']] ],
"           \   [ 'cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"           \   [ 'html' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
"           \   ]
"
"           let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick',]
"
"User Command:
"   :Rainbow            --you can use it to toggle this plugin.


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
    let cmd = 'syn region %s matchgroup=%s start=+%s+ end=+%s+ containedin=%s contains=%s,%s'
    for [left , right] in b:loaded
        for each in range(1, s:max - 1)
            exe printf(cmd, 'lv'.each, 'lv'.each.'c', left, right, 'lv'.(each+1) , str , 'op_lv'.each)
        endfor
        exe printf(cmd, 'lv'.s:max, 'lv'.s:max.'c', left, right, 'lv1' , str , 'op_lv'.s:max)
    endfor
    for id in range(1 , s:max)
        let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
        let guifg = s:guifgs[(s:max - id) % len(s:guifgs)]
        exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
        exe 'hi default op_lv'.id.' ctermfg='.ctermfg.' guifg='.guifg
    endfor
endfunc

func! rainbow#clear()
    if !exists('b:loaded')
        return
    endif
    unlet b:loaded
    for each in range(1 , s:max)
        exe 'syn clear lv'.each
        exe 'syn clear op_lv'.each
    endfor
endfunc

func! rainbow#toggle()
    if exists('b:loaded')
        cal rainbow#clear()
    else
        cal rainbow#load()
    endif
endfunc

if exists('g:rainbow_active') && g:rainbow_active
    if exists('g:rainbow_load_separately')
        let ps = g:rainbow_load_separately
        for i in range(len(ps))
            if len(ps[i]) < 3
                exe printf('auto Syntax %s call rainbow#load(ps[%d][1])' , ps[i][0] , i)
            endif
        endfor
    else
        auto syntax * call rainbow#activate()
    endif
endif

command! Rainbow call rainbow#toggle()
