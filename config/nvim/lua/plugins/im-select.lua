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
  config = function()
    require("im_select").setup {
      default_command = command,
      default_im_select = "com.apple.keylayout.ABC",
      set_default_events = { "VimEnter", "InsertEnter", "InsertLeave" },
      set_previous_events = {},
    }
  end,
}
