---@type LazySpec
return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = "assets",
      relative_to_current_file = true,
      prompt_for_file_name = false,
    },
    filetypes = {
      markdown = {
        template = "![$CURSOR]($FILE_PATH)",
      },
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
  },
}
