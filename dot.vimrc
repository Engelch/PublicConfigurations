:set ignorecase
:set smartcase
:set incsearch
:set hlsearch

:set tabstop=3     " tabs are at proper location"
:set shiftwidth=3  " indenting is 4 spaces"
:set autoindent    " turns it on"
:set smartindent   " does the right thing (mostly) in programs"
:set cindent       " stricter rules for C programs"

:set backup       " makes tilde file backups"
:set mouse=a      " allow mouse to change cursor position"
:set showmatch	   " briefly jump to matching brackets"

:set number
:set paste
:set expandtab

" *               - search for word currently under cursor"
" g*              - search for partial word under cursor "
"                   (repeat with n)"
" ctrl-o, ctrl-i  - go through jump locations"
" [I              - show lines with matching word under cursor"

if has("spell")
  " turn spelling on by default
  "set spell

  " toggle spelling with F12 key
  map <F12> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

  " they were using white on white
  highlight PmenuSel ctermfg=black ctermbg=lightgray

  " limit it to just the top 10 items
  set sps=best,10
endif

" if you manually add to your wordlist, you need to regenerate it:
"     :mkspell! ~/.vim/spell/en.latin1.add
" some useful keys for spellchecking:
"   ]s       - forward to misspelled/rare/wrong cap word
"  [s       - backwards

"  ]S       - only stop at misspellings
"  [S       - in other direction

"  zG       - accept spelling for this session
"  zg       - accept spelling and add to personal dictionary

"  zW       - treat as misspelling for this session
"  zw       - treat as misspelling and add to personal dictionary

"  z=       - show spelling suggestions

"  :spellr  - repeat last spell replacement for all words in window
