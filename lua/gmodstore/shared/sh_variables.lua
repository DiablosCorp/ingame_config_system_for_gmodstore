/*
	Variable elements with their interpretation
*/

gmodstore.InterpretedElements = {}

/*
	Set the variables for DarkRP
*/

local function setDarkRPGlobalVariables()
	gmodstore.DarkRP = {}
	gmodstore.DarkRP.Jobs = RPExtraTeams
	gmodstore.DarkRP.Shipments = CustomShipments
	gmodstore.DarkRP.Entities = DarkRPEntities

	gmodstore.InterpretedElements["darkrp_jobs"] = {
		tab = gmodstore.DarkRP.Jobs,
	}

	gmodstore.InterpretedElements["darkrp_shipments"] = {
		tab = gmodstore.DarkRP.Shipments,
	}

	gmodstore.InterpretedElements["darkrp_entities"] = {
		tab = gmodstore.DarkRP.Entities,
	}

end

/*---------------------------------------------------------------------------
	Initializing variables to put them in InterpretedElements
	This list would need to be longer if people improve it!
---------------------------------------------------------------------------*/

hook.Add("PostGamemodeLoaded", "gmodstore:GetVariables", function()
	timer.Simple(0, function()

		/* Gamemode */

		if DarkRP then
			setDarkRPGlobalVariables()
		end

		/* Global variables */

		-- TODO: Admin system integration
		gmodstore.UserGroups = {"superadmin", "admin", "user"}

		gmodstore.InterpretedElements["usergroups"] = {
			tab = gmodstore.UserGroups,
		}

		gmodstore.InEnums = {
			IN_ATTACK,
			IN_JUMP,
			IN_DUCK,
			IN_FORWARD,
			IN_BACK,
			IN_USE,
			IN_CANCEL,
			IN_LEFT,
			IN_RIGHT,
			IN_MOVELEFT,
			IN_MOVERIGHT,
			IN_ATTACK2,
			IN_RUN,
			IN_RELOAD,
			IN_ALT1,
			IN_ALT2,
			IN_SCORE,
			IN_SPEED,
			IN_WALK,
			IN_ZOOM,
			IN_WEAPON1,
			IN_WEAPON2,
			IN_BULLRUSH,
			IN_GRENADE1,
			IN_GRENADE2,
		}

		gmodstore.InEnumsEquivalence = {
			[IN_ATTACK] = "IN_ATTACK",
			[IN_JUMP] = "IN_JUMP",
			[IN_DUCK] = "IN_DUCK",
			[IN_FORWARD] = "IN_FORWARD",
			[IN_BACK] = "IN_BACK",
			[IN_USE] = "IN_USE",
			[IN_CANCEL] = "IN_CANCEL",
			[IN_LEFT] = "IN_LEFT",
			[IN_RIGHT] = "IN_RIGHT",
			[IN_MOVELEFT] = "IN_MOVELEFT",
			[IN_MOVERIGHT] = "IN_MOVERIGHT",
			[IN_ATTACK2] = "IN_ATTACK2",
			[IN_RUN] = "IN_RUN",
			[IN_RELOAD] = "IN_RELOAD",
			[IN_ALT1] = "IN_ALT1",
			[IN_ALT2] = "IN_ALT2",
			[IN_SCORE] = "IN_SCORE",
			[IN_SPEED] = "IN_SPEED",
			[IN_WALK] = "IN_WALK",
			[IN_ZOOM] = "IN_ZOOM",
			[IN_WEAPON1] = "IN_WEAPON1",
			[IN_WEAPON2] = "IN_WEAPON2",
			[IN_BULLRUSH] = "IN_BULLRUSH",
			[IN_GRENADE1] = "IN_GRENADE1",
			[IN_GRENADE2] = "IN_GRENADE2",
		}

		gmodstore.InEnumsReverseEquivalence = {
			["IN_ATTACK"] = IN_ATTACK,
			["IN_JUMP"] = IN_JUMP,
			["IN_DUCK"] = IN_DUCK,
			["IN_FORWARD"] = IN_FORWARD,
			["IN_BACK"] = IN_BACK,
			["IN_USE"] = IN_USE,
			["IN_CANCEL"] = IN_CANCEL,
			["IN_LEFT"] = IN_LEFT,
			["IN_RIGHT"] = IN_RIGHT,
			["IN_MOVELEFT"] = IN_MOVELEFT,
			["IN_MOVERIGHT"] = IN_MOVERIGHT,
			["IN_ATTACK2"] = IN_ATTACK2,
			["IN_RUN"] = IN_RUN,
			["IN_RELOAD"] = IN_RELOAD,
			["IN_ALT1"] = IN_ALT1,
			["IN_ALT2"] = IN_ALT2,
			["IN_SCORE"] = IN_SCORE,
			["IN_SPEED"] = IN_SPEED,
			["IN_WALK"] = IN_WALK,
			["IN_ZOOM"] = IN_ZOOM,
			["IN_WEAPON1"] = IN_WEAPON1,
			["IN_WEAPON2"] = IN_WEAPON2,
			["IN_BULLRUSH"] = IN_BULLRUSH,
			["IN_GRENADE1"] = IN_GRENADE1,
			["IN_GRENADE2"] = IN_GRENADE2,
		}

		gmodstore.InterpretedElements["in_enum"] = {
			tab = gmodstore.InEnums,
			equivalence = gmodstore.InEnumsEquivalence,
			reverseEquivalence = gmodstore.InEnumsReverseEquivalence,
		}

		gmodstore.KeyEnums = {
			KEY_0,
			KEY_1,
			KEY_2,
			KEY_3,
			KEY_4,
			KEY_5,
			KEY_6,
			KEY_7,
			KEY_8,
			KEY_9,
			KEY_A,
			KEY_B,
			KEY_C,
			KEY_D,
			KEY_E,
			KEY_F,
			KEY_G,
			KEY_H,
			KEY_I,
			KEY_J,
			KEY_K,
			KEY_L,
			KEY_M,
			KEY_N,
			KEY_O,
			KEY_P,
			KEY_Q,
			KEY_R,
			KEY_S,
			KEY_T,
			KEY_U,
			KEY_V,
			KEY_W,
			KEY_X,
			KEY_Y,
			KEY_Z,
			KEY_PAD_0,
			KEY_PAD_1,
			KEY_PAD_2,
			KEY_PAD_3,
			KEY_PAD_4,
			KEY_PAD_5,
			KEY_PAD_6,
			KEY_PAD_7,
			KEY_PAD_8,
			KEY_PAD_9,
			KEY_PAD_DIVIDE,
			KEY_PAD_MULTIPLY,
			KEY_PAD_MINUS,
			KEY_PAD_PLUS,
			KEY_PAD_ENTER,
			KEY_PAD_DECIMAL,
			KEY_LBRACKET,
			KEY_RBRACKET,
			KEY_SEMICOLON,
			KEY_APOSTROPHE,
			KEY_BACKQUOTE,
			KEY_COMMA,
			KEY_PERIOD,
			KEY_SLASH,
			KEY_BACKSLASH,
			KEY_MINUS,
			KEY_EQUAL,
			KEY_ENTER,
			KEY_SPACE,
			KEY_BACKSPACE,
			KEY_TAB,
			KEY_CAPSLOCK,
			KEY_NUMLOCK,
			KEY_ESCAPE,
			KEY_SCROLLLOCK,
			KEY_INSERT,
			KEY_DELETE,
			KEY_HOME,
			KEY_END,
			KEY_PAGEUP,
			KEY_PAGEDOWN,
			KEY_BREAK,
			KEY_LSHIFT,
			KEY_RSHIFT,
			KEY_LALT,
			KEY_RALT,
			KEY_LCONTROL,
			KEY_RCONTROL,
			KEY_LWIN,
			KEY_RWIN,
			KEY_APP,
			KEY_UP,
			KEY_LEFT,
			KEY_DOWN,
			KEY_RIGHT,
			KEY_F1,
			KEY_F2,
			KEY_F3,
			KEY_F4,
			KEY_F5,
			KEY_F6,
			KEY_F7,
			KEY_F8,
			KEY_F9,
			KEY_F10,
			KEY_F11,
			KEY_F12,
			KEY_CAPSLOCKTOGGLE,
			KEY_NUMLOCKTOGGLE,
			KEY_LAST,
			KEY_SCROLLLOCKTOGGLE,
			KEY_COUNT,
			KEY_XBUTTON_A,
			KEY_XBUTTON_B,
			KEY_XBUTTON_X,
			KEY_XBUTTON_Y,
			KEY_XBUTTON_LEFT_SHOULDER,
			KEY_XBUTTON_RIGHT_SHOULDER,
			KEY_XBUTTON_BACK,
			KEY_XBUTTON_START,
			KEY_XBUTTON_STICK1,
			KEY_XBUTTON_STICK2,
			KEY_XBUTTON_UP,
			KEY_XBUTTON_RIGHT,
			KEY_XBUTTON_DOWN,
			KEY_XBUTTON_LEFT,
			KEY_XSTICK1_RIGHT,
			KEY_XSTICK1_LEFT,
			KEY_XSTICK1_DOWN,
			KEY_XSTICK1_UP,
			KEY_XBUTTON_LTRIGGER,
			KEY_XBUTTON_RTRIGGER,
			KEY_XSTICK2_RIGHT,
			KEY_XSTICK2_LEFT,
			KEY_XSTICK2_DOWN,
			KEY_XSTICK2_UP
		}

		gmodstore.KeyEnumsEquivalence = {
			[KEY_0] = "0",
			[KEY_1] = "1",
			[KEY_2] = "2",
			[KEY_3] = "3",
			[KEY_4] = "4",
			[KEY_5] = "5",
			[KEY_6] = "6",
			[KEY_7] = "7",
			[KEY_8] = "8",
			[KEY_9] = "9",
			[KEY_A] = "A",
			[KEY_B] = "B",
			[KEY_C] = "C",
			[KEY_D] = "D",
			[KEY_E] = "E",
			[KEY_F] = "F",
			[KEY_G] = "G",
			[KEY_H] = "H",
			[KEY_I] = "I",
			[KEY_J] = "J",
			[KEY_K] = "K",
			[KEY_L] = "L",
			[KEY_M] = "M",
			[KEY_N] = "N",
			[KEY_O] = "O",
			[KEY_P] = "P",
			[KEY_Q] = "Q",
			[KEY_R] = "R",
			[KEY_S] = "S",
			[KEY_T] = "T",
			[KEY_U] = "U",
			[KEY_V] = "V",
			[KEY_W] = "W",
			[KEY_X] = "X",
			[KEY_Y] = "Y",
			[KEY_Z] = "Z",
			[KEY_PAD_0] = "PAD_0",
			[KEY_PAD_1] = "PAD_1",
			[KEY_PAD_2] = "PAD_2",
			[KEY_PAD_3] = "PAD_3",
			[KEY_PAD_4] = "PAD_4",
			[KEY_PAD_5] = "PAD_5",
			[KEY_PAD_6] = "PAD_6",
			[KEY_PAD_7] = "PAD_7",
			[KEY_PAD_8] = "PAD_8",
			[KEY_PAD_9] = "PAD_9",
			[KEY_PAD_DIVIDE] = "PAD_DIVIDE",
			[KEY_PAD_MULTIPLY] = "PAD_MULTIPLY",
			[KEY_PAD_MINUS] = "PAD_MINUS",
			[KEY_PAD_PLUS] = "PAD_PLUS",
			[KEY_PAD_ENTER] = "PAD_ENTER",
			[KEY_PAD_DECIMAL] = "PAD_DECIMAL",
			[KEY_LBRACKET] = "LBRACKET",
			[KEY_RBRACKET] = "RBRACKET",
			[KEY_SEMICOLON] = "SEMICOLON",
			[KEY_APOSTROPHE] = "APOSTROPHE",
			[KEY_BACKQUOTE] = "BACKQUOTE",
			[KEY_COMMA] = "COMMA",
			[KEY_PERIOD] = "PERIOD",
			[KEY_SLASH] = "SLASH",
			[KEY_BACKSLASH] = "BACKSLASH",
			[KEY_MINUS] = "MINUS",
			[KEY_EQUAL] = "EQUAL",
			[KEY_ENTER] = "ENTER",
			[KEY_SPACE] = "SPACE",
			[KEY_BACKSPACE] = "BACKSPACE",
			[KEY_TAB] = "TAB",
			[KEY_CAPSLOCK] = "CAPSLOCK",
			[KEY_NUMLOCK] = "NUMLOCK",
			[KEY_ESCAPE] = "ESCAPE",
			[KEY_SCROLLLOCK] = "SCROLLLOCK",
			[KEY_INSERT] = "INSERT",
			[KEY_DELETE] = "DELETE",
			[KEY_HOME] = "HOME",
			[KEY_END] = "END",
			[KEY_PAGEUP] = "PAGEUP",
			[KEY_PAGEDOWN] = "PAGEDOWN",
			[KEY_BREAK] = "BREAK",
			[KEY_LSHIFT] = "LSHIFT",
			[KEY_RSHIFT] = "RSHIFT",
			[KEY_LALT] = "LALT",
			[KEY_RALT] = "RALT",
			[KEY_LCONTROL] = "LCONTROL",
			[KEY_RCONTROL] = "RCONTROL",
			[KEY_LWIN] = "LWIN",
			[KEY_RWIN] = "RWIN",
			[KEY_APP] = "APP",
			[KEY_UP] = "UP",
			[KEY_LEFT] = "LEFT",
			[KEY_DOWN] = "DOWN",
			[KEY_RIGHT] = "RIGHT",
			[KEY_F1] = "F1",
			[KEY_F2] = "F2",
			[KEY_F3] = "F3",
			[KEY_F4] = "F4",
			[KEY_F5] = "F5",
			[KEY_F6] = "F6",
			[KEY_F7] = "F7",
			[KEY_F8] = "F8",
			[KEY_F9] = "F9",
			[KEY_F10] = "F10",
			[KEY_F11] = "F11",
			[KEY_F12] = "F12",
			[KEY_CAPSLOCKTOGGLE] = "CAPSLOCKTOGGLE",
			[KEY_NUMLOCKTOGGLE] = "NUMLOCKTOGGLE",
			[KEY_LAST] = "LAST",
			[KEY_SCROLLLOCKTOGGLE] = "SCROLLLOCKTOGGLE",
			[KEY_COUNT] = "COUNT",
			[KEY_XBUTTON_A] = "XBUTTON_A",
			[KEY_XBUTTON_B] = "XBUTTON_B",
			[KEY_XBUTTON_X] = "XBUTTON_X",
			[KEY_XBUTTON_Y] = "XBUTTON_Y",
			[KEY_XBUTTON_LEFT_SHOULDER] = "XBUTTON_LEFT_SHOULDER",
			[KEY_XBUTTON_RIGHT_SHOULDER] = "XBUTTON_RIGHT_SHOULDER",
			[KEY_XBUTTON_BACK] = "XBUTTON_BACK",
			[KEY_XBUTTON_START] = "XBUTTON_START",
			[KEY_XBUTTON_STICK1] = "XBUTTON_STICK1",
			[KEY_XBUTTON_STICK2] = "XBUTTON_STICK2",
			[KEY_XBUTTON_UP] = "XBUTTON_UP",
			[KEY_XBUTTON_RIGHT] = "XBUTTON_RIGHT",
			[KEY_XBUTTON_DOWN] = "XBUTTON_DOWN",
			[KEY_XBUTTON_LEFT] = "XBUTTON_LEFT",
			[KEY_XSTICK1_RIGHT] = "XSTICK1_RIGHT",
			[KEY_XSTICK1_LEFT] = "XSTICK1_LEFT",
			[KEY_XSTICK1_DOWN] = "XSTICK1_DOWN",
			[KEY_XSTICK1_UP] = "XSTICK1_UP",
			[KEY_XBUTTON_LTRIGGER] = "XBUTTON_LTRIGGER",
			[KEY_XBUTTON_RTRIGGER] = "XBUTTON_RTRIGGER",
			[KEY_XSTICK2_RIGHT] = "XSTICK2_RIGHT",
			[KEY_XSTICK2_LEFT] = "XSTICK2_LEFT",
			[KEY_XSTICK2_DOWN] = "XSTICK2_DOWN",
			[KEY_XSTICK2_UP] = "XSTICK2_UP"
		}

		gmodstore.KeyEnumsReverseEquivalence = {
			["0"] = KEY_0,
			["1"] = KEY_1,
			["2"] = KEY_2,
			["3"] = KEY_3,
			["4"] = KEY_4,
			["5"] = KEY_5,
			["6"] = KEY_6,
			["7"] = KEY_7,
			["8"] = KEY_8,
			["9"] = KEY_9,
			["A"] = KEY_A,
			["B"] = KEY_B,
			["C"] = KEY_C,
			["D"] = KEY_D,
			["E"] = KEY_E,
			["F"] = KEY_F,
			["G"] = KEY_G,
			["H"] = KEY_H,
			["I"] = KEY_I,
			["J"] = KEY_J,
			["K"] = KEY_K,
			["L"] = KEY_L,
			["M"] = KEY_M,
			["N"] = KEY_N,
			["O"] = KEY_O,
			["P"] = KEY_P,
			["Q"] = KEY_Q,
			["R"] = KEY_R,
			["S"] = KEY_S,
			["T"] = KEY_T,
			["U"] = KEY_U,
			["V"] = KEY_V,
			["W"] = KEY_W,
			["X"] = KEY_X,
			["Y"] = KEY_Y,
			["Z"] = KEY_Z,
			["PAD_0"] = KEY_PAD_0,
			["PAD_1"] = KEY_PAD_1,
			["PAD_2"] = KEY_PAD_2,
			["PAD_3"] = KEY_PAD_3,
			["PAD_4"] = KEY_PAD_4,
			["PAD_5"] = KEY_PAD_5,
			["PAD_6"] = KEY_PAD_6,
			["PAD_7"] = KEY_PAD_7,
			["PAD_8"] = KEY_PAD_8,
			["PAD_9"] = KEY_PAD_9,
			["PAD_DIVIDE"] = KEY_PAD_DIVIDE,
			["PAD_MULTIPLY"] = KEY_PAD_MULTIPLY,
			["PAD_MINUS"] = KEY_PAD_MINUS,
			["PAD_PLUS"] = KEY_PAD_PLUS,
			["PAD_ENTER"] = KEY_PAD_ENTER,
			["PAD_DECIMAL"] = KEY_PAD_DECIMAL,
			["LBRACKET"] = KEY_LBRACKET,
			["RBRACKET"] = KEY_RBRACKET,
			["SEMICOLON"] = KEY_SEMICOLON,
			["APOSTROPHE"] = KEY_APOSTROPHE,
			["BACKQUOTE"] = KEY_BACKQUOTE,
			["COMMA"] = KEY_COMMA,
			["PERIOD"] = KEY_PERIOD,
			["SLASH"] = KEY_SLASH,
			["BACKSLASH"] = KEY_BACKSLASH,
			["MINUS"] = KEY_MINUS,
			["EQUAL"] = KEY_EQUAL,
			["ENTER"] = KEY_ENTER,
			["SPACE"] = KEY_SPACE,
			["BACKSPACE"] = KEY_BACKSPACE,
			["TAB"] = KEY_TAB,
			["CAPSLOCK"] = KEY_CAPSLOCK,
			["NUMLOCK"] = KEY_NUMLOCK,
			["ESCAPE"] = KEY_ESCAPE,
			["SCROLLLOCK"] = KEY_SCROLLLOCK,
			["INSERT"] = KEY_INSERT,
			["DELETE"] = KEY_DELETE,
			["HOME"] = KEY_HOME,
			["END"] = KEY_END,
			["PAGEUP"] = KEY_PAGEUP,
			["PAGEDOWN"] = KEY_PAGEDOWN,
			["BREAK"] = KEY_BREAK,
			["LSHIFT"] = KEY_LSHIFT,
			["RSHIFT"] = KEY_RSHIFT,
			["LALT"] = KEY_LALT,
			["RALT"] = KEY_RALT,
			["LCONTROL"] = KEY_LCONTROL,
			["RCONTROL"] = KEY_RCONTROL,
			["LWIN"] = KEY_LWIN,
			["RWIN"] = KEY_RWIN,
			["APP"] = KEY_APP,
			["UP"] = KEY_UP,
			["LEFT"] = KEY_LEFT,
			["DOWN"] = KEY_DOWN,
			["RIGHT"] = KEY_RIGHT,
			["F1"] = KEY_F1,
			["F2"] = KEY_F2,
			["F3"] = KEY_F3,
			["F4"] = KEY_F4,
			["F5"] = KEY_F5,
			["F6"] = KEY_F6,
			["F7"] = KEY_F7,
			["F8"] = KEY_F8,
			["F9"] = KEY_F9,
			["F10"] = KEY_F10,
			["F11"] = KEY_F11,
			["F12"] = KEY_F12,
			["CAPSLOCKTOGGLE"] = KEY_CAPSLOCKTOGGLE,
			["NUMLOCKTOGGLE"] = KEY_NUMLOCKTOGGLE,
			["LAST"] = KEY_LAST,
			["SCROLLLOCKTOGGLE"] = KEY_SCROLLLOCKTOGGLE,
			["COUNT"] = KEY_COUNT,
			["XBUTTON_A"] = KEY_XBUTTON_A,
			["XBUTTON_B"] = KEY_XBUTTON_B,
			["XBUTTON_X"] = KEY_XBUTTON_X,
			["XBUTTON_Y"] = KEY_XBUTTON_Y,
			["XBUTTON_LEFT_SHOULDER"] = KEY_XBUTTON_LEFT_SHOULDER,
			["XBUTTON_RIGHT_SHOULDER"] = KEY_XBUTTON_RIGHT_SHOULDER,
			["XBUTTON_BACK"] = KEY_XBUTTON_BACK,
			["XBUTTON_START"] = KEY_XBUTTON_START,
			["XBUTTON_STICK1"] = KEY_XBUTTON_STICK1,
			["XBUTTON_STICK2"] = KEY_XBUTTON_STICK2,
			["XBUTTON_UP"] = KEY_XBUTTON_UP,
			["XBUTTON_RIGHT"] = KEY_XBUTTON_RIGHT,
			["XBUTTON_DOWN"] = KEY_XBUTTON_DOWN,
			["XBUTTON_LEFT"] = KEY_XBUTTON_LEFT,
			["XSTICK1_RIGHT"] = KEY_XSTICK1_RIGHT,
			["XSTICK1_LEFT"] = KEY_XSTICK1_LEFT,
			["XSTICK1_DOWN"] = KEY_XSTICK1_DOWN,
			["XSTICK1_UP"] = KEY_XSTICK1_UP,
			["XBUTTON_LTRIGGER"] = KEY_XBUTTON_LTRIGGER,
			["XBUTTON_RTRIGGER"] = KEY_XBUTTON_RTRIGGER,
			["XSTICK2_RIGHT"] = KEY_XSTICK2_RIGHT,
			["XSTICK2_LEFT"] = KEY_XSTICK2_LEFT,
			["XSTICK2_DOWN"] = KEY_XSTICK2_DOWN,
			["XSTICK2_UP"] = KEY_XSTICK2_UP,
		}

		gmodstore.InterpretedElements["key_enum"] = {
			tab = gmodstore.KeyEnums,
			equivalence = gmodstore.KeyEnumsEquivalence,
			reverseEquivalence = gmodstore.KeyEnumsReverseEquivalence,
		}

		gmodstore.Vehicles = {}
		local tempVeh = list.Get("Vehicles")
		for vehClass, _ in pairs(tempVeh) do
			table.insert(gmodstore.Vehicles, vehClass)
		end

		gmodstore.InterpretedElements["vehicles"] = {
			tab = gmodstore.Vehicles,
		}

		gmodstore:DebugConsoleMsg(2, gmodstore:GetString("variables_initialized"))

		hook.Remove("PostGamemodeLoaded", "gmodstore:GetVariables")
	end)
end)