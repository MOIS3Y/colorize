# colorize

A small library for working with colors and their fine-tuning HSL
contains 35 pre-configured color schemes in base16 format.


Written in Lua specifically for [AWESOME WM](https://awesomewm.org/)

> This is an adaptation of the base16_colorlib library that I wrote in Python3
> primarily for use in the Qtile window manager configuration.
> [base16_colorlib](https://github.com/MOIS3Y/base16-colorlib)
> There you can see a list of all available color schemes and their codes in base16


## What is this for?

- If you write an AwesomeWM configuration and then want to switch between color
  schemes on the fly
- You need to do hover effects for buttons or widgets when the color changes slightly
- Allows you to standardize the color scheme and quickly 
  add new colors to the configuration that will not be tied to a specific color scheme
- You are looking for a solution to convert colors between different color models
- ...???


## Content:
### The package contains three modules:
- **color.lua**
- **colors.lua**
- **colorsys.lua**


### colors.lua:

The module contains several ready-made color schemes in base16 format.

Color schemes adhere to all colors that are declared by the authors,
however, they may differ slightly, including in the order of colors.
If you think the order or shade of your favorite color scheme is different
feel free to make changes.
I based this collection on a selection of color schemes
from the NVchad repository:
[NVchad themes](https://github.com/NvChad/base46/tree/v2.0/lua/base46/themes)

- Each color scheme is a table with a common structure:

```lua
    {
        ["catppuccin_mocha"] = {
            scheme = "catppuccin_mocha",
            author = "https://github.com/catppuccin/catppuccin",
            base00 = "#11111b",
            base01 = "#1e1e2e",
            base02 = "#313244",
            base03 = "#45475a",
            base04 = "#585b70",
            base05 = "#cdd6f4",
            base06 = "#f5e0dc",
            base07 = "#b4befe",
            base08 = "#f38ba8",
            base09 = "#fab387",
            base0A = "#f9e2af",
            base0B = "#a6e3a1",
            base0C = "#94e2d5",
            base0D = "#89b4fa",
            base0E = "#cba6f7",
            base0F = "#f2cdcd",
        },  -- ...
    }
```

### colorsys.lua
The module contains functions for color conversion.
It somewhat repeats the functionality of the standard Python3 colorsys lib
Its main purpose is to convert hex color to hsl and vice versa

HSL makes it possible to flexibly adjust color in three directions:
hue, saturation, lightness

If you only need conversion functions, it can be used in your code
as a separate module.

- The module returns a table with functions:
```lua
	{
		hex2hsl,
		hex2rgb,
		hsl2hex,
		hsl2rgb,
		rgb2hex,
		rgb2hsl,
		_hue2rgb,  -- helper function for internal use
	}
```
>RGB values ​​are returned between 0 - 1

>If you need to get the usual value, multiply each element by 255
> - rgb[1] * 255
> - rgb[2] * 255
> - rgb[3] * 255


### color.lua
This class is intended to be stored in an attribute
Color.scheme color scheme in base16 format
[base16](https://github.com/chriskempson/base16)

And its subsequent use to set the color for various elements.
Since there are only 16 colors in base16, sometimes this is not enough to
place color accents anywhere.
Therefore, the class has several methods for adjusting the color.

The HSL color model is used here.

|     |            |                          |
| --- | ---------- | ------------------------ |
| H   | Hue        | position in the spectrum |
| S   | Luminance  | color saturation         |
| L   | Saturation | color lightness          |


You are probably familiar with it, if not, it's best to just see how
you can change the color by changing one of the parameters,
for example here: [hslpicker](https://hslpicker.com/)

Each channel has its own method which accepts a color and a ratio
offsets:

```lua
Color:hue(color, shift)
Color:saturation(color, shift)
Color:lightness(color, shift)
```

For saturation, lightness, the shift argument takes the offset percentage
relative to the current color **(-100, 100)**, if you pass a percentage
that will go beyond frame, then the parameter being changed will take
the maximum or minimum possible value.
For hue, the absolute value of the degree that H can
be changed this channel **(-360, 360)**.


## How to use it?

- clone the repository to the configuration directory or where you store modules
```
git clone https://github.com/MOIS3Y/colorize.git ~/.config/awesome/colorize
```

- import the package into the configuration

```lua
local colorize = require("colorize")
```

### Example:

```lua
-- In theme.lua module:

local colorize = require("colorize")

local color_scheme = colorize.colors.catppuccin_mocha

local color = colorize.Color:new(color_scheme)

local theme = {}
-- bg\

theme.bg_normal = color.scheme.base00  -- black
theme.bg_focus  = color.scheme.base0D  -- blue
theme.bg_urgent = color.scheme.base08  -- red

-- border\
theme.border_marked = color:lightness(color.scheme.base08, 20)
-- the code in the line above will make the red color lighter by 20 points
-- it doesn't matter if you change the color scheme in the future,
-- the color code is base08 will always be 20 points lighter
```

```lua
-- button widget definition above:)

-- hover effect:
btn:connect_signal(
    "mouse::enter",
    function(c)
        -- red color darker by 20 points 
        c:set_bg(color:lightness(color.scheme.base08, -20)) 
    end
)
btn:connect_signal(
    "mouse::leave",
    function(c)
        -- normalize color
        c:set_bg(color.scheme.base08) 
    end
)
```

```lua
-- by analogy, you can change hue and saturation:
local foo = color:hue(color.scheme.base08, -5)
local bar = color:saturation(color.scheme.base08, 17)
```

## License

MIT