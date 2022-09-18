local M = {}

function M.setup()
    vim.cmd("command! PasteImg      lua require('md-image-paste').paste_img()")
end

return M