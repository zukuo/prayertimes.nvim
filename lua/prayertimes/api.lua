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
    for _, tune_name in pairs(M.tune_names) do
        list = list .. M.tune[tune_name] .. ","
    end
    return list
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

M.tune_names = {
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
    Fajr     = "00:00",
    Sunrise  = "00:00",
    Dhuhr    = "00:00",
    Asr      = "00:00",
    Maghrib  = "00:00",
    Isha     = "00:00",
    Midnight = "00:00",
}

M.tune = {
    Imsak    = config.tune.imsak,
    Fajr     = config.tune.fajr,
    Sunrise  = config.tune.sunrise,
    Dhuhr    = config.tune.dhuhr,
    Asr      = config.tune.asr,
    Maghrib  = config.tune.maghrib,
    Sunset   = config.tune.sunset,
    Isha     = config.tune.isha,
    Midnight = config.tune.midnight,
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

function M.update_times()
    M.data = M.get_aladhan_times()
    for _, prayer in pairs(M.chosen_prayers) do
        M.times[prayer] = M.data.timings[prayer]
    end
end

return M
