let mapleader=' '

lua require("lazy-bootstrap").bootstrap()
lua require("lazy").setup("plugin-list")

" colorscheme nightfox
set background=light
colorscheme gruvbox

set number
set relativenumber
set autoindent
set undofile
set termguicolors
set shortmess+=c
set nowrap
set noshowmode
set laststatus=3
set signcolumn=no
set nowritebackup
set mouse=nvia
set updatetime=300
set pumheight=6
set splitbelow
set splitright
set timeoutlen=200
set foldenable
set foldcolumn=0
set foldlevel=99
set foldlevelstart=-1
set guicursor=i:block

let g:instant_username = "fetch"

lua << EOF
function _G.buf_lsp_definition()
	if vim.lsp.buf then
		vim.lsp.buf.definition()
	end
end
EOF

nnoremap <silent>]g <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent>[g <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent><leader>wv <cmd>vsplit<CR>
nnoremap <silent><leader>wh <cmd>split<CR>
nnoremap <silent><leader>h <C-w>h
nnoremap <silent><leader>j <C-w>j
nnoremap <silent><leader>k <C-w>k
nnoremap <silent><leader>l <C-w>l
nnoremap <silent><leader>em <cmd>RustLsp expandMacro<CR>
nnoremap <silent><leader>u <cmd>RustLsp move up<CR>
nnoremap <silent><leader>d <cmd>RustLsp move down<CR>
nnoremap <silent><leader>ap <cmd>lua require("actions-preview").code_actions()<CR><cmd>w<CR>
nnoremap <silent><leader>ac <cmd>RustLsp codeAction<CR><cmd>w<CR>
nnoremap <silent><leader>ad <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent><leader>f <cmd>Telescope find_files<CR>
nnoremap <silent><leader>b <cmd>Telescope buffers<CR>
nnoremap <silent><leader>p <cmd>lua require("cmdbar-cfg").open(require("telescope.themes").get_dropdown({}))<CR>
nnoremap <silent><leader>g <cmd>LazyGit<CR>
nnoremap <silent><leader>t <cmd>TroubleToggle workspace_diagnostics<CR>
nnoremap <silent><C-q> <cmd>call OpenTermInSplit()<CR>
nnoremap <silent><C-i> <cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>
nnoremap <silent><C-S-p> <cmd>lua _G.buf_lsp_definition()<CR>
" inoremap <C-B> <cmd>lua require('cmp').complete()<CR>

tnoremap <C-=> <C-\><C-N><cmd>q<CR>

au TermOpen * set nonumber & norelativenumber
au TermOpen * startinsert
au BufEnter term://* startinsert
au BufEnter *.vert set ft=glsl
au BufEnter *.frag set ft=glsl
au BufEnter *.luau set ft=luau
au WinEnter * call OpenTermIfMarkerSet()
" autocmd("ModeChanged", "*:i", function(ev) vim.diagnostic.reset(nil, ev.buf) end)

 hi Normal guibg=#00000000
 hi NormalNC guibg=#00000000
 hi WinSeparator guibg=#00000000
" hi Pmenu guibg=#303030
" hi DiagnosticError guifg=#ff4934
hi! link @function.builtin Function

if exists('g:neovide')
  set guifont=monospace:h16
endif

function! OpenTermInSplit()
	let g:marker_must_open_terminal = v:true
	belowright split
endfunction

function! OpenTermIfMarkerSet()
	if g:marker_must_open_terminal
		let g:marker_must_open_terminal = v:false
		terminal
		set nonumber & norelativenumber
		startinsert
	endif
endfunction

let g:marker_must_open_terminal = v:false

lua require("config-core")
