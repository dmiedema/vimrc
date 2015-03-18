" Modeline & notes {{{
" vim: set sw=2 ts=2 sts=2 et tw=78 foldmethod=marker
"
" Base vimrc config
"
" If you want to customize it at all, include your changes in a
" `vimrc.local` file
" }}}

" Basics {{{
" We don't care about vi anymore.
  set nocompatible
" }}}

" UI Stuff {{{
  filetype plugin indent on " Detect filetypes automagically
  syntax on " This shouldn't even be a damn option really

  set number

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
    autocmd BufWinEnter * call ResCur()
  augroup END
" }}}

" Editing {{{
  " I like 2 spaces for my tabs, thank you
  set shiftwidth=2
  set tabstop=2
  set softtabstop=2
  set foldmethod=syntax
  set foldlevelstart=20
  set foldlevel=20

  set expandtab " Because tabs > spaces

  set shiftround

  noremap j gj
  noremap k gk

  " Autocommand groups {{{
    augroup filetype_vim
      autocmd!
      autocmd FileType vim setlocal foldmethod=marker
    augroup END
  " }}}

  " whitespace blows
  autocmd BufWritePre * :%s/\s\+$//e
  " autocmd FileType c,cpp,java,go,php,javascripts,objc,python,ruby,perl,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" }}}

" Undo File & Backups {{{
  set backup
  set undofile
  set history=1000 " I want to know my past
  set undolevels=1000
  set undoreload=10000

  let dir_list = { 'backup': 'backupdir', 'views': 'viewdir', 'swap': 'directory' }
  if has('persistent_undo')
    let dir_list['undo'] = 'undodir'
  endif

  for [dirname, settingname] in items(dir_list)
    let directory = expand('~/.vim/') . dirname . '/'
    if exists("*mkdir")
      if !isdirectory(directory)
        call mkdir(directory)
      endif
    endif
    if !isdirectory(directory)
      echo "Warning: Unable to create backup directory: " . directory
      echo "Try: mkdir -p " . directory
    else
      let directory = substitute(directory, " ", "\\\\ ", "g")
      exec "set " . settingname . "=" . directory
    endif
  endfor
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

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$
  " }}}
" }}}

" Bundle Installation {{{
  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
" }}}

" Bundle Configs {{{
  colorscheme Tomorrow "set after plugins installed
  " ctrlp {{{
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
  " }}}
  " NerdTree {{{
    map <C-e> <plug>NERDTreeTabsToggle<CR>
    map <Leader>e :NERDTreeToggle<CR>
    nmap <Leader>nt :NERDTreeFind<CR>

    let NerdTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git', '^\.hg$']
    let NerdTreeShowHidden=1
    let NerdTreeKeepTreeInNewTab=1
  " }}}
  " TagBar {{{
    nnoremap <silent> <Leader>tt :TagbarToggle<CR>
  " }}}
  " neocomplete {{{
      "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
      " Disable AutoComplPop.
      " let g:acp_enableAtStartup = 0
      " Use neocomplete.
      let g:neocomplete#enable_at_startup = 1
      " Use smartcase.
      let g:neocomplete#enable_smart_case = 1
      " Set minimum syntax keyword length.
      let g:neocomplete#sources#syntax#min_keyword_length = 3
      let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

      " Define dictionary.
      let g:neocomplete#sources#dictionary#dictionaries = {
          \ 'default' : '',
          \ 'vimshell' : $HOME.'/.vimshell_hist',
          \ 'scheme' : $HOME.'/.gosh_completions'
              \ }

      " Define keyword.
      if !exists('g:neocomplete#keyword_patterns')
          let g:neocomplete#keyword_patterns = {}
      endif
      let g:neocomplete#keyword_patterns['default'] = '\h\w*'

      " Plugin key-mappings.
      inoremap <expr><C-g>     neocomplete#undo_completion()
      inoremap <expr><C-l>     neocomplete#complete_common_string()

      " Recommended key-mappings.
      " <CR>: close popup and save indent.
      inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
      function! s:my_cr_function()
        return neocomplete#close_popup() . "\<CR>"
        " For no inserting <CR> key.
        "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
      endfunction
      " <TAB>: completion.
      inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
      " <C-h>, <BS>: close popup and delete backword char.
      inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
      inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
      inoremap <expr><C-y>  neocomplete#close_popup()
      inoremap <expr><C-e>  neocomplete#cancel_popup()
      " Close popup by <Space>.
      "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

      " For cursor moving in insert mode(Not recommended)
      "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
      "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
      "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
      "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
      " Or set this.
      "let g:neocomplete#enable_cursor_hold_i = 1
      " Or set this.
      "let g:neocomplete#enable_insert_char_pre = 1

      " AutoComplPop like behavior.
      "let g:neocomplete#enable_auto_select = 1

      " Shell like behavior(not recommended).
      "set completeopt+=longest
      "let g:neocomplete#enable_auto_select = 1
      "let g:neocomplete#disable_auto_complete = 1
      "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

      " Enable omni completion.
      autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
      autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
      autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
      autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
      autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

      " Enable heavy omni completion.
      if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
      endif
      "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
      "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
      "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

      " For perlomni.vim setting.
      " https://github.com/c9s/perlomni.vim
      let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
  " }}}
  " vim-airline {{{
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_theme = 'tomorrow'
    let g:airline_left_sep='›'  " Slightly fancier than '>'
    let g:airline_right_sep='‹' " Slightly fancier than '<'
  " }}}
  " tmux-complete {{{
    let g:tmuxcomplete#trigger = ''
  " }}}
  " vim-marching {{{
      let g:marching_clang_complete = "/usr/bin/clang"
      let g:marching_enable_neocomplete = 1

      if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
      endif

      let g:neocomplete#force_omni_input_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    " }}}
  " YouCompleteMe {{{
      let g:ycm_confirm_extra_conf    = 0
      let g:ycm_complete_in_comments  = 1
      let g:ycm_extra_conf_vim_data   = ['&filetype']
      let g:ycm_seed_identifiers_with_syntax = 1
      let g:filetype_m = 'objc'

  " }}}
  " vim-easy-align {{{
    vmap <Enter> <Plug>(EasyAlign)

    nmap ga <Plug>(EasyAlign)
  " }}}
  " clang-format {{{
    let g:clang_format#code_style = 'llvm'
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
"

" Local vimrc {{{
  if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
" }}}
