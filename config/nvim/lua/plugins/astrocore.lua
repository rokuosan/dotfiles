---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      i = {
        ["<C-c>"] = { "<Esc>", desc = "Exit insert mode" },
      },
    },
  },
}
