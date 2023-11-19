function! ndavd#keymaps#set() abort
endfunction

" --- Keymaps -----------------------------------------------------------"

" --- Window handling ---------------------------------------------------"
nn <silent><leader>h :wincmd h<CR>
nn <silent><leader>j :wincmd j<CR>
nn <silent><leader>k :wincmd k<CR>
nn <silent><leader>l :wincmd l<CR>
nn <silent><leader>x :wincmd c<CR>
nn <silent><leader>T :wincmd T<CR>
nn <silent><leader>= :wincmd =<CR>
nn <silent><leader>o :wincmd o<CR>
nn <silent><leader>sv :wincmd v<CR>
nn <silent><leader>sh :wincmd s<CR>

" --- Scroll up/down with keys ------------------------------------------"
nn <silent><C-j> <C-e>
nn <silent><C-k> <C-y>

" --- Scroll left/right with keys ---------------------------------------"
nn <C-h> 3zh
nn <C-l> 3zl

" --- Move lines up/down ------------------------------------------------"
nn <silent><A-s> :m .+1<CR>==
nn <silent><A-w> :m .-2<CR>==
ino <silent><A-s> <Esc>:m .+1<CR>==gi
ino <silent><A-w> <Esc>:m .-2<CR>==gi
vn <silent><A-s> :m '>+1<CR>gv=gv
vn <silent><A-w> :m '<-2<CR>gv=gv

" --- Keeping it centered -----------------------------------------------"
nn n nzzzv
nn N Nzzzv
nn J mzJ`z

" --- Formatting --------------------------------------------------------"
nn gqf mmgggqG`m

" --- Undo break points -------------------------------------------------"
ino , ,<C-g>u
ino . .<C-g>u
ino ! !<C-g>u
ino ? ?<C-g>u

" --- Tab handling ------------------------------------------------------"
nn <silent><leader>tc :tabc<CR>
nn <silent><leader>tn :tabn<CR>
nn <silent><leader>tp :tabp<CR>

" --- Activate/Deactivate Spelllang -------------------------------------"
nn <leader>p :setlocal spell spelllang=en_us<CR>
nn <leader>pt :setlocal spell spelllang=pt_pt<CR>
nn <leader><S-p> :set nospell<CR>

" --- Map to terminal ---------------------------------------------------"
nn <silent><leader>b <C-w>s<C-w>j:terminal<CR>i
