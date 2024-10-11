local M = {}

function M.show_prayertimes()
    -- Import Nui Components (Popup)
    local Popup = require("nui.popup")
    local NuiText = require("nui.text")
    local NuiLine = require("nui.line")
    local event = require("nui.utils.autocmd").event

    -- Import prayertimes.nvim files
    local api = require("prayertimes.api")
    local config = require("prayertimes.config").options

    -- Get latest prayer times
    api.update_times()

    local hijri_date = api.data.date.hijri.date
    local hijri_date_short = string.sub(hijri_date, 1, #hijri_date - 5):gsub("-", "/")

    local title = "Prayer Times - " .. hijri_date_short
    local footer = string.format("%s - %s", config.location.city, api.get_current_date())
    local width, height = math.max(#title + 4, #footer + 4), #api.chosen_prayers

    -- Define Popup Settings
    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = api.pad_text(title),
                top_align = "center",
                bottom = api.pad_text(footer),
                bottom_align = "center",
            },
            padding = {
                top = 0,
                bottom = 0,
                left = 1,
                right = 1,
            },
        },
        position = "50%",
        size = {
            width = width,
            height = height,
        },
    })

    -- Popup Handlers
    popup:mount()

    popup:on(event.BufLeave, function()
        popup:unmount()
    end)

    popup:map("n", "<esc>", function()
        popup:unmount()
    end, { noremap = true })

    popup:map("n", "q", function()
        popup:unmount()
    end, { noremap = true })

    -- Draw Prayer & Times to Buffer
    for index, prayer in pairs(api.chosen_prayers) do
        local num_of_spaces = width - #prayer - #api.times[prayer]
        local line_content = prayer .. string.rep(" ", num_of_spaces) .. api.times[prayer]
        local prayer_with_time = NuiLine({ NuiText(line_content) })
        prayer_with_time:render(popup.bufnr, -1, index)
    end
end

return M
