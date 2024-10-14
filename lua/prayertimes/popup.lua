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

    -- Dark Backdrop
    vim.api.nvim_set_hl(0, "DarkBackdrop", { bg = "#000000", default = true })
    local backdrop = Popup({
        enter = false,
        focusable = false,
        position = "100%",
        size = {
            height = "100%",
            width = "100%",
        },
        border = 'none',
        win_options = {
            winblend = 60,
            winhighlight = "Normal:DarkBackdrop"
        },
    })
    if config.gui.backdrop then
        backdrop:mount()
    end

    -- Get latest prayer times
    api.update_times()

    local hijri_date = api.data.date.hijri.date
    local hijri_date_short = string.sub(hijri_date, 1, #hijri_date - 5):gsub("-", "/")

    local title = "Prayer Times - " .. hijri_date_short
    local footer = string.format("%s - %s", config.location.city, api.get_current_date())
    local width, height = math.max(#title + 4, #footer + 4), #api.shown_prayers

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
        backdrop:unmount()
    end)

    popup:map("n", "<esc>", function()
        popup:unmount()
        backdrop:unmount()
    end, { noremap = true })

    popup:map("n", "q", function()
        popup:unmount()
        backdrop:unmount()
    end, { noremap = true })

    -- Draw Prayer & Times to Buffer
    for index, prayer in pairs(api.shown_prayers) do
        local time = (config.gui.alt_clock_format and api.convert_to_12hr(api.times[prayer]) or api.times[prayer])
        local num_of_spaces = width - #prayer - #time
        local line_content = prayer .. string.rep(" ", num_of_spaces) .. time
        local prayer_with_time = NuiLine({ NuiText(line_content, api.color_current_prayer(prayer)) })
        prayer_with_time:render(popup.bufnr, -1, index)
    end
end

return M
