" Modeline & notes {{{
" vim: set sw=2 ts=2 sts=2 et tw=78 foldmethod=marker
" }}}

" We don't care about vi anymore.
set nocompatible

" Install plugins
" We'll be using vim-plug for this

" UI Stuff {{{
  filetype plugin indent on " Detect filetypes automagically
  syntax on " This shouldn't even be a damn option really

  scriptencoding utf-8 " This should be default really...

  set wrap " word wrap. Because Fuck your long lines
  set shiftround " Because I want to know you drug your line on too fucking long

  set showmode " Why is this not default?
  set cursorline " I like to know where I am.
  set virtualedit=onemore " allow me to go one beyond end of line
  set iskeyword-=. " . is an end of word designator
  set iskeyword-=# " # is an end of word designator

  " splits go below and to the right. I just like that
  set splitright
  set splitbelow

  set backspace=indent,eol,start
  set linespace=0
  set showmatch
  set incsearch
  set hlsearch
  set winminheight=0
  set ignorecase
  set smartcase
  set wildmenu
  set wildmode=list:longest,full
  set whichwrap=b,s,h,l,<,>,[,]
  set foldenable
  set list

  " Git stuff
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " Restore cursor to file position in previous editing session
  function! ResCur()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction

  augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur() augroup END
" }}}

" Editing {{{
  " I like 2 spaces for my tabs, thank you
  set shiftwidth=2
  set tabstop=2
  set softtabstop=2

  set expandtab " Because tabs > spaces

  set shiftround

  set showmatch

  " Autocommand groups {{{
    augroup filetype_vim
      autocmd!
      autocmd FileType vim setlocal foldmethod=marker
    augroup END
  " }}}

  " whitespace blows
  autocmd FileType c,cpp,java,go,php,javascripts,objc,python,ruby,perl,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" }}}

" Undo File & Backups {{{
  set backup
  set undofile
  set history=1000 " I want to know my past
  set undolevels=1000
  set undoreload=10000
" }}}

" Key Remaps & Configs {{{
  " Global
  let mapleader = ","

  " Insert Mode {{{
    inoremap <up> <nop>
    inoremap <down> <nop>
    inoremap <left> <nop>
    inoremap <right> <nop>

    " You're welcome for these
    inoremap jj <ESC>
    inoremap kk <ESC>

    " toggle case of word
    inoremap <c-`> <ESC>viw~<ESC>i
    " upper case word
    inoremap <c-u> <ESC>viwU<esc>i

  " }}}

  " Normal Mode {{{
    " Arrow keys are for bitches. Stop using them >:[
    nnoremap <up> <nop>
    nnoremap <down> <nop>
    nnoremap <left> <nop>
    nnoremap <right> <nop>

    " remape ; to : in normal mode because i suck at shift
    nnoremap ; :
    " Better split navigation
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    " space to toggle folds.
    nnoremap <space> za

    " Clear highlighed search
    nnoremap <Leader><ESC> :noh<CR>
    "
    " Open up Vimrc for editing
    nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
    " Source up my Vimrc
    nnoremap <Leader>sv :source $MYVIMRC<CR>
  " }}}
" }}}

" Bundle Configs {{{
  " NerdTree {{{
  " }}}
  " OmniComplete {{{
  " }}}
  " Ctags {{{
  " }}}
  " Tabularize {{{
  " }}}
  " Session List {{{
  " }}}
  " TagBar {{{
  " }}}
  " YouCompleteMe {{{
  " }}}
  " neocomplete {{{
  " }}}
  " vim-airline {{{
  " }}}
" }}}

" Functions {{{
  function! StripTrailingWhitespace()
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business
    %s/\s\+$//e
    " cleanup: restore previous search history & cursor position
    let @/=_s
    call cursor(l, c)
  endfunction
" }}}
