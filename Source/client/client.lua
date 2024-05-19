ESX              = nil
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
	PlayerData = ESX.GetPlayerData()
end)

local ResourceName = GetCurrentResourceName()
local showUI = false

RegisterNUICallback('CloseUI', function(data,cb)
	TriggerScreenblurFadeOut(true)
	SetNuiFocus(false, false)
	showUI = data.showUI
	cb("ok")
end)

RegisterNUICallback('Purchase', function(data,cb)
	TriggerScreenblurFadeOut(true)
	SetNuiFocus(false, false)
	local items = data.items
	showUI = data.showUI
	local Total = data.Total
	print(json.encode(items))
	print(Total)
	cb("ok")
end)

Citizen.CreateThread(function()
	while true do

		local playerped = PlayerPedId()
		local coords = GetEntityCoords(playerped)
		local sleep = 1000
		

		if not showUI then
			for k, v in pairs(Shop.listShop) do
				for i = 1, #v.Pos, 1 do
					local mx = Vdist(coords.x,coords.y,coords.z, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)  
					if (mx <  Shop.distance) then
						-- sleep = 100

						local job = false
						if mx < v.Pos[i].Distance and not showUI then
							sleep = 4

								if(next(v.job) ~= nil and not job) then
									local PlayerData = ESX.GetPlayerData()
									if v.job[1] ~= nil then
										for i = 1, #v.job, 1 do
											if PlayerData.job.name == v.job[i] then
												job = true
											end
										end
									end
								else
									job = true
								end
							if job then
								exports[Shop.Notify.name]:ShowHelpNotification(Shop.Notify.message)
								if v.DrawText3D then
									DrawText3D(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z+0.9, v.npc.name)
								end
								if IsControlJustPressed(0, Keys['E']) and GetEntityHealth(playerped) > 0 then
									showUI = true
									local items = getItems(v.item)
									SetNuiFocus(true, true)
									TriggerScreenblurFadeIn(true)
									SendNUIMessage({
										marketName = k,
										showUI = showUI,
										ResourceName = ResourceName,
										items = items,
										inventoryPath = Shop.inventoryPath
									})
								end
							end
						end
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == ResourceName then
		TriggerScreenblurFadeOut(true)
		SetNuiFocus(false, false)
	end
end)
--- สร้างรายการสินค้า
getItems = function(items)
	local listItem = {}
	local Inventorys = ESX.GetPlayerData().inventory
	for typeitem,q in pairs(items) do
		for i, j in pairs(q) do	
			for _, item in pairs(Inventorys) do	
				if item.name == i then
				table.insert(listItem, {typeitem = typeitem ,name = item.name, label = item.label, count = item.count, price = j.price, max = j.max, limit = item.limit})
				end
			end
		end
	end
	return listItem
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString('<font face="font4thai">'..text..'</font>')
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

--- สร้าง NPC
Citizen.CreateThread(function()
	for k, v in pairs(Shop.listShop) do
		if v.npc.enable then
			for i = 1, #v.Pos, 1 do
				DeletePed()
				local ped = GetHashKey(v.npc.model)
				RequestModel(ped)
				while not HasModelLoaded(ped) do
					Wait(1)
				end
				local npc = CreatePed(4, ped, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-1.0, v.npc.heading, false, true)
				FreezeEntityPosition(npc, true)
				SetEntityInvincible(npc, true)
				SetBlockingOfNonTemporaryEvents(npc, true)
				TaskStartScenarioInPlace(npc, v.npc.dict, 0, true)
			end
		end
	end
end)

--- สร้าง Blips
Citizen.CreateThread(function()
    for k,v in pairs(Shop.listShop) do		
        if v.BlipsOpen then
            for i = 1, #v.Pos, 1 do
                local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
                    SetBlipSprite (blip, 52) --562
                    SetBlipDisplay(blip, 4)
                    SetBlipScale  (blip, 0.6)
                    SetBlipColour (blip, 0)
                    SetBlipAsShortRange(blip, true)
                    AddTextEntry('e', '<font face="font4thai">'..k..'</font>')
                    BeginTextCommandSetBlipName("e")   
                    EndTextCommandSetBlipName(blip)
            end 
        end
    end
end)