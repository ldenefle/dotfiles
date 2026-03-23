-- ~/.config/jjui/config.lua
function setup(config)

  config.action("diff.move_down", function()
    jjui.ui.preview_scroll_down()
  end, {desc= "diff move down", key ="ctrl+e", scope = "revisions"} )
  config.action("diff.move_up", function()
    jjui.ui.preview_scroll_up()
  end, {desc= "diff move up", key ="ctrl+y", scope = "revisions"} )

  config.action("diff.move_page_up", function()
    jjui.ui.preview_half_page_up()
  end, {desc= "diff move page up", key ="ctrl+b", scope = "revisions"} )

  config.action("diff.move_page_down", function()
    jjui.ui.preview_half_page_down()
  end, {desc= "diff move page down", key ="ctrl+f", scope = "revisions"} )

  config.action("show diff in diffnav", function()
    local change_id = context.change_id()
    if not change_id or change_id == "" then
      flash({ text = "No revision selected", error = true })
      return
    end

    exec_shell(string.format("jj diff -r %q --git --color always | diffnav", change_id))
  end, { desc = "show diff in diffnav", key = "ctrl+d", scope = "revisions" })

  config.action("edit file", function()
    local function first_hunk_new_lineno(git_diff)
      for line in git_diff:gmatch("[^\n]+") do
        if line:sub(1, 3) == "@@ " then
          local new_start = line:match("%+(%d+)")
          if new_start then
            return tonumber(new_start)
          end
        end
      end
      return nil
    end

    local diff = jj("diff", "--git", "-r", context.change_id(), context.file())
    local line_number = first_hunk_new_lineno(diff)
    exec_shell(string.format("nvim +%q %q", line_number, context.file()))
  end, {
    scope = "revisions.details",
    key = "e",
  })
end
