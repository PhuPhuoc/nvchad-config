local M = {}

M.formatters_by_ft = {
  javascript = { "prettier" },
  typescript = { "prettier" },
  json       = { "prettier" },
  yaml       = { "prettier" },
  go         = { "gofmt" },  -- bạn cũng có thể dùng "goimports"
}

M.format_on_save = function(bufnr)
  require("conform").format({
    bufnr = bufnr,
    lsp_fallback = true, -- nếu không có formatter thì dùng LSP
    async = false,
    timeout_ms = 1000,
  })
end

return M
