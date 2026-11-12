return {
  "keaising/im-select.nvim",
  cond = vim.fn.executable "im-select" == 1,
  opts = {
    default_command = "im-select",
    default_im_select = "com.apple.inputmethod.Kotoeri.RomajiTyping.Roman",
    set_default_events = { "VimEnter", "InsertLeave" },
    set_previous_events = {},
  },
}
