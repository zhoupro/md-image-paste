local M = {}

function M.setup()
    vim.cmd("command! PasteImg      lua require('prozhou').paste_img()")
end

return M