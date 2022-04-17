local function LoadDirectory(path, side)
	for _, fileToImport in pairs(file.Find(path .. "*.lua", "LUA")) do
		local entireFilePath = path .. fileToImport
		if side == "shared" then
			include(entireFilePath)
			if SERVER then
				AddCSLuaFile(entireFilePath)
			end
		elseif side == "client" then
			if SERVER then
				AddCSLuaFile(entireFilePath)
			elseif CLIENT then
				include(entireFilePath)
			end
		elseif side == "server" then
			if SERVER then
				include(entireFilePath)
			end
		end
	end
end

LoadDirectory("gmodstore/init/", "shared")
LoadDirectory("gmodstore/languages/", "shared")
LoadDirectory("gmodstore/client/elements/variables/", "client")
LoadDirectory("gmodstore/client/elements/", "client")
LoadDirectory("gmodstore/client/", "client")
LoadDirectory("gmodstore/server/", "server")
LoadDirectory("gmodstore/shared/", "shared")


gmodstore:ConsoleMsg(0, "gmodstore system loaded")

