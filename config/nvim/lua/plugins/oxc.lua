local function local_oxc_cmd(name, subcommand)
  return function(dispatchers, config)
    local vp = vim.fs.find("node_modules/.bin/vp", { path = config.root_dir, upward = true })[1]
    if vp then return vim.lsp.rpc.start({ vp, subcommand, "--lsp" }, dispatchers) end

    local executable = vim.fs.find("node_modules/.bin/" .. name, { path = config.root_dir, upward = true })[1] or name
    return vim.lsp.rpc.start({ executable, "--lsp" }, dispatchers)
  end
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      oxlint = {
        workspace_required = true,
        cmd = local_oxc_cmd("oxlint", "lint"),
        settings = { fixKind = "safe_fix" },
      },
      eslint = { settings = { format = false } },
    },
  },
}
