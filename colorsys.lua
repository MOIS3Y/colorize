-- █▀▀ █▀█ █░░ █▀█ █▀█ █▀ █▄█ █▀ ▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄ ▄█ ░█░ ▄█ ▄
-- -- -- -- -- -- -- -- -- -- -- -

--[[
	The module contains functions for color conversion.
	It somewhat repeats the functionality of the standard Python3 colorsys lib
	Its main purpose is to convert hex color to hsl and vice versa
	HSL makes it possible to flexibly adjust color in three directions:
	hue, saturation, lightness
	If you only need conversion functions, it can be used in your code
	as a separate module.
	The module returns a table with functions:
	{
		hex2hsl: function,
		hex2rgb: function,
		hsl2hex: function,
		hsl2rgb: function,
		rgb2hex: function,
		rgb2hsl: function,
		_hue2rgb: function,  -- helper function for internal use
	}
	RGB values ​​are returned between 0 - 1
	If you need to get the usual value, multiply each element by 255
	rgb[1] * 255
	rgb[2] * 255
	rgb[3] * 255
]]

-- colorsys functions collection
local _M = {}


-- convert hex to rgb
-- @hex = string "#ffffff"
-- @return table {1, 1, 1}
function _M:hex2rgb (hex)
	hex = hex:gsub("#", "")

    local r = tonumber("0x" .. hex:sub(1,2)) / 255
    local g = tonumber("0x" .. hex:sub(3,4)) / 255
    local b = tonumber("0x" .. hex:sub(5,6)) / 255

	return { r, g, b }
end


-- convert rgb to hex
-- @rgb = table {1, 1, 1}
-- @return string "#ffffff"
function _M:rgb2hex (rgb)

    local r = string.format("%02x", math.floor(rgb[1]*255))
    local g = string.format("%02x", math.floor(rgb[2]*255))
    local b = string.format("%02x", math.floor(rgb[3]*255))

    return "#" .. r .. g .. b
end


-- convert rgb to hsl
-- @rgb = table {1, 1, 1}
-- @return table {0, 0, 1}
function _M:rgb2hsl (rgb)

	local r, g, b = rgb[1], rgb[2], rgb[3]

	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h = (max + min) / 2
	local s, l = h, h

	if max == min then
		h, s = 0, 0
	else
		local d = max - min
		s = (l > 0.5) and d / (2 - max - min) or d / (max + min)

		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end

		h = h / 6
	end

    return { h * 360, s, l }
end

-- helper function for internal use
-- https://en.wikipedia.org/wiki/HSL_and_HSV
function _M._hue2rgb (p, q, t)
	if t < 0   then t = t + 1 end
	if t > 1   then t = t - 1 end
	if t < 1/6 then return p + (q - p) * 6 * t end
	if t < 1/2 then return q end
	if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
	return p
end


-- convert hsl to rgb
-- @hsl = table {0, 0, 1}
-- @return table {1, 1, 1}
function _M:hsl2rgb (hsl)

	local r, g, b

    local h = hsl[1]
    local s = hsl[2]
    local l = hsl[3]

	h = h / 360

	if s == 0 then
		r, g, b = l, l, l
	else
		local q = (l < 0.5) and l * (1 + s) or l + s - l * s
		local p = l * 2 - q

		r = self._hue2rgb(p, q, h + 1/3)
		g = self._hue2rgb(p, q, h)
		b = self._hue2rgb(p, q, h - 1/3)
	end

	return { r, g, b }
end


-- convert hex to hsl
-- @hex = string "#ffffff"
-- @return table {0, 0, 1}
function _M:hex2hsl(hex)
    return self:rgb2hsl(self:hex2rgb(hex))
end


-- convert hsl to hex
-- @hsl = table {0, 0, 1}
-- @return string "#ffffff" 
function _M:hsl2hex(hsl)
    return self:rgb2hex(self:hsl2rgb(hsl))
end


return _M
