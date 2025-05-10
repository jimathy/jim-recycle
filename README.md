# jim-recycle

FiveM Recycle center and Dumpster Diving script

- Highly customisable via config.lua
  - Locations are easily changeable/removable

- Features several ways to get materials
  - Recycle Center - Trade recyclable Materials to get crafting materials
  - Dumpster Diving - Search dumpsters and trash cans for materials
  - Scrapping - Search wrecked vehicles for scraps

- Customisable points for Selling materials
  - Nicely animated for better immersion

- Supports QB-Core, ESX, QBOX, OX_Core

## Video Previews
- Wreck/Scrap Searching: https://streamable.com/2oushi
- Dumpster Driving: https://streamable.com/pju3wn
- Recycling center & Material Selling: https://streamable.com/16w1pk

## Dependencies
- qb-menu/ox_lib - for the menus
- qb-target/ox_target - for the third eye selection

# How to install

## QB:
- You first need jim_bridge https://github.com/jimathy/jim_bridge
  - Download this and place it in your `[standalone]` folder
- Unzip `jim-recycle` and place the folder into your resources folder eg. `resources/[jim]`
- add the following line to your server.cfh **below** `[qb]`
- ensure jim-recycle

### Item installation

- Add the images to your inventory folder
  - for example: `[qb] > qb-inventory > html > images`
- Add the items to your core shared items file `items.lua`

```lua
-- Jim-Recycle Items
recyclablematerial  = { name = "recyclablematerial",   label = "Recycle Box",      weight = 100, type = "item", 		image = "recyclablematerial.png",   unique = false, 	useable = false, 	shouldClose = false, combinable = nil,   description = "A box of Recyclable Materials"},
bottle              = { name = "bottle",               label = "Empty Bottle",     weight = 10,  type = "item", 		image = "bottle.png",               unique = false, 	useable = false, 	shouldClose = false, combinable = nil,   description = "A glass bottle"},
can                 = { name = "can",                  label = "Empty Can",        weight = 10,  type = "item", 		image = "can.png",                  unique = false, 	useable = false, 	shouldClose = false, combinable = nil,   description = "An empty can, good for recycling"},
```


## OX_Inventory/QBOX:
- You first NEED jim_bridge: https://github.com/jimathy/jim_bridge
  - Download this and place it in your `[standalone]` folder
- Unzip `jim-recycle` and place the folder into your resources folder eg. `resources/[jim]`
- add the following line to your server.cfh **below** `[qb]`
- ensure jim-recycle

### Item installation

- Add the images to your inventory folder
  - for example: `[ox] > ox_inventory > web > images`
- Add the items to your shared items file `[ox] > ox_inventory > data > items.lua`

```lua
-- Jim-Recycle Items
    recyclablematerial = {
        name = "recyclablematerial",
        label = "Recycle Box",
        weight = 100,
        client = {
          image = "recyclablematerial.png",
        }
    },
    bottle = {
        name = "bottle",
        label = "Empty Bottle",
        weight = 10,
        client = {
          image = "bottle.png",
        }
    },
    can = {
        name = "can",
        label = "Empty Can",
        weight = 10,
        client = {
          image = "can.png",
        }
    },
```