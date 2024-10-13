local M = {}

M.options = {}

local defaults = {
    location = {
        country = "GB",
        city    = "London",
    },

    method = 15,
    later_asr = false,

    shown_prayers = {
        imsak = false,
        fajr = true,
        sunrise = true,
        dhuhr = true,
        asr = true,
        maghrib = true,
        sunset = false,
        isha = true,
        midnight = true,
        firstthird = false,
        lastthird = false,
    },

    tune = {
        imsak    = 0,
        fajr     = 0,
        sunrise  = 0,
        dhuhr    = 0,
        asr      = 0,
        maghrib  = 0,
        sunset   = 0,
        isha     = 0,
        midnight = 0,
    },

    gui = {
        alt_clock_format = false,
    }
}

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", defaults, opts or {})
    vim.api.nvim_create_user_command(
        "Prayertimes",
        function() require("prayertimes.popup").show_prayertimes() end,
        { nargs = 0 }
    )
end

return M
