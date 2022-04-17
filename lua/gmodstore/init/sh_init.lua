gmodstore = gmodstore or {}
gmodstore.Versioning = gmodstore.Versioning or {}
gmodstore.Addons = gmodstore.Addons or {}
gmodstore.StoredValues = gmodstore.StoredValues or {}
gmodstore.Debug = false
gmodstore.ShowFirstCategory = true

gmodstore.Colors = {
	rndbox = Color(100, 100, 100, 100),
	rndbox_opaque = Color(100, 100, 100, 250),
	r = Color(100, 40, 40, 100),
	g = Color(40, 100, 40, 100),
	rl = Color(200, 100, 100, 200),
	rl2 = Color(220, 60, 60, 200),
	rl3 = Color(240, 40, 40, 200),
	gl = Color(100, 200, 100, 255),
	gl2 = Color(120, 180, 120, 255),
	gl3 = Color(140, 160, 140, 255),
	bl = Color(100, 100, 200, 255),
	bl2 = Color(60, 60, 220, 255),
	bl3 = Color(40, 40, 240, 255),
	pre1 = Color(200, 40, 40, 255),
	pre2 = Color(100, 255, 100, 255),
	b = Color(0, 0, 0, 255),
	basicframe = Color(50, 50, 50, 240),
	buttonAction = Color(100, 100, 100, 240),
	basicheader = Color(80, 80, 140, 200),
	error = Color(200, 50, 60),
	label = Color(220, 220, 220, 220),
	labelHovered = Color(50, 50, 50, 220),
	labelDown = Color(0, 0, 0, 220),
	vbarBG = Color(100, 100, 100, 240),
	vbarGrip = Color(30, 30, 30, 240),
}

gmodstore.Materials = {
	gms = Material("gmodstore/logo.png", "smooth"),
	diablos = Material("gmodstore/diablos.jpg", "smooth"),
	github = Material("gmodstore/github.jpg", "mips smooth"),
	workshop = Material("gmodstore/workshop.jpg", "mips smooth"),
	updated = Material("gmodstore/updated.png", "mips smooth"),
	outdated = Material("gmodstore/outdated.png", "mips smooth"),
	unversioned = Material("gmodstore/unversioned.png", "mips smooth"),
}

gmodstore.URL = {
	diablos = "https://diablosdev.com/",
	gmodstore = "https://www.gmodstore.com/",
	github = "https://github.com/DiablosCorp/the_perfect_gmodstore_system",
	workshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=2795742935",
}

