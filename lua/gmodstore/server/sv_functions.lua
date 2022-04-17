/*---------------------------------------------------------------------------
precond: the table values table which is filled by the values saved (optionally the player)
postcond: the addon new content is saved into ingame_config/addon_%u.txt as a text file ; it will also update the config for everyone and notify the ply if ply is valid
---------------------------------------------------------------------------*/

function gmodstore:SaveAddon(tableValues, ply)
	if not file.IsDir("ingame_config", "DATA") then file.CreateDir("ingame_config") end
	for ID, variables in pairs(tableValues) do
		gmodstore:SaveAddonValues(ID, variables)

		gmodstore:Notify(ply, 2, 5, string.format(gmodstore:GetString("successfully_saved"), gmodstore:GetRealID(ID)))

		gmodstore:UpdateConfig(ID)
	end
end

/*---------------------------------------------------------------------------
	Update the addon values in the global table gmodstore.StoredValues
---------------------------------------------------------------------------*/

function gmodstore:UpdateAddonValues(ID, tab)
	gmodstore.StoredValues[ID] = tab
end

/*---------------------------------------------------------------------------
	Get the addon values according to the addon ID
---------------------------------------------------------------------------*/

function gmodstore:GetAddonValues(ID)
	return gmodstore.StoredValues[ID]
end

/*---------------------------------------------------------------------------
	Read the serverside file with addon ID to get the data config saved on the server
	This will then put the data in gmodstore.StoredValues[ID]
---------------------------------------------------------------------------*/

function gmodstore:GenerateAddonValues(ID)
	local fileContent = file.Read(string.format("ingame_config/addon_%s.txt", ID)) or ""
	local tab = util.JSONToTable(fileContent) or {}

	gmodstore:DebugConsoleMsg(2, string.format(gmodstore:GetString("reading_file"), gmodstore:GetRealID(ID)))

	gmodstore:UpdateAddonValues(ID, tab)
end

/*---------------------------------------------------------------------------
	Save the data config ("tab") in a serverside file according to the addon ID
---------------------------------------------------------------------------*/

function gmodstore:SaveAddonValues(ID, tab)
	local realTable = {[ID] = tab}
	local jsonContent = util.TableToJSON(realTable, true)
	file.Write(string.format("ingame_config/addon_%s.txt", ID), jsonContent)
	gmodstore:UpdateAddonValues(ID, realTable)
end


/*---------------------------------------------------------------------------
precond: the ID of the config to update and optionally a player (if ply is not valid then it will be networked to everyone)
postcond: the player (or everyone if ply is set to nil) will receive updated config clientside
---------------------------------------------------------------------------*/
function gmodstore:NetworkUpdateConfig(data, ply)
	local content = util.TableToJSON(data, true)
	local compressed = util.Compress(content)

	net.Start("gmodstore:UpdateConfig")
		net.WriteUInt(#compressed, 32)
		net.WriteData(compressed, #compressed)

	if IsValid(ply) then net.Send(ply)
	else net.Broadcast() end
end


/*---------------------------------------------------------------------------
precond: the ID of the addon to update and optionally a player 
postcond: the player (or everyone if ply is set to nil) will receive updated config of the addon with ID <id>
---------------------------------------------------------------------------*/
function gmodstore:UpdateConfig(ID, ply)
	local data = gmodstore:GetAddonValues(ID)

	-- update the global variables serverside
	gmodstore:UpdateVariables(data)

	-- network updated values clientside
	gmodstore:NetworkUpdateConfig(data, ply)
end


/*---------------------------------------------------------------------------
precond: the player ply has spawn and is valid
postcond: the player ply will receive the global variables because values will be networked clientside
---------------------------------------------------------------------------*/
function gmodstore:GetAddonsOnSpawn(ply)
	for _, addon in pairs(gmodstore.Addons) do
		local data = gmodstore:GetAddonValues(addon.ID)

		-- network updated values
		gmodstore:NetworkUpdateConfig(data, ply)
	end
end


/*---------------------------------------------------------------------------
precond: ply (entity), msgType (0/1/2 numbers), time (int), message (string) 
postcond: the player is notified during time seconds with a notification of type msgType with the text message
---------------------------------------------------------------------------*/

function gmodstore:Notify(ply, msgType, time, message)
	if not IsValid(ply) then return end
	if DarkRP then
		DarkRP.notify(ply, msgType, time, message)
	else
		net.Start("gmodstore:Notify")
			net.WriteUInt(msgType, 2)
			net.WriteUInt(time, 4)
			net.WriteString(text)
		net.Send(ply)
	end
end


/*---------------------------------------------------------------------------
precond: a addon table
postcond: a new attribute on variables called "value" is created, with the default value. If there is no "value" attribute, then the value to put is the one in "Default"
---------------------------------------------------------------------------*/
function gmodstore:DefineValueAttribute(addon)
	gmodstore:GenerateAddonValues(addon.ID)
	local content = gmodstore:GetAddonValues(addon.ID)
	if not content then return end
	if table.IsEmpty(content) then return end

	content = content[addon.ID]
	for varName, variable in pairs(addon.Variables) do

		-- if the variable is inside the file
		if content[varName] and content[varName].Value then

			variable.Value = content[varName].Value

		-- if a default value exists
		elseif variable.Default then

			local defaultValue = variable.Default
			if variable.O1Table then
				defaultValue = gmodstore:TransformToO1Array(defaultValue)
			end

			variable.Value = defaultValue

		else

			variable.Value = gmodstore:GetValueFromType(gmodstore:GetTypeOfVariable(variable))

		end

	end
end


/*---------------------------------------------------------------------------
precond: addons are properly loaded (addon_autoconfig.lua)
postcond: addons have Updated and LastVersion values so you are able to know if the addon is updated

Called after the http fetch when versions are taken,
but also if AddAddon() on an existing addon is already called
---------------------------------------------------------------------------*/
function gmodstore:UpdateVersioning(addonsToVersion)
	-- by default, update the versioning for all the addons
	if not addonsToVersion then
		addonsToVersion = gmodstore.Addons
	end
	for ID, ADDON in pairs(addonsToVersion) do
		-- failure on the website detection
		if not gmodstore.VersioningSuccess then
			ADDON.Versioning = nil
			continue
		end
		local lastVer = gmodstore.Versioning[ID]
		-- if lastVer is nil, then the versioning system is not enabled
		local detected = lastVer != nil
		if detected then
			local isLastVersion = (lastVer == ADDON.Version)
			ADDON.Versioning = {Detected = detected, Updated = isLastVersion, LastVersion = lastVer}
		else
			ADDON.Versioning = {Detected = false}
		end
	end
end



/*---------------------------------------------------------------------------
precond: the variable with a valid type
postcond: the function will return a default value depending on the variable type
---------------------------------------------------------------------------*/

function gmodstore:GetValueFromType(typeVar)
	local valueToReturn
	if typeVar == "int" then
		valueToReturn = 0
	elseif typeVar == "boolean" then
		valueToReturn = false
	elseif typeVar == "text" then
		valueToReturn = ""
	elseif typeVar == "color" then
		valueToReturn = color_white
	elseif typeVar == "vector" then
		valueToReturn = vector_origin
	elseif typeVar == "angle" then
		valueToReturn = angle_zero
	elseif typeVar == "table" then
		valueToReturn = {}
	end

	return valueToReturn
end