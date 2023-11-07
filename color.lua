-- █▀▀ █▀█ █░░ █▀█ █▀█ ▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄ ▄
-- -- -- -- -- -- -- --

--[[
    This class is intended to be stored in an attribute
    Color.scheme color scheme in base16 format
    https://github.com/chriskempson/base16
    And its subsequent use to set the color for various elements.
    Since there are only 16 colors in base16, sometimes this is not enough to
    place color accents anywhere.
    Therefore, the class has several methods for adjusting the color.
    The HSL color model is used here.
        HLS: Hue, Luminance, Saturation
            H: position in the spectrum
            S: color saturation
            L: color lightness
    You are probably familiar with it, if not, it's best to just see how
    you can change the color by changing one of the parameters,
    for example here:
    https://hslpicker.com/
    Each channel has its own method which accepts a color and a ratio
    offsets:
        Color:hue(color, shift)
        Color:saturation(color, shift)
        Color:lightness(color, shift)

    For saturation, lightness, the shift argument takes the offset percentage
    relative to the current color (-100, 100), if you pass a percentage
    that will go beyond frame, then the parameter being changed will take
    the maximum or minimum possible value.
    For hue, the absolute value of the degree that H can
    be changed this channel (-360, 360).

        Examples:
        -- -- --
        color_scheme = some_base16_theme  -- table

        local color = Color:new(color_scheme)

        local shift_color = color.scheme["base08"]          => #b4befe

        hue_color = Color:hue(shift_color, -60)             => #b4fef4

        saturation = Color:saturation(shift_color, 20)      => #b3bdff

        lightness_color = Color:lightness(shift_color, 20)  => #e6eaff
]]

-- Imports
local colors   = require(tostring(...):match(".*colorize") .. ".colors")
local colorsys = require(tostring(...):match(".*colorize") .. ".colorsys")


-- Color class
local _M = {}

-- Init new Color class object
-- @color_scheme is table some_base16_theme
function _M:new(color_scheme)

    -- PROPERTIES:

    local obj = {}
        obj.scheme = color_scheme or colors["catppuccin_mocha"]  -- default

    -- METHODS:

    -- Just print stored color schema in cls instance
    -- Defaul catppuccin mocha
    -- Sequence order is not guaranteed :)
    function obj:print()
        for base_name, color in pairs(obj.scheme) do
            print(base_name, color)
        end
    end

    -- internal function ensures that the shift
    -- does not go beyond the 0-360 range
    function obj._check_range_0_360 (channel)
        if channel < 0 then
            return 0
        elseif channel > 360 then
            return 360
        else
            return channel
        end
    end

    -- internal function ensures that the shift
    -- does not go beyond the 0-1 range
    function obj._check_range_0_1 (channel)
        if channel < 0 then
            return 0
        elseif channel > 1 then
            return 1
        else
            return channel
        end
    end

    -- hue shift
    -- @color = string #ffffff
    -- @shift = integer range +100 -100
    function obj:hue (color, shift)
        local hsl = colorsys:hex2hsl(color)
        local h = hsl[1]
        if shift < 0 then
            hsl[1] = self._check_range_0_360(h - math.abs(shift))
        else
            hsl[1] = self._check_range_0_360(h + shift)
        end
        return colorsys:hsl2hex(hsl)
    end

    -- saturation shift
    -- @color = string #ffffff
    -- @shift = integer range +100 -100
    function obj:saturation (color, shift)
        local hsl = colorsys:hex2hsl(color)
        local s = hsl[2]
        if shift < 0 then
            hsl[2] = self._check_range_0_1(s - (math.abs(shift) / 100))
        else
            hsl[2] = self._check_range_0_1(s + (shift / 100))
        end
        return colorsys:hsl2hex(hsl)
    end

    -- lightness shift
    -- @color = string #ffffff
    -- @shift = integer range +100 -100
    function obj:lightness (color, shift)
        local hsl = colorsys:hex2hsl(color)
        local l = hsl[3]
        if shift < 0 then
            hsl[3] = self._check_range_0_1(l - (math.abs(shift) / 100))
        else
            hsl[3] = self._check_range_0_1(l + (shift / 100))
        end
        return colorsys:hsl2hex(hsl)
    end


    -- INIT CLASS
    setmetatable(obj, self)
    self.__index = self; return obj
end


return _M
