---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true, ignored = false, exclude = { ".git" } },
          grep = { hidden = true, ignored = false, exclude = { ".git" } },
        },
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>ff"] = { function() require("snacks").picker.files() end, desc = "Find files" },
        },
      },
    },
  },
}
