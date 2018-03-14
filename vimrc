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
  set ttyfast
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

  set lazyredraw " redraw only when we need to

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

  " allow cursor change in tmux mode
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif

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

  set smarttab " Lets be smart about tabs
  set expandtab " Because tabs < spaces

  set shiftround

  noremap j gj
  noremap k gk

  nnoremap gV `[v`] " highlight last inserted text

  " Autocommand groups {{{
    augroup filetype_vim
      autocmd!
      autocmd FileType vim setlocal foldmethod=marker
    augroup END
  " }}}

  " File Type Indenting {{{
    autocmd FileType objc setlocal expandtab shiftwidth=4 softtabstop=4
  " }}}

  " Cursor line only in active window {{{
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  " }}}

  " FileType specific options {{{
  " whitespace blows
  " autocmd BufWritePre * :%s/\s\+$//e
  " Rely on Autoformat to handle formatting on save
  " autocmd BufWrite * :Autoformat
  autocmd FileType java,php,javascript,objc,python,ruby,perl,swift,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  autocmd FileType yaml,yml autocmd BufWinEnter <buffer> IndentGuidesToggle
  " }}}

  " Treat `.ipa`s as `.zip` files
  autocmd BufReadCmd *.ipa call zip#Browse(expand("<amatch>"))

  " Save files on focus lost events, like switching spits
  autocmd BufLeave,FocusLost * silent! wall


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
    inoremap kj <ESC>

    " toggle case of word
    inoremap <c-`> <ESC>viw~<ESC>i
    " upper case word
    inoremap <c-u> <ESC>viwU<esc>i

  " }}}

  " Normal Mode {{{
    " Arrow keys are for  resizing.
    nnoremap <UP> :resize -2 <CR>
    nnoremap <DOWN> :resize +2 <CR>
    nnoremap <LEFT> :vertical resize +2 <CR>
    nnoremap <RIGHT> :vertical resize -2 <CR>

    " remape ; to : in normal mode because i suck at shift
    nnoremap ; :
    " Better split navigation
    nnoremap <C-j> <C-W>j
    nnoremap <C-k> <C-W>k
    nnoremap <C-h> <C-W>h
    nnoremap <C-l> <C-W>l

    " Easier expanding of windows
    nnoremap <C-_> <C-W>_

    " space to toggle folds.
    nnoremap <space> za

    " Clear highlighed search
    nnoremap <Leader><ESC> :noh<CR>
    "
    " Open up Vimrc for editing
    nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
    " Source up my Vimrc
    nnoremap <Leader>sv :source $MYVIMRC<CR>

    " toggle gundo
    nnoremap <leader>u :GundoToggle<CR>

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Reset highlighted search
    nnoremap <CR> :let @/=""<CR><CR>
  " }}}

  " Command Mode {{{
    command! -nargs=* -bang -complete=file W w<bang> <args>

    " Beacuse I suck at remembering sudo
    cnoremap w!! w !sudo tee % > /dev/null
  " }}}
" }}}

" Bundle Installation {{{
  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
" }}}

" Bundle Configs {{{
  colorscheme wombat256 "set after plugins installed

  " CamelCaseMotion {{{
    map <silent> w <Plug>CamelCaseMotion_w
    map <silent> b <Plug>CamelCaseMotion_b
    map <silent> e <Plug>CamelCaseMotion_e
    sunmap w
    sunmap b
    sunmap e
    omap <silent> iw <Plug>CamelCaseMotion_iw
    xmap <silent> iw <Plug>CamelCaseMotion_iw
    omap <silent> ib <Plug>CamelCaseMotion_ib
    xmap <silent> ib <Plug>CamelCaseMotion_ib
    omap <silent> ie <Plug>CamelCaseMotion_ie
    xmap <silent> ie <Plug>CamelCaseMotion_ie
  " }}}
  " Committia {{{
    let g:committia_hooks = {}
    function! g:committia_hooks.edit_open(info)
      " Additional settings
      setlocal spell

      " Scroll the diff window from insert mode
      " Map <C-n> and <C-p>
      imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
      imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
    endfunction
  " }}}
  " ctrlp {{{
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'FZF'
  " }}}
  " incsearch {{{
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
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
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#max_list = 15
    let g:neocomplete#force_overwrite_completefunc = 1


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

    " Plugin key-mappings {
        inoremap <CR> <CR>
        " <ESC> takes you out of insert mode
        inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
        " <CR> accepts first, then sends the <CR>
        " inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
        " <Down> and <Up> cycle like <Tab> and <S-Tab>
        inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
        " Jump up and down the list
        inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
        " <TAB>: completion.
        inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

        " Courtesy of Matteo Cavalleri

        function! CleverTab()
          if pumvisible()
              return "\<C-n>"
          endif
          let substr = strpart(getline('.'), 0, col('.') - 1)
          let substr = matchstr(substr, '[^ \t]*$')
          if strlen(substr) == 0
            " nothing to match on empty string
            return "\<Tab>"
          else
            " existing text matching
            return neocomplete#start_manual_complete()
          endif
        endfunction

        imap <expr> <Tab> CleverTab()
    " }

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::' 
  " }}}
  " neocomplete-example {{{
    " Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    " let g:acp_enableAtStartup = 0
    " Use neocomplete.
    " let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    " let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    " let g:neocomplete#sources#syntax#min_keyword_length = 3
    " let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    " let g:neocomplete#sources#dictionary#dictionaries = {
      " \ 'default' : '',
      " \ 'vimshell' : $HOME.'/.vimshell_hist',
      " \ 'scheme' : $HOME.'/.gosh_completions'
      "     \ }

    " Define keyword.
    " if !exists('g:neocomplete#keyword_patterns')
    "   let g:neocomplete#keyword_patterns = {}
    " endif
    " let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    " inoremap <expr><C-g>     neocomplete#undo_completion()
    " inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    " function! s:my_cr_function()
    "   return neocomplete#close_popup() . "\<CR>"
    "   " For no inserting <CR> key.
      "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    " endfunction
    " <TAB>: completion.
    " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " " <C-h>, <BS>: close popup and delete backword char.
    " inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    " inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " inoremap <expr><C-y>  neocomplete#close_popup()
    " inoremap <expr><C-e>  neocomplete#cancel_popup()
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
    " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " " Enable heavy omni completion.
    " if !exists('g:neocomplete#sources#omni#input_patterns')
    "   let g:neocomplete#sources#omni#input_patterns = {}
    " endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    " let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
  " }}}
  " vim-airline {{{
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_theme = 'murmur'
    let g:airline_left_sep='›'  " Slightly fancier than '>'
    let g:airline_right_sep='‹' " Slightly fancier than '<'

    let g:airline#extensions#tmuxline#enabled = 0 " disable tmuxline so it doesn't overwrite settings
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
    " let g:filetype_m = 'objc'

  " }}}
  " vim-easy-align {{{
    vmap <Enter> <Plug>(EasyAlign)

    nmap ga <Plug>(EasyAlign)
  " }}}
  " clang-format {{{
    let g:clang_format#code_style = 'llvm'
  " }}}
  " indent guides {{{
    let g:indent_guides_auto_colors = 0
    hi IndentGuidesOdd  guibg=red   ctermbg=black
    hi IndentGuidesEven guibg=green ctermbg=darkgrey
    " let g:indent_guides_guide_size = 1
  " }}}
  " undotree {{{
    nnoremap <silent> <Space>u :UndotreeToggle<CR>
  " }}}
  " ale {{{
    let g:airline#extensions#ale#enabled = 1
    let g:ale_completion_enabled = 1
    let g:ale_open_list = 1
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
  " }}}
  " syntastic {{{
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']
    " let g:syntastic_javascript_checkers = ['xo']
  " }}}
  " Fzf {{{
    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }
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

" Local vimrc {{{
  if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
" }}}

packloadall
silent! helptags ALL

