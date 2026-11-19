rex.action{
  name = "ghq_repository",
  title = "Open ghq Repository…",
  run = function(ctx)
    local result, err = rex.exec({ "zsh", "-lic", "ghq list --full-path" })
    if not result or not result.ok then
      error(err or result.stderr, 0)
    end

    local items = {}
    local seen = {}
    for path in result.stdout:gmatch("[^\n]+") do
      if path:sub(1, 1) == "/" and not seen[path] then
        items[#items + 1] = {
          id = path,
          title = path:match("[^/]+$") or path,
          subtitle = path,
          icon = "folder",
        }
        seen[path] = true
        if #items == 2000 then break end
      end
    end

    local path, reason, detail = rex.ui.pick{
      title = "Open ghq Repository",
      placeholder = "Filter repositories",
      items = items,
    }
    if not path then
      if reason == "cancelled" or reason == "timeout" then return end
      error(detail or reason, 0)
    end

    local window, open_error = rex.session.new_window{
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = { cwd = path },
      },
    }
    if open_error then error(open_error, 0) end
    if ctx.client_id then
      rex.client.queue("session.select", {
        session_id = ctx.session_id,
        window_id = window.window_id,
      })
    end
  end,
}

rex.bind("alt+cmd+g", "ghq_repository")
