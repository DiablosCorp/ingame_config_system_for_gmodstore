util.AddNetworkString("gmodstore:Notify")
util.AddNetworkString("gmodstore:OpenMenu")
util.AddNetworkString("gmodstore:SaveAddon")
util.AddNetworkString("gmodstore:UpdateConfig")

/*---------------------------------------------------------------------------
	Save new addon data config by sending a whole table of data
	The addon will be saved serverside in a file, then broadcasted to all the clients to update the values
	The gmodstore panel will be reopened with new saved values
---------------------------------------------------------------------------*/

net.Receive("gmodstore:SaveAddon", function(len, ply)
	local datalen = net.ReadUInt(32)
	local data = net.ReadData(datalen)
	local jsonContent = util.Decompress(data)
	local tableValues = util.JSONToTable(jsonContent)

	gmodstore:SaveAddon(tableValues, ply)

	timer.Simple(1, function()
		if IsValid(ply) then
			ply:ConCommand("gmodstore")
		end
	end)

end)