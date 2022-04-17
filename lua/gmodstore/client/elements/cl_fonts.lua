/*
	Create fonts we need for the design
*/

local function CreateFont(sizeFont, italicValue)
	local fontName = "gmodstoreFont:" .. sizeFont
	if italicValue then
		fontName = fontName .. ":I"
	end
	surface.CreateFont(fontName, {
		font = "Roboto Condensed",
		size = sizeFont,
		weight = 400,
		italic = italicValue,
	})
end

local fontsToCreate = {
	["regular"] = {15, 20, 25, 30, 35, 40, 55, 65, 80, 90, 95, 100},
	-- ["bold"] = {},
	-- ["italic"] = {},
}

for _, fontSize in pairs(fontsToCreate["regular"]) do
	CreateFont(fontSize, false)
end

for _, fontSize in pairs(fontsToCreate["italic"]) do
	CreateFont(fontSize, true)
end