---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    servers = {
      "oxfmt",
      "oxlint",
    },
    config = {
      oxlint = {
        cmd = { "pnpm", "exec", "vp", "lint", "--lsp" },
        settings = {
          fixKind = "safe_fix",
        },
      },
      oxfmt = {
        cmd = { "pnpm", "exec", "vp", "fmt", "--lsp" },
      },
    },
    formatting = {
      filter = function(client)
        local has_oxfmt = vim
          .iter(vim.lsp.get_clients { bufnr = 0 })
          :any(function(attached_client) return attached_client.name == "oxfmt" end)

        return not has_oxfmt or client.name == "oxfmt"
      end,
    },
  },
}
