local M = {}

function M.get_current_time(hr_type)
    return os.date("%H:%M")
end

function M.get_current_date(hr_type)
    return os.date("%a")
end

function M.pad_text(text)
    return " " .. text .. " "
end

M.prayers = {
    "Fajr",
    "Sunrise",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha",
    "Midnight",
}

M.times = {
    ["Fajr"] = "00:00",
    ["Sunrise"] = "00:00",
    ["Dhuhr"] = "00:00",
    ["Asr"] = "00:00",
    ["Maghrib"] = "00:00",
    ["Isha"] = "00:00",
    ["Midnight"] = "00:00",
}

function M.generate_time_items()

end

return M
