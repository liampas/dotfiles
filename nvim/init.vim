" Copy visual selection to Wayland clipboard without deleting it
xnoremap <leader>y :<C-u>call system('wl-copy', getline("'<","'>"))<CR>

set number

syntax on

set hlsearch
