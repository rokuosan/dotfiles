local command = nil

if vim.fn.executable "/opt/homebrew/bin/im-select" == 1 then
  command = "/opt/homebrew/bin/im-select"
elseif vim.fn.executable "im-select" == 1 then
  command = "im-select"
else
  return {}
end

return {
  "keaising/im-select.nvim",
  opts = {
    default_command = command,
    default_im_select = "com.apple.inputmethod.Kotoeri.RomajiTyping.Roman",
    set_default_events = { "VimEnter", "InsertLeave" },
    set_previous_events = {},
  },
}
