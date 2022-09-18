

local M = {}

function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end


function M.paste_img()
    local Input = require("nui.input")
    local event = require("nui.utils.autocmd").event

    local popup_options = {
    relative = "cursor",
    position = {
        row = 1,
        col = 0,
    },
    size = 20,
    border = {
        style = "rounded",
        text = {
        top = "[Input]",
        top_align = "left",
        },
    },
    win_options = {
        winhighlight = "Normal:Normal",
    },
    }

    local input = Input(popup_options, {
    prompt = "> ",
    default_value = "",
    on_close = function()
        print("Input closed!")
    end,
    on_submit = function(value)
        print("Value submitted: ", value)
        vim.fn.mkdir("img","p")
        local stdPath = vim.fn.stdpath("data")
        local installPath = stdPath .. "/site/pack/packer/start/md-image-paste"
        local ret = os.capture("bash "..  installPath .."/getimg.sh")
        if ret == "noimg" then
            print("noimg")
            return
        end
        local api = vim.api
        

        api.nvim_command("!mv /tmp/rcopy/test.png ./img/".. value .. ".png")
        local pos = api.nvim_win_get_cursor(0)
        api.nvim_command("normal! a!["..value .. "](img/"..value..".png)")
        local line, col = unpack(pos)
        api.nvim_win_set_cursor(0,{line,col+2})
        api.nvim_command("normal! vt]\\<C-g>")
    end,
    on_change = function(value)
        print("Value changed: ", value)
    end,
    })
    -- mount/open the component
    input:mount()

    -- unmount component when cursor leaves buffer
    input:on(event.BufLeave, function()
        input:unmount()
    end)
end


function M.setup(user_config)

    require('md-image-paste.commands').setup()
end


return M