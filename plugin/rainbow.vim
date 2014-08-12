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

if exists('g:rainbow_active') && g:rainbow_active
    if exists('g:rainbow_load_separately')
        let ps = g:rainbow_load_separately
        for i in range(len(ps))
            if len(ps[i]) < 3
                exe printf('auto Syntax %s call rainbow#load(ps[%d][1])' , ps[i][0] , i)
            endif
        endfor
    else
        auto syntax * call rainbow#load()
    endif
endif

command! Rainbow call rainbow#toggle()
