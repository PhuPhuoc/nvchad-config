return {
{
  "stevearc/conform.nvim",
  config = function()
    local conform_opts = require("configs.conform")

    require("conform").setup({
      formatters_by_ft = conform_opts.formatters_by_ft,
    })


    -- format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.ts", "*.js", "*.json", "*.yaml", "*.yml", "*.go" },
      callback = function(args)
        conform_opts.format_on_save(args.buf)
      end,
    })
  end,
},
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "typescript","javascript","go","yaml","json","dockerfile",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },

  },

  -- format yaml
  {
    "b0o/schemastore.nvim",
  },

  -- LSP (migrate sang vim.lsp.config / vim.lsp.enable)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",            -- chú ý: tên org mới nếu bạn dùng v2
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- 1) setup mason & mason-lspconfig
      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = {
          "gopls", "ts_ls", "jsonls", "yamlls",
        },
        -- important: disable automatic enabling so we can register configs first
        automatic_enable = false,
      })

      -- 2) prepare capabilities for nvim-cmp
      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if cmp_ok and cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end

      -- 3) register server configs via vim.lsp.config (no require('lspconfig') anywhere)
      vim.lsp.config("gopls", {
        capabilities = capabilities,
      })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = {
              { fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
              { fileMatch = { "tsconfig.json", "tsconfig.*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
            },
          },
        },
      })

      -- vim.lsp.config("yamlls", {
      --   capabilities = capabilities,
      --   settings = {
      --     yaml = {
      --       schemas = {
              -- ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
              -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
              -- ["https://json.schemastore.org/k8s-1.21.json"] = "/*.k8s.{yml,yaml}",
      --         ["https://json.schemastore.org/k8s-1.21.json"] = { "*.yaml", "*.yml" },
      --       },
      --     },
      --   },
      -- })

      -- 4) Bật (enable) các server đã register
      --    mason-lspconfig won't auto-enable because we set automatic_enable = false
      --    Nếu bạn muốn, có thể chỉ enable các server thực sự đã cài.
      vim.schedule(function()
        -- list servers you ensured_installed earlier
        vim.lsp.enable({ "gopls", "ts_ls", "jsonls", "yamlls" })
      end)
    end,
  },

  -- Autocomplete (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp","hrsh7th/cmp-buffer","hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip","saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" },
        }),
      })
    end,
  },

  -- Dockerfile syntax
  {
    "ekalinin/Dockerfile.vim",
    ft = "dockerfile",
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- copilot chính thức
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken", -- chỉ chạy nếu plugin yêu cầu
    opts = { debug = false },
    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)

      -- Toggle Chat
      vim.keymap.set("n", "<leader>co", function()
        chat.toggle()
      end, { desc = "Toggle Copilot Chat" })

      -- Hỏi Copilot về đoạn code đang chọn
      vim.keymap.set("v", "<leader>ca", function()
        chat.ask("Explain this code")
      end, { desc = "Copilot Chat: Ask about selected code" })

      -- Fix code đang chọn
      vim.keymap.set("v", "<leader>cf", function()
        chat.ask("Fix and improve this code")
      end, { desc = "Copilot Chat: Fix selected code" })

      -- Giải thích file hiện tại
      vim.keymap.set("n", "<leader>ce", function()
        chat.ask("Explain the current file")
      end, { desc = "Copilot Chat: Explain file" })
    end,
  },

}
