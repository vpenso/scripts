"no backup files at all
set nobackup
set nowritebackup
set noswapfile

set spell           " spell checking on
set hlsearch        " highlight search terms

" more powerful backspacing
set backspace=indent,eol,start
set wrap            " wrap lines
set showbreak=…     " if line numbers are of indicate it
set expandtab       " no real tabs please!

" disable recording
map q <Nop>
" disable ex mode
nnoremap Q <nop>
" disable the arrow keys
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" highlight the current line & column
set cursorline
set cursorcolumn
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn

" enable relative line numbers
set rnu
au BufEnter * :set rnu
au BufLeave * :set nu
au WinEnter * :set rnu
au WinLeave * :set nu
au InsertEnter * :set nu
au InsertLeave * :set rnu
au FocusLost * :set nu
au FocusGained * :set rnu

" To define a mapping which uses the "mapleader" variable, the
" special string "<leader>" can be used.  It is replaced with the
" string value of "mapleader". If "mapleader" is not set or empty,
" a backslash ('\') is used instead as default.
let mapleader = ' '

" highlight invisible characters
"
" shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Use the symbols from Unicode for tab-stops and end-of-line
set listchars=tab:▸␣,eol:¬,space:·,nbsp:␣,trail:•,precedes:«,extends:»
" Clearing highlighted searches
nmap <silent> <leader>/ :nohlsearch<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/autoload/plugged')

Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'

" syntax highlighting for i3
Plug 'mboughaba/i3config.vim'
" Shows git diff markers in the sign column
Plug 'airblade/vim-gitgutter'
" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" official support for Rust
Plug 'rust-lang/rust.vim'
Plug 'vim-syntastic/syntastic'

Plug 'folke/which-key.nvim'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Commands
"    :PlugInstall      Install plugins
"    :PlugClean        Remove unlisted plugins
" Initialize plugin system
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN CONFIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" select a custom theme
let g:lightline = { 'colorscheme': 'ayu_light', }

" Configure the vim-gitgutter plugin
let g:gitgutter_terminal_reports_focus=0
set updatetime=100
hi SignColumn      ctermbg=231
hi GitGutterAdd    ctermfg=22
hi GitGutterChange ctermfg=21
hi GitGutterDelete ctermfg=27

" key mapping for fzf.vim
nnoremap <silent> <C-f> :GFiles<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>g :Commits<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTAX HIGHLIGHTING COLORS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" visual selection mode
hi Visual ctermfg=none ctermbg=227
" horizontal line at current cursor position
hi CursorLine ctermbg=230 cterm=none
" vertical line at current cursor position
hi CursorColumn ctermfg=none ctermbg=230
" text width indicator column
hi ColorColumn ctermfg=none ctermbg=254
" line numbering on the left
hi LineNr ctermfg=252 ctermbg=255
" line numbering in cursor line
hi CursorLineNR ctermfg=232 ctermbg=252 cterm=bold

hi SpellBad     ctermfg=52 ctermbg=209 cterm=bold
" eol, extends and precedes
hi NonText      ctermfg=124
" nbsp, tab and trail
hi SpecialKey   ctermfg=124 cterm=bold

hi Comment      ctermfg=247 ctermbg=255
hi Number       ctermfg=166
hi String       ctermfg=74
hi Boolean      ctermfg=39
hi Constant     ctermfg=54
hi Identifier   ctermfg=208
hi Function     ctermfg=26
hi Statement    ctermfg=33
hi PreProc      ctermfg=33   cterm=bold
hi Type         ctermfg=160
hi Special      ctermfg=92
hi Error        ctermfg=none ctermbg=none

hi shQuote        ctermfg=241
hi shOption       ctermfg=31
hi shDerefSimple  ctermfg=34
hi shCommandSub   ctermfg=31 ctermbg=none cterm=bold
hi shSpecial      ctermfg=124

hi htmlTag                        ctermfg=241
hi htmlEndTag                     ctermfg=241
hi htmlH3                         ctermfg=243 cterm=bold
hi htmlLink                       ctermfg=255 cterm=bold
hi htmlSpecialChar                ctermfg=166
hi cssStyle                       ctermfg=241
hi cssDefinition                  ctermfg=248
hi cssBraces                      ctermfg=241
hi cssTagName                     ctermfg=36
hi cssIdentifier                  ctermfg=36 cterm=bold
hi cssClassName                   ctermfg=36 cterm=bold
hi cssPseudoClassId               ctermfg=23
hi cssTextProp                    ctermfg=221
hi cssFontProp                    ctermfg=221
hi cssBoxProp                     ctermfg=221
hi cssRenderProp                  ctermfg=187
hi cssColorProp                   ctermfg=221 cterm=bold
hi cssCommonAttr                  ctermfg=187 cterm=bold
hi cssTextAttr                    ctermfg=187
hi cssBoxAttr                     ctermfg=187
hi cssUIAttr                      ctermfg=187
hi cssColor                       ctermfg=43
hi erubyDelimiter                 ctermfg=214 cterm=bold
hi javaScript                     ctermfg=232
hi javaScriptFunction             ctermfg=39 cterm=bold
hi javaScriptIdentifier           ctermfg=208 cterm=bold
hi javaScriptType                 ctermfg=160 cterm=bold
hi javaScriptBoolean              ctermfg=70 cterm=bold
hi rubySymbol                     ctermfg=208
hi rubyBlockParameter             ctermfg=40
hi rubyStringDelimiter            ctermfg=27
hi rubyInterpolationDelimiter     ctermfg=203
hi rubyStringEscape               ctermfg=240 cterm=bold
hi rubyRegexpDelimiter            ctermfg=237 ctermbg=none cterm=bold
hi rubyRegexpAnchor               ctermfg=203 cterm=bold
hi rubyRegexpBrackets             ctermfg=240 cterm=bold
hi rubyRegexpEscape               ctermfg=26  cterm=bold
hi rubyRegexpDot                  ctermfg=124 cterm=bold
hi rubyRegexpCharClass            ctermfg=214
hi rubyRegexpQuantifier           ctermfg=220

hi markdownH1                     ctermfg=33 cterm=bold
hi markdownH2                     ctermfg=33 cterm=bold
hi markdownH3                     ctermfg=33 cterm=bold
hi markdownItalic                 ctermfg=248
hi markdownBold                   cterm=bold
hi markdownListMarker             ctermfg=160 cterm=bold
hi markdownHeadingDelimiter       ctermfg=33
hi markdownLinkText               ctermfg=167
hi markdownLinkDelimiter          ctermfg=178
hi markdownLinkTextDelimiter      ctermfg=178
hi markdownUrl                    ctermfg=240
hi markdownCode                   ctermfg=241
hi markdownCodeBlock              ctermfg=24
hi markdownCodeDelimiter          ctermfg=180 cterm=bold
hi markdownLineBreak              ctermbg=153
hi markdownId                     ctermfg=244
hi markdownIdDeclaration          ctermfg=202
