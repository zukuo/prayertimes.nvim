local curl = require("plenary.curl")
local config = require("prayertimes.config").options

local M = {}

function M.get_current_time(hr_type)
    return os.date("%H:%M")
end

function M.get_current_date(hr_type)
    return os.date("%d %b")
end

function M.pad_text(text)
    return " " .. text .. " "
end

M.chosen_prayers = {
    "Fajr",
    "Sunrise",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha",
    "Midnight",
}

M.times = {
    Fajr = "00:00",
    Sunrise = "00:00",
    Dhuhr = "00:00",
    Asr = "00:00",
    Maghrib = "00:00",
    Isha = "00:00",
    Midnight = "00:00",
}

M.data = {}

function M.get_aladhan_times()
    local today = os.date("%d-%m-%Y")
    local base = "http://api.aladhan.com/v1/timingsByCity/"
    local country, city, method = config.location.country, config.location.city, config.method
    local query = string.format("?country=%s&city=%s&method=%d", country, city, method)
    -- local tune = "&tune=0,-1,-1,4,-3,3,0,1,0"

    local res = curl.get {
        url = base .. today .. query,
        accept = "application/json",
        timeout = 2000,
    }

    return vim.fn.json_decode(res.body).data
end

function M.update_times()
    M.data = M.get_aladhan_times()
    for _, prayer in pairs(M.chosen_prayers) do
        M.times[prayer] = M.data.timings[prayer]
    end
end

return M
