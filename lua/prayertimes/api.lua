local M = {}

local curl = require("plenary.curl")

function M.get_current_time(hr_type)
    return os.date("%H:%M")
end

function M.get_current_date(hr_type)
    return os.date("%a")
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

function M.update_times()
    local today = os.date("%d-%m-%Y")
    local base = "http://api.aladhan.com/v1/timingsByCity/"
    local query = "?city=Cambridge&country=GB"

    local res = curl.get {
        url = base .. today .. query,
        accept = "application/json",
    }

    local data = vim.fn.json_decode(res.body).data

    for _, prayer in pairs(M.chosen_prayers) do
        M.times[prayer] = data.timings[prayer]
    end
end

return M
