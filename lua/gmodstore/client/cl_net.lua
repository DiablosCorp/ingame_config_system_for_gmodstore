/*---------------------------------------------------------------------------
	Open the "gmodstore" menu, this will get all the addons configured with this system
---------------------------------------------------------------------------*/

net.Receive("gmodstore:OpenMenu", function(len, ply)
	local datalen = net.ReadUInt(32)
	local data = net.ReadData(datalen)
	local decompressed = util.Decompress(data)
	local addonTable = util.JSONToTable(decompressed)

	gmodstore:OpenPanel(addonTable)
end)

/*---------------------------------------------------------------------------
	Update the config clientside
	This will retrieve all the data to, then, update the variables clientside
---------------------------------------------------------------------------*/

net.Receive("gmodstore:UpdateConfig", function(len, ply)
	local datalen = net.ReadUInt(32)
	local data = net.ReadData(datalen)
	local decompressed = util.Decompress(data)
	local addonTable = util.JSONToTable(decompressed) or {}

	-- update variables clientside
	gmodstore:UpdateVariables(addonTable)
end)


/*---------------------------------------------------------------------------
	Notify someone (for non-DarkRP gamemodes)
---------------------------------------------------------------------------*/

net.Receive("gmodstore:Notify", function(len, ply)
	local msgType = net.ReadUInt(3)
	local time = net.ReadUInt(4)
	local text = net.ReadString()
	notification.AddLegacy(text, msgType, time)
end)