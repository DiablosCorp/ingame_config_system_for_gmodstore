/*---------------------------------------------------------------------------
precond: ID is a valid addon ID
postcond: returns the real ID 
Addon ID is now a 64bit integer, but util.JSONToTable would try to transform the ID 
by a integer so we force it to remain a string by adding a char
---------------------------------------------------------------------------*/

gmodstore.CHAR_ID = "k"
function gmodstore:GetCharID(ID)
	local realID = gmodstore.CHAR_ID .. ID
	return realID
end

/*---------------------------------------------------------------------------
precond: ID is a addon ID with a char ID
postcond: returns the real ID without the char ID
Addon ID is now a 64bit integer, but util.JSONToTable would try to transform the ID 
by a integer so we force it to remain a string by adding a char
---------------------------------------------------------------------------*/
function gmodstore:GetRealID(ID)
	local realID = string.sub(ID, #gmodstore.CHAR_ID + 1)
	return realID
end


/*---------------------------------------------------------------------------
	Write a message (msg) to the console, with a color depending on the type of the message (typeMsg)
---------------------------------------------------------------------------*/

function gmodstore:ConsoleMsg(typeMsg, msg)
	local col
	if typeMsg == 0 then
		col = gmodstore.Colors.gl
	elseif typeMsg == 1 then
		col = gmodstore.Colors.rl
	elseif typeMsg == 2 then
		col = gmodstore.Colors.bl3
	end

	MsgC(col, "[gmodstore] " .. msg .. "\n")
end

/*---------------------------------------------------------------------------
	Call gmodstore:ConsoleMsg above if we are in debug mode
---------------------------------------------------------------------------*/

function gmodstore:DebugConsoleMsg(typeMsg, msg)
	if gmodstore.Debug then
		gmodstore:ConsoleMsg(typeMsg, msg)
	end
end


/*---------------------------------------------------------------------------
	Prints and automatically do a PrintTable if the var is a table
	Also prints the "separatingText" if it is set
---------------------------------------------------------------------------*/

function gmodstore:Print(var, separatingText)
	if separatingText then
		print(string.format("--- %s ---", separatingText))
	end

	if type(var) == "table" then
		PrintTable(var)
	else
		print(var)
	end


	if separatingText then
		print(string.format("||| END %s |||", separatingText))
	end
end

/*---------------------------------------------------------------------------
	Get the client/server language
---------------------------------------------------------------------------*/
function gmodstore:GetLanguage()
	local lang = ""
	if SERVER then
		lang = GetConVar("sv_location"):GetString()
	else
		lang = gmodstore.LangEquivalence[GetConVar("cl_language"):GetString()]
	end

	if not gmodstore.Strings[lang] then
		lang = "en"
	end
	return lang
end

/*---------------------------------------------------------------------------
	Get the string according to the client/server language
---------------------------------------------------------------------------*/

function gmodstore:GetString(var)
	if var == "" then
		return "UNDEFINED STRING - CONTACT THE AUTHOR"
	end
	var = string.lower(var)

	local lang = gmodstore:GetLanguage()
	return gmodstore.Strings[lang][var]
end