---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true, ignored = false, exclude = { ".git" } },
        grep = { hidden = true, ignored = false, exclude = { ".git" } },
      },
    },
  },
}
