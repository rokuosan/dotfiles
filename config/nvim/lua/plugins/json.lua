---@type LazySpec
return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    "AstroNvim/astrolsp",
    dependencies = { "b0o/SchemaStore.nvim" },
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      table.insert(opts.servers, "jsonls")

      opts.config = opts.config or {}
      opts.config.jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "json-lsp")
    end,
  },
}
