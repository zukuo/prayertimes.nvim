local M = {}

function M.setup(opts)
    opts = opts or {}
    vim.keymap.set("n", "<leader>pt", function() require("prayertimes.popup").show_prayertimes() end)
end

return M
