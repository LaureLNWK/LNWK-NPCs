-- DO NOT CHANGE THE BELLOW IF YOU DO NOT KNOW WHAT YOU ARE DOING
RegisterCommand('PlacePed', function(source, args, rawCommand)
    local pedName = args[1] 
    local pedType = args[2] 
    local pedGender = args[3] 

    if not pedName or not pedType or not pedGender then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^8ERROR', 'Invalid syntax. Use /PlacePed "name" "type" "gender" NAME = PED NAME IN CFG, TYPE = MP OR SP PED, GENDER = MALE OR FEMALE.. PROPER USE OF COMMAND /PlacePed "TEST" "true" "male"' }
        })
        return
    end

    local useMPClothing = (pedType:lower() == "true")
    if pedType:lower() ~= "true" and pedType:lower() ~= "false" then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^8ERROR', 'Invalid type. Use "true" or "false" for type.' }
        })
        return
    end

    if pedGender:lower() ~= "male" and pedGender:lower() ~= "female" then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^8ERROR', 'Invalid gender. Use "male" or "female" for gender.' }
        })
        return
    end

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local pedConfig = string.format([[    {
        name = "%s", -- Name for the NPC
        useMPClothing = %s, -- Enable//Disable MP Clothing usage
        useMPGender = "%s", -- Gender for MP Clothing
        model = "%s", -- Spawned Ped Model
        coords = vector4(%f, %f, %f, %f), -- Ped Location X, Y, Z, H
        animationDict = "anim@heists@heist_corona@single_team", -- Animation Directory
        animation = "single_team_loop_boss", -- Animation
        mpClothing = {
            components = { -- Clothing components
                { componentId = 1, drawableId = 3, textureId = 0 }, -- Masks
                { componentId = 3, drawableId = 0, textureId = 0 }, -- Arms
                { componentId = 4, drawableId = 18, textureId = 0 }, -- Legs
                { componentId = 5, drawableId = 0, textureId = 0 }, -- Bags
                { componentId = 6, drawableId = 0, textureId = 0 }, -- Shoes
                { componentId = 7, drawableId = 0, textureId = 0 }, -- Accessories
                { componentId = 8, drawableId = 10, textureId = 0 }, -- Undershirts
                { componentId = 9, drawableId = 0, textureId = 0 }, -- Body Armor
                { componentId = 10, drawableId = 0, textureId = 0 }, -- Decals
                { componentId = 11, drawableId = 23, textureId = 0 } -- Tops
            },
            props = { -- Props
                { propId = 0, drawableId = 5, textureId = 0 }, -- Hats
                { propId = 1, drawableId = 0, textureId = 0 }, -- Glasses
                { propId = 2, drawableId = 0, textureId = 0 }, -- Ears
                { propId = 6, drawableId = 0, textureId = 0 }, -- Watches
                { propId = 7, drawableId = 0, textureId = 0 } -- Bracelets
            }
        }
    }]], pedName, tostring(useMPClothing), pedGender:lower(), 
        useMPClothing and (pedGender:lower() == "male" and "mp_m_freemode_01" or "mp_f_freemode_01") or "S_M_Y_Sheriff_01", 
        playerCoords.x, playerCoords.y, playerCoords.z-1.0, heading)

    local resourceName = GetCurrentResourceName()
    local configPath = "config.lua"
    local existingConfig = LoadResourceFile(resourceName, configPath)

    if not existingConfig then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^1Error', 'Failed to load config.lua. Make sure it exists.' }
        })
        print("Failed to load config.lua.")
        return
    end

    local updatedConfig = existingConfig:gsub("(Config.NPCs%s*=%s*%{)", "%1\n" .. pedConfig .. ",")
    local success = SaveResourceFile(resourceName, configPath, updatedConfig, -1)

    if success then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^2Success', 'Ped configuration saved successfully!' }
        })
        print("Ped configuration saved successfully!")
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^1Error', 'Failed to save Ped configuration.' }
        })
        print("Failed to save Ped configuration.")
    end
end, false)