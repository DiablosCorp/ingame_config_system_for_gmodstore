/*---------------------------------------------------------------------------
	Include addons (addons must be launched properly before we find files) 
---------------------------------------------------------------------------*/

hook.Add("PostGamemodeLoaded", "gmodstore:RetrieveAddons", function()
	timer.Simple(0, function() -- don't increase the timer time or the files would not be included

		/* Get the addons */
		local CONFIGFILES = file.Find("ingame_config/*.lua", "LUA")
		for _, addons in pairs(CONFIGFILES) do
			gmodstore:DebugConsoleMsg(2, string.format(gmodstore:GetString("getting_file"), addons))
			include("ingame_config/" .. addons)
			if SERVER then
				AddCSLuaFile("ingame_config/" .. addons)
			end
		end

		/* Update their values serverside */
		if SERVER then
			for _, ADDON in pairs(gmodstore.Addons) do
				if ADDON.Disabled then continue end
				-- Get the server txt file and set the values "variable.Value"
				gmodstore:DebugConsoleMsg(2, string.format(gmodstore:GetString("getting_addon"), gmodstore:GetRealID(ADDON.ID)))

				gmodstore:DefineValueAttribute(ADDON)

				-- Update server variables in the global table
				gmodstore:UpdateVariables(gmodstore:GetAddonValues(ADDON.ID))
			end
		end

		gmodstore.FilesLoaded = true


		hook.Remove("PostGamemodeLoaded", "gmodstore:RetrieveAddons")
	end)
end)