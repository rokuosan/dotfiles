---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      oxlint = { workspace_required = true },
      eslint = { settings = { format = false } },
    },
    features = {
      inlay_hints = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
      },
    },
  },
}
