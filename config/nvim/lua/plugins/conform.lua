---@type LazySpec
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.default_format_opts = vim.tbl_extend("force", opts.default_format_opts or {}, { timeout_ms = 5000 })
    -- Run the first available formatter with a project configuration.
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    for _, ft in ipairs {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
      "css",
      "graphql",
      "vue",
      "svelte",
      "astro",
    } do
      opts.formatters_by_ft[ft] = { "biome", "oxfmt", "prettier", stop_after_first = true, lsp_format = "never" }
    end
    for _, ft in ipairs { "scss", "less", "html", "yaml", "markdown", "markdown.mdx" } do
      opts.formatters_by_ft[ft] = { "oxfmt", "prettier", stop_after_first = true, lsp_format = "never" }
    end
    opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
      biome = { require_cwd = true },
      prettier = { require_cwd = true },
      oxfmt = { require_cwd = true },
    })
  end,
}
