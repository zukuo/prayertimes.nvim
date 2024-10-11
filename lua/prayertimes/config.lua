local M = {}

M.options = {}

local defaults = {
    location = {
        country = "GB",
        city = "London",
    },
    method = 15,
    shown_prayers = {
        fajr = true,
        dhuhr = true,
    },
    gui = {
        alt_clock_format = false,
        enable_prayer_emojis = false,
    }
}

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", defaults, opts or {})
    vim.api.nvim_create_user_command("Prayertimes", function () require("prayertimes.popup").show_prayertimes() end, {})
end

return M
