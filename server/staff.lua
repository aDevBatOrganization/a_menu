-- ########################################
-- Regarder le steam id de tous les joueurs
-- ########################################

function getSteamId(playerId)
    local steamIdentifier = GetPlayerIdentifiers(playerId)
    for key, value in pairs(steamIdentifier) do
        if string.match(value, "steam:") then
            return value
        end
    end
    return nil
end

RegisterNetEvent("healMe")
AddEventHandler("healMe", function(source)
    local steamIdentifier = getSteamId(source)

    while true do
        MySQL.Async.fetchAll("SELECT * FROM user_fivem WHERE steam_id = @steamId", { ["steamId"] = steamIdentifier },
            function(result)
                for i, v in pairs(result) do
                    steamPlayerId = v.steam_id
                    food = v.food
                    drink = v.drink
                end

                if steamIdentifier == steamPlayerId then
                    MySQL.Async.execute("UPDATE user_fivem SET food = @food, drink = @drink WHERE steam_id = @steamId", {
                        ["food"] = 100,
                        ["drink"] = 100,
                        ["steamId"] = steamIdentifier
                    })
                end
            end)

        Wait(10)
    end
end, false)
