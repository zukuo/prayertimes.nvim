local curl = require("plenary.curl")
local config = require("prayertimes.config").options

local M = {}

function M.get_current_date(hr_type)
    return os.date("%d %b")
end

function M.pad_text(text)
    return " " .. text .. " "
end

function M.format_lower(text)
    return text:lower():gsub("%s+", "")
end

function M.format_titlecase(text)
    return text:lower():gsub("%s+", ""):gsub("^%l", string.upper)
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
    Imsak           = "00:00",
    Fajr            = "00:00",
    Sunrise         = "00:00",
    Dhuhr           = "00:00",
    Asr             = "00:00",
    Maghrib         = "00:00",
    Sunset          = "00:00",
    Isha            = "00:00",
    Midnight        = "00:00",
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
        local formatted_prayer = M.format_lower(shown_prayer)
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
        local clean_prayer = M.format_titlecase(prayer)
        M.times[prayer] = M.data.timings[clean_prayer]
    end
end

function M.color_current_prayer(prayer)
    local to_color = ""
    local time = os.date("%H:%M")

    for i = 1, #M.shown_prayers - 1, 1 do
        if M.data.timings[M.format_titlecase(M.shown_prayers[i])] <= time and time < M.data.timings[M.format_titlecase(M.shown_prayers[i + 1])] then
            to_color = M.shown_prayers[i]
        end
    end

    if prayer == to_color then
        return "String"
    else
        return ""
    end
end

function M.convert_to_12hr(time)
    local hour = tonumber(time:sub(1, 2))
    local minute = time:sub(4, 5)
    local am, pm = "am", "pm"

    if hour < 12 then
        minute = minute .. am
    elseif hour == 12 then
        minute = minute .. pm
    else
        hour = hour - 12
        minute = minute .. pm
    end

    return hour .. ":" .. minute
end

return M
