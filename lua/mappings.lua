require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
map("n", "j", "jzz", opts)
map("n", "k", "kzz", opts)
--
-- next match vẫn giữ giữa màn hình
map("n", "n", "nzzzv", opts)   
map("n", "N", "Nzzzv", opts) 


map("v", "J", ":m '>+1<CR>gv=gv", opts) -- move block xuống
map("v", "K", ":m '<-2<CR>gv=gv", opts) -- move block lên

-- LSP keymaps
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gD", vim.lsp.buf.declaration, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "K", vim.lsp.buf.hover, opts)

-- Diagnostic keymaps
map("n", "[d", function()
  vim.diagnostic.goto_prev()
  vim.defer_fn(function()
    vim.diagnostic.open_float(nil, { focus = false })
  end, 100)
end, opts)

map("n", "]d", function()
  vim.diagnostic.goto_next()
  vim.defer_fn(function()
    vim.diagnostic.open_float(nil, { focus = false })
  end, 100)
end, opts)

map("n", "<C-s>", function()
  vim.cmd("w")  -- save file
  require("conform").format({ async = false, lsp_fallback = true })
end, { desc = "Save + Format" })

map("i", "<C-s>", function()
  vim.cmd("w")
  require("conform").format({ async = false, lsp_fallback = true })
end, { desc = "Save + Format" })

-- for AI chat (Copilot)
local chat = require("CopilotChat")
-- Toggle Copilot Chat panel
map("n", "<leader>co", function()
  chat.toggle()
end, { desc = "Copilot Chat: Toggle window" })

-- Giải thích file hiện tại
map("n", "<leader>ce", function()
  chat.ask("Explain the current file in vietnamese")
end, { desc = "Copilot Chat: Explain file in vietnamese" })

-- Hỏi về code đang chọn
map("v", "<leader>ca", function()
  chat.ask("Explain this code in Vietnamese")
end, { desc = "Copilot Chat: Ask about selected code in vietnamese" })

-- Fix code đang chọn
map("v", "<leader>cf", function()
  chat.ask("Fix and improve this code with best practices and explain in Vietnamese")
end, { desc = "Copilot Chat: Fix selected code and explain in Vietnamese" })
