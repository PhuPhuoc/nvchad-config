local M = {}

M.formatters_by_ft = {
  javascript = { "prettier" },
  typescript = { "prettier" },
  json       = { "prettier" },
  yaml       = { "prettier" },
  helm       = { "yamlfmt" },
  go         = { "gofmt", "goimports" }, -- QUAN TRỌNG ❗
}

M.format_on_save = function(bufnr)
  require("conform").format({
    bufnr = bufnr,
    lsp_fallback = true,
    async = false,
    timeout_ms = 1500,
  })
end

M.formatters = {
  yamlfmt = {
    command = vim.fn.expand("~/go/bin/yamlfmt"),
    args = {
      "--in",
      "--conf", vim.fn.expand("~/.config/yamlfmt.yaml"),
      "-",
    },
    stdin = true,
  },

  prettier = {
    command = "/usr/local/node/node-v22.18.0-linux-x64/bin/prettier",
    args = { "--stdin-filepath", "$FILENAME" },
    stdin = true,
  },

  gofmt = {
    command = "gofmt",
    args = { "-s" },
    stdin = true,
  },

  goimports = {
    command = "goimports",
    args = {},
    stdin = true,
  },
}

return M

-- local M = {}
--
-- M.formatters_by_ft = {
--   javascript = { "prettier" },
--   typescript = { "prettier" },
--   json       = { "prettier" },
--   yaml       = { "prettier" },
--   helm       = { "yamlfmt" },  -- template/helm files -> yamlfmt
--   go         = { "gofmt" },
-- }
--
-- M.format_on_save = function(bufnr)
--   require("conform").format({
--     bufnr = bufnr,
--     lsp_fallback = true,
--     async = false,
--     timeout_ms = 1000,
--   })
-- end
--
-- M.formatters = {
--   yamlfmt = {
--     command = vim.fn.expand("~/go/bin/yamlfmt"),  -- hoặc "yamlfmt" nếu trong $PATH
--     args = {
--       "--in",
--       "--conf", vim.fn.expand("~/.config/yamlfmt.yaml"),
--       "-",   -- yamlfmt chấp nhận '-' để đọc stdin
--     },
--     stdin = true,
--   },
--
--   prettier = {
--     command = "/usr/local/node/node-v22.18.0-linux-x64/bin/prettier",
--     args = { "--stdin-filepath", "$FILENAME" },
--     stdin = true,
--   },
--
--   gofmt = {
--     command = "gofmt",
--     args = { "-s" },
--     stdin = true,
--   },
-- }
--
-- return M
