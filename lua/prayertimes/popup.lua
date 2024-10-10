local M = {}

function M.show_prayertimes()
    -- Import Nui Components (Popup)
    local Popup = require("nui.popup")
    local NuiText = require("nui.text")
    local NuiLine = require("nui.line")
    local event = require("nui.utils.autocmd").event

    -- Import prayertimes.nvim API and set vars
    local api = require("prayertimes.api")
    local title = "Prayer Times - " .. api.get_current_time()
    local footer = "Cambridge, UK - " .. api.get_current_date()
    local width, height = 25, #api.chosen_prayers

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

    -- Draw Prayer & Times to Buffer
    api.update_times()
    for index, prayer in pairs(api.chosen_prayers) do
        local num_of_spaces = width - #prayer - #api.times[prayer]
        local line_content = prayer .. string.rep(" ", num_of_spaces) .. api.times[prayer]
        local prayer_with_time = NuiLine({ NuiText(line_content) })
        prayer_with_time:render(popup.bufnr, -1, index)
    end
end

return M
