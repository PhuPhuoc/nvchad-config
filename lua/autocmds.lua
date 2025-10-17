require "nvchad.autocmds"

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/templates/*.yaml", "*/templates/*.tpl" },
  callback = function()
    vim.bo.filetype = "helm"
    vim.cmd("setlocal syntax=helm")
  end,
})


-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.yaml", "*.yml", "*.tpl" },
--   callback = function(args)
--     require("configs.conform").format_on_save(args.buf)
--   end,
-- })
