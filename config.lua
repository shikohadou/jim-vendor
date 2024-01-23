print("^2Jim-Vendor ^7v^41^7.^40^7.^40 ^7- ^2Vendor Script by ^1Jimathy^7")

Loc = {}

Config = {
	Debug = false, -- enable debug mode
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	img = "qb-inventory/html/images/", --Set this to the image directory of your inventory script or "nil" if using newer qb-menu
	CheckMarks = true, -- shows checkmarks if user has the materials to craft an item, set false if causing lag.
	Lan = "en", -- Pick your language here
	JimMenu = true, -- Set this to true if using update qb-menu with icons
	JimShops = false, -- Set this to true if using jim-shops
	Job = nil, -- set this to a job role eg "miner" or nil for no job
	Notify = "qb",
	K4MB1 = false,
	K4MB1Only = false,

	--Lighting for mines
	HangingLights = false, -- if false, will spawn work lights. if true will spawn hanging lights

	Timings = { -- Time it takes to do things
		["Cracking"] = math.random(9000, 11500),
		["Washing"] = math.random(10000, 12000),
		["Panning"] = math.random(25000, 30000),
		["Pickaxe"] = math.random(15000, 18000),
		["Mining"] = math.random(10000, 15000),
		["Laser"] = math.random(7000, 10000),
		["OreRespawn"] = math.random(55000, 75000),
		["Crafting"] = 8000,
	},

	Locations =  {
		['vendor'] = { -- The Location of the jewel buyer, I left this as Vangelico, others will proabably change to pawn shops
			{ name = "Vendor", coords = vector4(176.73, -1316.68, 29.35, 154.41), sprite = 527, col = 617, blipTrue = false, model = `S_M_M_HighSec_03`, scenario = "WORLD_HUMAN_CLIPBOARD", },
		},
	},


------------------------------------------------------------
	SellItems = { -- Selling Prices
	    ["dollarbills1"] = 1000,
		["dollarbills10"] = 10000,
		["dollarbills50"] = 50000,
		["dollarbills100"] = 100000,
		["dollarbills500"] = 500000,
		["1gramgold"] = 1000000,
		["10gramgold"] = 5000000,
		["50gramgold"] = 10000000,
		["100gramgold"] = 50000000,
		["500gramgold"] = 100000000,
		
		['copperore'] = 200,
		['goldore'] = 300,
		['silverore'] = 140,
		['ironore'] = 200,
		['carbon'] = 50,

		['goldingot'] = 500,
		['silveringot'] = 400,

		['uncut_emerald'] = 700,
		['uncut_ruby'] = 800,
		['uncut_diamond'] = 900,
		['uncut_sapphire'] = 600,
		['uncut_amethyst'] = 700,
		['uncut_citrine'] = 800,
		['uncut_garnet'] = 900,
		['uncut_onyx'] = 600,
		['uncut_peridot'] = 700,
		['uncut_tigereye'] = 800,
		['uncut_topaz'] = 900,

		['emerald'] = 1000,
		['ruby'] = 1000,
		['diamond'] = 1000,
		['sapphire'] = 1000,
		['amethyst'] = 1000,
		['citrine'] = 1000,
		['garnet'] = 1000,
		['onyx'] = 1100,
		['peridot'] = 1000,
		['tigereye'] = 1000,
		['topaz'] = 1000,

		
		['diamond_ring'] = 3000,
		['emerald_ring'] = 3400,
		['ruby_ring'] = 3500,
		['sapphire_ring'] = 3700,
	
		['diamond_ring_silver'] = 1200,
		['emerald_ring_silver'] = 1100,
		['ruby_ring_silver'] = 1200,
		['sapphire_ring_silver'] = 1900,

		['diamond_necklace'] = 3900,
		['emerald_necklace'] = 3200,
		['ruby_necklace'] = 3900,
		['sapphire_necklace'] = 3800,
	
		['diamond_necklace_silver'] = 2600,
		['emerald_necklace_silver'] = 2400,
		['ruby_necklace_silver'] = 2200,
		['sapphire_necklace_silver'] = 2400,

		['diamond_earring'] = 3800,
		['emerald_earring'] = 3200,
		['ruby_earring'] = 3600,
		['sapphire_earring'] = 3700,
	
		['diamond_earring_silver'] = 2300,
		['emerald_earring_silver'] = 3600,
		['ruby_earring_silver'] = 2500,
		['sapphire_earring_silver'] = 2100,

		['gold_ring'] = 1000,
		['goldchain'] = 900,
		['goldearring'] = 700,
		['silver_ring'] = 600,
		['silverchain'] = 400,
		['silverearring'] = 400,
		['gold_bracelet'] = 600,
		['silver_bracelet'] = 500,

		--Extra jewelery
		['amethyst_earring'] = 3800,
		['citrine_earring'] = 3200,
		['garnet_earring'] = 3600,
		['onyx_earring'] = 3700,
		['peridot_earring'] = 3400,
		['tigereye_earring'] = 3200,
		['topaz_earring'] = 3300,

		['amethyst_earring_silver'] = 2800,
		['citrine_earring_silver'] = 2200,
		['garnet_earring_silver'] = 2600,
		['onyx_earring_silver'] = 2700,
		['peridot_earring_silver'] = 2400,
		['tigereye_earring_silver'] = 2200,
		['topaz_earring_silver'] = 2300,

		['amethyst_necklace'] = 3800,
		['citrine_necklace'] = 3200,
		['garnet_necklace'] = 3200,
		['onyx_necklace'] = 3700,
		['peridot_necklace'] = 3400,
		['tigereye_necklace'] = 3200,
		['topaz_necklace'] = 3300,

		['amethyst_necklace_silver'] = 2800,
		['citrine_necklace_silver'] = 2200,
		['garnet_necklace_silver'] = 2600,
		['onyx_necklace_silver'] = 2700,
		['peridot_necklace_silver'] = 2400,
		['tigereye_necklace_silver'] = 2200,
		['topaz_necklace_silver'] = 2300,

		['amethyst_ring'] = 3800,
		['citrine_ring'] = 3200,
		['garnet_ring'] = 3600,
		['onyx_ring'] = 3700,
		['peridot_ring'] = 3400,
		['tigereye_ring'] = 3200,
		['topaz_ring'] = 3300,

		['amethyst_ring_silver'] = 2800,
		['citrine_ring_silver'] = 2700,
		['garnet_ring_silver'] = 2690,
		['onyx_ring_silver'] = 2700,
		['peridot_ring_silver'] = 2400,
		['tigereye_ring_silver'] = 2200,
		['topaz_ring_silver'] = 2300,
		
		--Braclets
		['diamond_bracelet'] = 100,
		['ruby_bracelet'] = 100,
		['sapphire_bracelet'] = 100,
		['emerald_bracelet'] = 100,
		
		['diamond_bracelet_silver'] = 100,
		['ruby_bracelet_silver'] = 100,
		['sapphire_bracelet_silver'] = 100,
		['emerald_bracelet_silver'] = 100,
		
		['amethyst_bracelet'] = 3800,
		['citrine_bracelet'] = 3200,
		['garnet_bracelet'] = 3600,
		['onyx_bracelet'] = 3700,
		['peridot_bracelet'] = 3400,
		['tigereye_bracelet'] = 3200,
		['topaz_bracelet'] = 3300,
		
		['amethyst_bracelet_silver'] = 2800,
		['citrine_bracelet_silver'] = 2700,
		['garnet_bracelet_silver'] = 2690,
		['onyx_bracelet_silver'] = 2700,
		['peridot_bracelet_silver'] = 2400,
		['tigereye_bracelet_silver'] = 2200,
		['topaz_bracelet_silver'] = 2300,
		
		--Brooches
		['gold_brooch'] = 1200,
		['silver_brooch'] = 1100,		
		['diamond_brooch'] = 3000,
		['emerald_brooch'] = 3400,
		['ruby_brooch'] = 3500,
		['sapphire_brooch'] = 3700,
	
		['diamond_brooch_silver'] = 1200,
		['emerald_brooch_silver'] = 1100,
		['ruby_brooch_silver'] = 1200,
		['sapphire_brooch_silver'] = 1900,

		['amethyst_brooch'] = 3800,
		['citrine_brooch'] = 3200,
		['garnet_brooch'] = 3600,
		['onyx_brooch'] = 3700,
		['peridot_brooch'] = 3400,
		['tigereye_brooch'] = 3200,
		['topaz_brooch'] = 3300,
		
		['amethyst_brooch_silver'] = 2800,
		['citrine_brooch_silver'] = 2700,
		['garnet_brooch_silver'] = 2690,
		['onyx_brooch_silver'] = 2700,
		['peridot_brooch_silver'] = 2400,
		['tigereye_brooch_silver'] = 2200,
		['topaz_brooch_silver'] = 2300,

		--Rainbow Set
		['rainbow_necklace'] = 5700,
		['rainbow_ring'] = 5500,
		['rainbow_earring'] = 5400,
		['rainbow_bracelet'] = 5100,
		['rainbow_brooch'] = 5100,
	
		['rainbow_necklace_silver'] = 4700,
		['rainbow_ring_silver'] = 4500,
		['rainbow_earring_silver'] = 4400,
		['rainbow_bracelet_silver'] = 4100,
		['rainbow_brooch_silver'] = 5100,

	},
}