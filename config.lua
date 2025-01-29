Config = {}

-- Mining zones where players can collect raw ore
Config.MiningZones = {
    { name = "Mining Site 1", coords = vector3(2950.0, 2790.0, 41.0), radius = 10.0 },
    { name = "Mining Site 2", coords = vector3(2980.0, 2775.0, 43.0), radius = 10.0 }
    -- Add more sites if needed
}

-- Ore processing zone
Config.ProcessingZone = {
    name = "Ore Processing Area",
    coords = vector3(1109.0, -2008.0, 30.0),
    radius = 2.0
}

-- Selling zone for refined ore
Config.SellingZone = {
    name = "Mineral Selling Point",
    coords = vector3(-620.0, -226.0, 38.0),
    radius = 2.0
}

-- Time (in seconds) to mine once (animation time)
Config.MineTime = 5

-- Whether the player needs a pickaxe item to mine
Config.RequirePickaxe = true
Config.PickaxeItem = "pickaxe"  -- Must match an item name in your database

-- Which item the player receives when mining
Config.MinedItem = "raw_ore"      -- Item name in the DB
Config.MinedItemQuantity = {min = 1, max = 3}  -- random quantity range

-- Refined item details
Config.ProcessedItem = "refined_ore"
Config.ProcessTime = 3  -- seconds per raw ore to refine

-- Selling price for each refined ore
Config.SellPrice = 100

-- Notifications / Locales
Config.Locale = {
    no_pickaxe         = "You need a ~r~pickaxe~w~ to mine.",
    mining_help        = "Press ~INPUT_CONTEXT~ to mine.",
    processing_help    = "Press ~INPUT_CONTEXT~ to process ore.",
    selling_help       = "Press ~INPUT_CONTEXT~ to sell ore.",
    no_mineral         = "You don't have any ore to process or sell.",
    processing_message = "Processing the ore...",
    sell_message       = "Selling the ore...",
    mined_message      = "You received %d of raw ore.",
    processed_message  = "You processed %d of ore.",
    sold_message       = "You sold %d of ore and earned $%d.",
    wait_message       = "Please wait...",
    not_enough_space   = "You don't have enough inventory space."
}
