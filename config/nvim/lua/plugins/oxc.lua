---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      oxlint = {
        workspace_required = true,
      },
      eslint = { settings = { format = false } },
    },
  },
}
