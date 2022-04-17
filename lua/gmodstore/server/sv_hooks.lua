/*---------------------------------------------------------------------------
	Update the config for the player with the config saved on the server
	If the gmodstore files are not still loaded, we'll try again
---------------------------------------------------------------------------*/

hook.Add("PlayerInitialSpawn", "gmodstore:UpdateConfigHook", function(ply)
	local id = ply:SteamID64()
	local timerName = "gmodstore:SpawnUpdateConfig:" .. id
	timer.Create(timerName, 5, 5, function()
		if gmodstore.FilesLoaded then
			gmodstore:GetAddonsOnSpawn(ply)
			timer.Remove(timerName)
		end
	end)
end)