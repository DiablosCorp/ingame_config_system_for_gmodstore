# The Perfect In-game Config for GmodStore

![Home panel](https://diablosdev.com/gmod/gmodstore/addon/medias/home.png)
![Example page](https://diablosdev.com/gmod/gmodstore/addon/medias/addon_example.png)

**The Perfect In-game Config for GmodStore**, _a basic but efficient generic in-game configuration tool_!

## Description

This addon has been made to centralize in-game configuration in Garry's Mod game!
Server owners who have their addons on gmodstore are able to configure their addon to fully integrate their on the perfect gmodstore system. The addons will then become configurable in-game as they will be automatically added on the panel!

## Features

As a content creator
  - configure your addons by creating an easy file you have to put in your addon(s). It will automatically create everything for your customers to configure your addon(s) in the same derma than all the addons!
  - having one more sale argument for server owners who can configure all their addons in the same panel

As a server owner
  - download this script once for your server, via GitHub or via the [Steam workshop item](https://steamcommunity.com/sharedfiles/filedetails/?id=2795742935) you can add on your collection
  - configure all your addons in the same panel, which is easier to keep the tracking on your addons. The gmodstore panel can be opened using the **gmodstore** command on your client console.

As a regular player
  - nothing changes


## Why this addon

Garry's Mod is here since a lot of years now; when I was a server owner, one of the things which made me crazy is the fact you have one panel with one command per addon, which is complicating a lot of things when you think everything could be centralized in the same place...
It would also change the market a bit, stopping creators from saying "_in-game config_" is a whole feature and to focus more on the product idea itself than on a feature everyone should have.
Also, this addon could be (I hope) spread into all the Garry's Mod servers and therefore the config system would become normal and the same for everyone.

## Price

This content is **free**. However, I would **require** to create a "_In-game config_" tab on your gmodstore product page, with a prepared text you can find in [_this file_](gmodstore_tab.md). It will be useful for your customers to explain how it works. You should not change the tab content. The idea is that all the creators explain what is this in-game config the same way, as well as redirecting people who have issues with the in-game addon to come here instead of contacting you.

Also, what would be great would be to make some contributions on the script itself, if you are creator. We could discuss, add some features (maybe some specific cases of variables can't be interpreted by this addon), optimize the script for the bandwidth when a client is joining, etc. 
At the end, everyone would win - the servers would be much more optimized, with a common place for gmodstore scripts. Atleast that's how I see it.

## Available variables

- As a gmodstore creator, integrate your addons onto this system. Variable types are:
  - Boolean
  - Integer
  - String
  - Vector
  - Angle
  - Color
  - Single dropdown list
  - Multi dropdown list
  - Multi dropdown list with free-writing
  - Complex structure (for example tab = {{x = 1, y = 2}, {x = 3, y = 6}, {x = 4, y = 7}}
  - Most of the variable can be converted to a O1 Table ({"superadmin", "admin"} would be {["superadmin"] = true, ["admin"] = true}
- Versioning system: a server owner will be able to see if the addons are updated to the last version.

More information can be seen in the Wiki.

## Issues

If you have any issue using this script (being a server owner or gmodstore creator), please open an issue on GitHub or post a comment on the Steam Workshop item. 
Please make sure you've read the Wiki tab before, though.

## Note

**This script is not affiliated with gmodstore - this means that it was not a original request from the gmodstore team, therefore don't contact them for any issue you could have on this script**
