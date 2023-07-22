-- disable filetypes
vim.g.copilot_filetypes = { xml = false }

-- change the accept key to <C-a> to change conflicts
vim.cmd[[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]
vim.g.copilot_no_tab_map = true

-- cycle to the next suggestion with <M-]>
vim.cmd[[imap <silent><script><expr> <C-]> copilot#Next()]]

