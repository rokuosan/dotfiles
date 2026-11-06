local function local_oxc_cmd(name)
  return function(dispatchers, config)
    local executable = vim.fs.find("node_modules/.bin/" .. name, { path = config.root_dir, upward = true })[1] or name
    return vim.lsp.rpc.start({ executable, "--lsp" }, dispatchers)
  end
end

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
        cmd = local_oxc_cmd "oxlint",
        settings = {
          fixKind = "safe_fix",
        },
      },
      oxfmt = { cmd = local_oxc_cmd "oxfmt" },
    },
    formatting = {
      filter = function(client)
        local has_oxfmt = vim
          .iter(vim.lsp.get_clients { bufnr = 0 })
          :any(function(attached_client) return attached_client.name == "oxfmt" end)

        return not has_oxfmt or client.name == "oxfmt"
      end,
    },
  },
}
