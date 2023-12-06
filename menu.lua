local xPlayer = GetPlayerPed(-1)


Config = {}

Config.isDebug = true


function Log(text)
    if (Config.isDebug) then
        print(text)
    end
end

function LogError(text)
    if text then
        Log("^1" .. text)
    end
end

-- create a new menu pool
local menuPool = MenuPool()

-- most basic loop for the menu
Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)

        -- call the Process function of the menu pool (needs to be called every frame)
        menuPool:Process(function(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
            -- create your menu here!
            CreateMenu(screenPosition, worldPosition, hitEntityHandle)
        end)
    end
end)


function CreateMenu(screenPosition, worldPosition, hitEntityHandle)
    -- call this when you need to recreate a menu
    menuPool:Reset()

    -- create the main menu
    local aMenu = menuPool:AddMenu()

    -- change the menus default opacity for all items
    aMenu.opacity = 100

    -- change the menus default text color (list of named colors can be found in Drawables/Color.lua)
    aMenu.colors.text = Colors.White

    -- alternatively you can create a new color like this (RGB or RGBA ranging from 0-255)
    -- aMenu.colors.text = Colors.White
    -- aMenu.colors.text = Color(127, 0, 0, 255)

    -- change the border color of the menu
    aMenu.colors.border = Colors.Black

    ---------------------------------


    -- check, if an entity was clicked
    if (hitEntityHandle ~= nil and DoesEntityExist(hitEntityHandle)) then
        if (PlayerPedId() == hitEntityHandle) then
            -- player
            local id = aMenu:AddItem("~b~ID : ~w~" ..
                GetPlayerServerId(PlayerId()) .. "                    AtradiumRP | FA")

            -- menu admin
            local admin = menuPool:AddSubmenu(aMenu, "Menu admin")
            local heal = admin:AddItem('Heal')
            local godMod = admin:AddItem('Invinsible')

            heal.OnClick = function()
                TriggerServerEvent('healMe', GetPlayerServerId(PlayerId()))
                SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
                TriggerEvent('a_notification', "Tu vien de te heal")
                menuPool:Reset()
            end

            godMod.OnClick = function()
                if godmod == false then
                    SetEntityVisible(xPlayer, true, false)
                    godmod = true
                    TriggerEvent("a_notification", "Tu est en godmod")
                    print(xPlqyer)
                else
                    SetEntityVisible(xPlayer, false, false)
                    godmod = false
                    TriggerEvent("a_notification", "Tu n'est plus en godmod")
                end
                menuPool:Reset()
            end

            -- fin du menu admin


            local playerIdx = GetPlayerFromServerId()
            local ped = GetPlayerPed(playerIdx)
            adfs = GetPlayerServerId(PlayerId())

            print(adfs)
        elseif (IsEntityAVehicle(hitEntityHandle)) then
            -- vehicle

            local vehicle = hitEntityHandle


            if (GetNumberOfVehicleDoors(vehicle) > 0) then
                local doorMenu = menuPool:AddSubmenu(aMenu, "Ouvrire la porte")
                for i = 1, GetNumberOfVehicleDoors(vehicle), 1 do
                    local doorItem = doorMenu:AddItem("Porte " .. i)
                    doorItem.OnClick = function()
                        local door = i - 1
                        if (GetVehicleDoorAngleRatio(vehicle, door) < 0.1) then
                            SetVehicleDoorOpen(vehicle, door, false, false)
                        else
                            SetVehicleDoorShut(vehicle, door, false)
                        end
                    end
                end
            end

            if (IsThisModelABoat(GetEntityModel(vehicle))) then
                local anchorItem = aMenu:AddItem("Ancre")
                anchorItem.OnClick = function()
                    SetBoatAnchor(vehicle, true)
                end
            end

            -- ped
        elseif (IsEntityAPed(hitEntityHandle)) then
            local ped = hitEntityHandle
            local pedId = GetPlayerServerId(PlayerId(hitEntityHandle))
        elseif (GetEntityModel(hitEntityHandle)) then
            if GetEntityModel(hitEntityHandle) == GetHashKey('bkr_prop_weed_lrg_01b') then
                local weed = aMenu:AddItem("Recolter Weed")
                weed.OnClick = function()
                    print("Recolte WEED")
                    Wait(2000)
                    menuPool:Reset()
                end
            else
                print("pas de props valide")
            end
        end
    end

    -- sets the position of the menu on the screen
    aMenu:SetPosition(screenPosition)
    -- set the visibility of the menu
    aMenu:Visible(true)
end
