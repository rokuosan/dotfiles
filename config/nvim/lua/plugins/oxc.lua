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
        settings = {
          fixKind = "safe_fix",
        },
      },
    },
    formatting = {
      filter = function(client)
        local has_oxfmt = vim.iter(vim.lsp.get_clients { bufnr = 0 }):any(function(attached_client)
          return attached_client.name == "oxfmt"
        end)

        return not has_oxfmt or client.name == "oxfmt"
      end,
    },
  },
}
