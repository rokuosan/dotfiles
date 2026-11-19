rex.action{
  name = "ghq_repository",
  title = "Open ghq Repository…",
  run = function(ctx)
    local result, err = rex.exec({
      "zsh", "-lic", "ghq root --all && printf '\\n' && ghq list --full-path",
    })
    if not result or not result.ok then
      error(err or result.stderr, 0)
    end

    local roots, paths = result.stdout:match("^(.-)\n\n(.*)$")
    if not roots then error("Could not read ghq roots", 0) end

    local root_prefixes = {}
    for root in roots:gmatch("[^\n]+") do
      if root:sub(1, 1) == "/" then
        root_prefixes[#root_prefixes + 1] = root:gsub("/+$", "") .. "/"
      end
    end
    table.sort(root_prefixes, function(a, b) return #a > #b end)

    local items = {}
    local labels = {}
    for path in paths:gmatch("[^\n]+") do
      local label
      for _, prefix in ipairs(root_prefixes) do
        if path:sub(1, #prefix) == prefix then
          label = path:sub(#prefix + 1)
          break
        end
      end
      if label and not labels[path] then
        items[#items + 1] = {
          id = path,
          title = label,
          subtitle = path,
          icon = "folder",
        }
        labels[path] = label
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

    local label = labels[path]
    local sessions, list_error = rex.call("session.list")
    if not sessions then error(list_error, 0) end

    local session_id
    for _, session in ipairs(sessions.sessions) do
      if session.label == label then
        session_id = session.session_id
        break
      end
    end

    local layout = rex.layout.block{
      flavor = "com.superlogical.terminal.shell",
      options = { cwd = path },
    }
    local window_id
    if session_id then
      if session_id ~= ctx.session_id then
        local attached, attach_error = rex.call("session.attach", { session_id = session_id })
        if not attached then error(attach_error, 0) end
      end
      local window, open_error = rex.session.new_window{
        session_id = session_id,
        focus = true,
        layout = layout,
      }
      if not window then error(open_error, 0) end
      window_id = window.window_id
    else
      local session, create_error = rex.call("session.create", {
        label = label,
        initial_windows = { { layout = layout } },
      })
      if not session then error(create_error, 0) end
      session_id = session.session_id
      window_id = session.initial_windows[1].window_id
    end

    if ctx.client_id then
      rex.client.queue("session.select", {
        session_id = session_id,
        window_id = window_id,
      })
    end
  end,
}

rex.bind("alt+cmd+g", "ghq_repository")
