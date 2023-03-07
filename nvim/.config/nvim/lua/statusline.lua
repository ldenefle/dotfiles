-- Add color to the whole statusline
function StatusLineColor(mode)
    if mode == 'NORMAL' then
        return '%#BlueBg#'
    elseif mode == 'INSERT' then
        return '%#GreenBg#'
    elseif mode == 'VISUAL' or mode == 'V-LINE' or mode == 'V-BLOCK' then
        return '%#OrangeBg#'
    elseif mode == 'COMMAND' or mode == 'SEARCH' then
        return '%#PinkBg#'
    end
    return '%#BlueBg#'
end

-- Returns the vim mode
function CursorMode()
    local mode_map = {
        ['n'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['V'] = 'V-LINE',
        [''] = 'V-BLOCK',
        ['i'] = 'INSERT',
        ['R'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['c'] = 'COMMAND',
        ['t'] = 'SEARCH',
    }
    local current_mode = mode_map[vim.fn.mode()]
    if current_mode == nil then
        return 'Unhandled' .. vim.fn.mode()
    end

    return current_mode
end

function StatusLine()
    local status = ''

    -- left side
    status = status .. StatusLineColor(CursorMode())
    status = status .. [[ %-{luaeval("CursorMode()")}]]
    status = status .. [[ %#Normal# ]]
    status = status .. [[ %-t %-m %-r ]]

    -- right side
    status = status .. [[ %= %c %l/%L]]

    return status
end


-- Status line
vim.o.showmode = false
vim.o.laststatus = 2
vim.o.statusline = '%!luaeval("StatusLine()")'
vim.api.nvim_set_hl(0, 'BlueBg', { bg = '#59c2ee', fg='black'})
vim.api.nvim_set_hl(0, 'GreenBg', { bg = "#BAE67E" , fg='black'})
vim.api.nvim_set_hl(0, 'OrangeBg', { bg = "#FFA759" , fg='black'})
vim.api.nvim_set_hl(0, 'PinkBg', { bg = "#FFB454", fg='black'})
