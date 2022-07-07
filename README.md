# jim-recycle
FiveM Custom QBCORE recycling script made by me from scratch

- Highly customisable via config.lua
  - Locations are easily changeable/removable

- Features several ways to get materials
  - Recycle Center - Trade recyclable Materials to get crafting materials
  - Dumpster Diving - Search dumpsters and trash cans for materials
  - Scrapping - Search wrecked vehicles for scraps

- Customisable points for Selling materials
  - Add a Location for an ore to the config and it will use this location for both qb-target and a prop
  - Can place them anywhere, doesn't have to be just one mining location
  - I opted for a drilling animation as opposed to the pickaxe swinging
  - Nicely animated for better immersion
  
- NPC's spawn on the blip locations
  - These locations can also give third eye and select ones have context menus for selling points

- Features simplistic built in crafting that uses recipes in the config.lua

## Video Previews
- Wreck/Scrap Searching: https://streamable.com/2oushi
- Dumpster Driving: https://streamable.com/pju3wn
- Recycling center & Material Selling: https://streamable.com/16w1pk

## Dependencies
- qb-menu - for the menus
- qb-target - for the third eye selection

# How to install
## Minimal
If you want to use your own items or repurpose this script:
- Place in your resources folder
- add the following code to your server.cfg/resources.cfg **below** `[qb]`
```
ensure jim-recycle
```
If you want to use my items then:

- Add the images to your inventory folder

- Put these lines in your items.lua

```lua
-- jim-recycle stuff
["recyclablematerial"]  = {["name"] = "recyclablematerial",   ["label"] = "Recycle Box",      ["weight"] = 100, ["type"] = "item", 		["image"] = "recyclablematerial.png",   ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A box of Recyclable Materials"},
["bottle"]              = {["name"] = "bottle",               ["label"] = "Empty Bottle",     ["weight"] = 10,  ["type"] = "item", 		["image"] = "bottle.png",               ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A glass bottle"},
["can"]                 = {["name"] = "can",                  ["label"] = "Empty Can",        ["weight"] = 10,  ["type"] = "item", 		["image"] = "can.png",                  ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "An empty can, good for recycling"},
```
