<!-- panvimdoc-ignore-start -->

<h1 align="center">
🕌 prayertimes.nvim
</h1>

<div align="center">
  <div>Get accurate Islamic prayer times in your editor.</div><br />
  <img width="700" alt="prayertimes-popup" src="https://github.com/user-attachments/assets/f0da8a6a-c154-44f1-9663-226c0be9f27a">

</div>

<!-- panvimdoc-ignore-end -->

## ✨ Features

- Clean and minimal popup window that displays prayer times
- Use a wide range of different calculation methods
- Individually finetune each prayer time to match your local area
- Customise the look and feel of what you want to be displayed

## ⚡ Requirements

- Neovim >= [v0.5.0](https://github.com/neovim/neovim/releases/tag/v0.10.0)

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
   "zukuo/prayertimes.nvim",
   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
   lazy = true,
   opts = {
      location = { -- set a country name or 2 character alpha ISO 3166 code 
         country = "GB", 
         city = "London",
      }
      -- add more config here
      -- or leave empty for defaults
   }
   keys = {
       { "<leader>pt", "<cmd>Prayertimes<cr>", desc = "Show Prayer Times" },
   },
},
```

## 🚀 Usage

### 🕰️ `:Prayertimes` 

Shows the prayer times for the current day, with respect to the given location.

## 🔧 Configuration

Prayertimes comes with the following defaults:

```lua
{
    location = {
        country = "GB", -- a country name or 2 character alpha ISO 3166 code
        city    = "London", -- name of your city
    },
    method = 15, -- check out [Calculation Methods] for more details
    later_asr = false, -- choose between the later Asr (Hanafi) or earlier asr (Shafi, Hanbali, Maliki)
    shown_prayers = { -- choose which prayers to show on the popup
        imsak = false,
        fajr = true,
        sunrise = true,
        dhuhr = true,
        asr = true,
        maghrib = true,
        sunset = false,
        isha = true,
        midnight = true,
        firstthird = false,
        lastthird = false,
    },
    tune = { -- add or subtract minutes for each prayer time
        imsak    = 0,
        fajr     = 0,
        sunrise  = 0,
        dhuhr    = 0,
        asr      = 0,
        maghrib  = 0,
        sunset   = 0,
        isha     = 0,
        midnight = 0,
    },
    gui = {
        alt_clock_format = false, -- change between 12-hour (alt) and 24-hour (default) clock format
        backdrop = true, -- enable a darkened backdrop behind the times popup
    }
}
```

### 📏 Calculation Methods

Since Prayertimes uses the [AlAdhan Prayer Times API](https://aladhan.com/prayer-times-api) under the hood, the methods they use are also applicable here.

Below are all of the compatible methods used for calculating the prayer times.

- 0 - Jafari / Shia Ithna-Ashari
- 1 - University of Islamic Sciences, Karachi
- 2 - Islamic Society of North America
- 3 - Muslim World League
- 4 - Umm Al-Qura University, Makkah
- 5 - Egyptian General Authority of Survey
- 7 - Institute of Geophysics, University of Tehran
- 8 - Gulf Region
- 9 - Kuwait
- 10 - Qatar
- 12 - Majlis Ugama Islam Singapura, Singapore
- 12 - Union Organization islamic de France
- 13 - Diyanet İşleri Başkanlığı, Turkey
- 14 - Spiritual Administration of Muslims of Russia
- 15 - Moonsighting Committee Worldwide
- 16 - Dubai
- 17 - Jabatan Kemajuan Islam Malaysia (JAKIM)
- 18 - Tunisia
- 19 - Algeria
- 20 - KEMENAG - Kementerian Agama Republik Indonesia
- 21 - Morocco
- 22 - Comunidade Islamica de Lisboa
- 23 - Ministry of Awqaf, Islamic Affairs and Holy Places, Jordan
