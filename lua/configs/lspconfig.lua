-- lua/configs/lspconfig.lua
-- Đăng ký 1 số cấu hình cho servers thường dùng (theo API vim.lsp.config / vim.lsp.enable)
-- Không gọi require('lspconfig') để tránh cảnh báo deprecated.

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok and cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

-- Lua language server
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

-- Python (pyright)
vim.lsp.config("pyright", {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = { typeCheckingMode = "basic" },
    },
  },
})

vim.lsp.config("yamlls", {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      validate = true,
    },
  },
})

-- Nếu bạn muốn bật server "tức thì" (ví dụ không dùng mason-lspconfig auto-enable),
-- dùng vim.lsp.enable(). Nếu bạn đã dùng mã trong plugins/init.lua (vim.lsp.enable),
-- không cần gọi lại ở đây.
-- vim.lsp.enable({ "lua_ls", "pyright" })
