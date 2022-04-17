/*---------------------------------------------------------------------------
	gmodstore concommand to open the menu
---------------------------------------------------------------------------*/

concommand.Add("gmodstore", function(ply, cmd, args, argStr)
	if not IsValid(ply) then return end
	if not ply:IsSuperAdmin() then return end

	local content = util.TableToJSON(gmodstore.Addons)
	local compressed = util.Compress(content)

	net.Start("gmodstore:OpenMenu")
		net.WriteUInt(#compressed, 32)
		net.WriteData(compressed, #compressed)
	net.Send(ply)
end)