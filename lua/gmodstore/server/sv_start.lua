/*---------------------------------------------------------------------------
	Versioning system
	This will retrieve all the versions we could take on the website
	If you are a developer and want to integrate your addon for the versioning system,
	please contact Diablos#0001 on Discord as it would require a "Read addon" API for your addons in order
	for it to be detected on my website.
---------------------------------------------------------------------------*/

timer.Simple(0, function()
	http.Fetch("https://diablosdev.com/gmod/gmodstore/versioning/addon_versions.json",
		function(response, len, headers, status)
			if response != nil and response != "" then -- verify it's returning something
				local onlineVersions = util.JSONToTable(response)
				-- we convert the keys to string because otherwise util.JSONToTable converted keys to numbers
				for key, version in pairs(onlineVersions) do
					local stringKey = gmodstore:GetCharID(key)
					gmodstore.Versioning[stringKey] = version
				end
				gmodstore.VersioningSuccess = true
				gmodstore:UpdateVersioning()
			end
		end,
		function(err)
			gmodstore.VersioningSuccess = false
			-- We'll leave that comment for the moment
			-- gmodstore:DebugConsoleMsg(1, gmodstore:GetString("website_not_detected"))
		end
	)
end)