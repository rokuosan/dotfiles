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
  },
}
