local invertedHighPriorityItems = {}
local invertedHighPriorityCharacters = {}
local highPriorityComponents = {}

local signalComponents = {}

if SERVER then
    Game.mapEntityUpdateInterval = PerformanceFix.Config.serverMapEntityUpdateInterval
    Game.characterUpdateInterval = PerformanceFix.Config.serverCharacterUpdateInterval
    Game.gapUpdateInterval = PerformanceFix.Config.serverGapUpdateInterval

    highPriorityComponents = PerformanceFix.Config.serverComponentPriority

    for key, value in pairs(PerformanceFix.Config.serverItemHighPriority) do
        invertedHighPriorityItems[value] = key 
    end

    for key, value in pairs(PerformanceFix.Config.highPriorityCharacters) do
        invertedHighPriorityCharacters[value] = key
    end
    
    Hook.Add("item.equip", "highPriorityHands", function (item, char)
        Game.RemovePriorityItem(item)
        Game.AddPriorityItem(item)
    end)

else
    pcall(function ()
        Game.mapEntityUpdateInterval = PerformanceFix.Config.clientMapEntityUpdateInterval
        Game.characterUpdateInterval = PerformanceFix.Config.clientCharacterUpdateInterval
        Game.gapUpdateInterval = PerformanceFix.Config.clientGapUpdateInterval

        if Game.IsMultiplayer then
            Game.poweredUpdateInterval = PerformanceFix.Config.poweredUpdateInterval or 1
        end
    end)

    highPriorityComponents = PerformanceFix.Config.clientComponentPriority

    for key, value in pairs(PerformanceFix.Config.clientItemHighPriority) do
        invertedHighPriorityItems[value] = key
    end

    for key, value in pairs(PerformanceFix.Config.highPriorityCharacters) do
        invertedHighPriorityCharacters[value] = key
    end

    Hook.Add("item.equip", "highPriorityHands", function (item, char)
        Game.RemovePriorityItem(item)
        Game.AddPriorityItem(item)
    end)
end


Hook.Add("think", "signalUpdatePerformanceFix", function ()
    for key, value in pairs(signalComponents) do
        value.SendSignal(tostring(Game.mapEntityUpdateInterval), "signal_out")
    end
end)

local function SetPriority()
    if CLIENT then
        for k, v in pairs(Item.ItemList) do
            if PerformanceFix.Config.allowSingleplayerPermanentConfigs and Game.IsSingleplayer then
                break
            end

            if string.find(v.Tags, "performancefix") then
                table.insert(signalComponents, v)
            end

            local light = v.GetComponentString("LightComponent")
    
            if light ~= nil then
                if PerformanceFix.Config.disableShadowCastingLights then
                    light.CastShadows = false
                end
                if PerformanceFix.Config.disableDrawBehindSubsLights then
                    light.DrawBehindSubs = false
                end
            end

            if PerformanceFix.Config.hideInGameWires then
                local wire = v.GetComponentString("Wire")
        
                if wire and #wire.Connections ~= 0 then
                    wire.Item.HiddenInGame = true
                end
            end

            if PerformanceFix.Config.hideInGameComponents then  
                if v.HasTag("logic") then
                    v.HiddenInGame = true
                end
            end
        end
    end

    Game.ClearPriorityItem()
    Game.ClearPriorityCharacter()

    for key, value in pairs(Item.ItemList) do
        if invertedHighPriorityItems[value.Prefab.Identifier.Value] ~= nil then
            Game.AddPriorityItem(value)
        else

            for _, comp in pairs(highPriorityComponents) do
                if value.GetComponentString(comp) ~= nil then
                    Game.AddPriorityItem(value)
                end
            end
        end
    end

     for key, value in pairs(Character.CharacterList) do
        if invertedHighPriorityCharacters[value.SpeciesName.Value] then
            Game.AddPriorityCharacter(value)
        end

        if value.Inventory ~= nil then
            local rightItem = value.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)
            local leftItem = value.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

            if rightItem ~= nil then
                Game.AddPriorityItem(rightItem)
            end

            if leftItem ~= nil then
                Game.AddPriorityItem(leftItem)
            end
        end
    end
end

Hook.Add("roundStart", "initRoundStart", function()
    Timer.Wait(function()
        SetPriority()
    end, 1000)
end)


Hook.Add("characterCreated", "addToPriority", function (character)
    if invertedHighPriorityCharacters[character.SpeciesName.Value] then
        Game.AddPriorityCharacter(character)
    end
end)


SetPriority()