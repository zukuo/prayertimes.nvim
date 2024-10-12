local curl = require("plenary.curl")
local config = require("prayertimes.config").options

local M = {}

function M.get_current_date(hr_type)
    return os.date("%d %b")
end

function M.pad_text(text)
    return " " .. text .. " "
end

function M.make_tune_list()
    local list = ""
    for _, tune in pairs(M.tune) do
        list = list .. config.tune[string.lower(tune)] .. ","
    end
    return list
end

M.shown_prayers = {
    "Imsak",
    "Fajr",
    "Sunrise",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Sunset",
    "Isha",
    "Midnight",
    "First Third",
    "Last Third",
}

M.tune = {
    "Imsak",
    "Fajr",
    "Sunrise",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Sunset",
    "Isha",
    "Midnight",
}

M.times = {
    Imsak          = "00:00",
    Fajr           = "00:00",
    Sunrise        = "00:00",
    Dhuhr          = "00:00",
    Asr            = "00:00",
    Maghrib        = "00:00",
    Sunset         = "00:00",
    Isha           = "00:00",
    Midnight       = "00:00",
    ["First Third"] = "00:00",
    ["Last Third"]  = "00:00",
}

M.queries = {
    country = config.location.country,
    city    = config.location.city,
    method  = config.method,
    school  = (config.later_asr and 1 or 0),
    tune    = M.make_tune_list(),
}

M.data = {}

function M.get_aladhan_times()
    local url = "http://api.aladhan.com/v1/timingsByCity/" .. os.date("%d-%m-%Y?")

    for query, value in pairs(M.queries) do
        url = string.format("%s%s=%s&", url, query, value)
    end

    local res = curl.get {
        url = url,
        accept = "application/json",
        timeout = 2000,
    }

    return vim.fn.json_decode(res.body).data
end

function M.update_shown_prayers()
    local new_list = {}
    for _, shown_prayer in pairs(M.shown_prayers) do
        local formatted_prayer = shown_prayer:lower():gsub("%s+", "")
        if config.shown_prayers[formatted_prayer] then
            table.insert(new_list, shown_prayer)
        end
    end
    M.shown_prayers = new_list
end

function M.update_times()
    M.update_shown_prayers()
    M.data = M.get_aladhan_times()
    for _, prayer in pairs(M.shown_prayers) do
        local clean_prayer = prayer:lower():gsub("%s+", ""):gsub("^%l", string.upper)
        M.times[prayer] = M.data.timings[clean_prayer]
    end
end

return M
