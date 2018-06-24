source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

syntax on
set noeb vb t_vb=
set cindent
set guifont=Consolas:h12:cEASTEUROPE
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
imap jj <ESC>
set timeoutlen=200
"""colorscheme inkpot
"colorscheme diokai
set noswapfile
colorscheme molokai
set noswapfile
set nobackup
set noundofile
set shiftwidth=2
set dictionary=C:\Users\m3r8\wordlist.txt
set nu
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap {{ {<CR>  <CR>};<Up>
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
inoremap { {}<left>
inoremap "" "
inoremap [[ [
inoremap (( (
inoremap '' '
inoremap {{{ {
noremap <C-S-Right> :tabnext<CR>
noremap <C-S-Left> :tabprevious<CR>
noremap <C-S-Up> :tabnew<CR>
set showcmd	
set showmatch		
set ignorecase	
set incsearch	
set autowrite	
set fenc=utf8
set enc=utf8
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <Tab>     pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-Tab>       pumvisible() ? "\<C-p>" : "\<C-Tab>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

