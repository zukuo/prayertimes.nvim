local M = {}

function M.show_prayertimes()
    local prayer_and_times = {
        ["Fajr"] = "0",
        ["Sunrise"] = "0",
        ["Dhuhr"] = "0",
        ["Asr"] = "0",
        ["Maghrib"] = "0",
        ["Isha"] = "0",
        ["Midnight"] = "0",
    }
    local location = "Cambridge, UK"

    local Popup = require("nui.popup")
    local NuiText = require("nui.text")
    local NuiLine = require("nui.line")
    local event = require("nui.utils.autocmd").event

    local current_time = os.date("*t").hour .. ":" .. os.date("*t").min
    local title = "Prayer Times - " .. current_time

    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = " " .. title .. " ",
                top_align = "center",
                bottom = " " .. location .. " ",
                bottom_align = "center",
            }
        },
        position = "50%",
        size = {
            width = 30,
            height = 10,
        },
    })

    popup:mount()
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)

    popup:map("n", "<esc>", function()
        popup:unmount()
    end, { noremap = true })

    -- set content
    local linenr_start = 1
    for prayer, time in pairs(prayer_and_times) do
        local prayer_with_time = NuiLine({ NuiText(prayer .. " - " .. time) })
        prayer_with_time:render(popup.bufnr, -1, linenr_start)
        linenr_start = linenr_start + 1
    end
end

function M.setup(opts)
    opts = opts or {}
    vim.keymap.set("n", "<leader>pt", function() M.show_prayertimes() end)
end

return M
