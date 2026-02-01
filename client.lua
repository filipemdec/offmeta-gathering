local QBCore = exports['qb-core']:GetCoreObject()

--[[
    OFFMETA Gathering (client)
    Forked from qb-gathering.

    ✅ Default interaction: press E near the prop
    🔁 Optional: qb-target support (if you disable key interaction)
    ⛏️ Optional tools: pickaxe / axe props while anim plays
]]

local createdProps = {}
local KeyProps = {}
local isGathering = false

local function LoadModel(model)
    local hash = type(model) == 'number' and model or GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(10)
        end
    end
    return hash
end

local function DrawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function RemoveKeyProp(entity)
    for i = #KeyProps, 1, -1 do
        local entry = KeyProps[i]
        if entry and entry.prop == entity then
            table.remove(KeyProps, i)
            break
        end
    end
end

local function AddKeyProp(gatherable, entity)
    KeyProps[#KeyProps + 1] = { gatherable = gatherable, prop = entity }
end

local function ShouldUseKeyMode()
    if Config.KeyInteraction and Config.KeyInteraction.Enabled then
        return true
    end

    -- If key mode is disabled but qb-target isn't running, fallback to key mode
    if GetResourceState('qb-target') ~= 'started' then
        return true
    end

    return false
end

local function SpawnPickaxe(ped)
    local pickaxe = CreateObject(LoadModel('prop_tool_pickaxe'), GetEntityCoords(ped), true, true, false)
    AttachEntityToEntity(
        pickaxe,
        ped,
        GetPedBoneIndex(ped, 57005),
        0.1, 0.0, 0.0,
        0.0, 90.0, 90.0,
        true, true, false, true, 1, true
    )
    return pickaxe
end

local function SpawnAxe(ped)
    local axe = CreateObject(LoadModel('prop_ld_fireaxe'), GetEntityCoords(ped), true, true, false)
    AttachEntityToEntity(
        axe,
        ped,
        GetPedBoneIndex(ped, 57005),
        0.1, 0.0, 0.0,
        0.0, 90.0, 90.0,
        true, true, false, true, 1, true
    )
    return axe
end

local function RemoveFromCreatedProps(prop)
    for i, storedProp in ipairs(createdProps) do
        if storedProp == prop then
            table.remove(createdProps, i)
            break
        end
    end
end

-- Forward declaration (so AddInteractionForProp can call it)
function StartGathering(gatherable, prop) end

local function AddInteractionForProp(gatherable, entity)
    if ShouldUseKeyMode() then
        AddKeyProp(gatherable, entity)
        return
    end

    -- qb-target mode
    exports['qb-target']:AddTargetEntity(entity, {
        options = {
            {
                icon = Config.TargetOptions.icon,
                label = Config.TargetOptions.label,
                action = function()
                    StartGathering(gatherable, entity)
                end,
            },
        },
        distance = Config.TargetDistance,
    })
end

local function CreateBlip(gatherable)
    if gatherable.blip and gatherable.blip.enabled then
        local blip = AddBlipForCoord(gatherable.centerCoords)
        SetBlipSprite(blip, gatherable.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, gatherable.blip.scale)
        SetBlipColour(blip, gatherable.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(gatherable.blip.name)
        EndTextCommandSetBlipName(blip)
    end
end

function SpawnRandomProps(gatherable)
    gatherable.props = {}

    for i = 1, gatherable.spawnAmount do
        local randomOffset = vector3(
            math.random(-gatherable.spawnRange, gatherable.spawnRange),
            math.random(-gatherable.spawnRange, gatherable.spawnRange),
            0.0
        )

        local spawnCoords = gatherable.centerCoords + randomOffset
        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z + 100.0, true)

        if foundGround then
            spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)

            local prop = CreateObject(LoadModel(gatherable.model), spawnCoords, false, false, false)
            PlaceObjectOnGroundProperly(prop)
            FreezeEntityPosition(prop, true)

            table.insert(gatherable.props, prop)
            table.insert(createdProps, prop)

            AddInteractionForProp(gatherable, prop)
        end
    end
end

function RespawnProp(gatherable, oldProp)
    local randomOffset = vector3(
        math.random(-gatherable.spawnRange, gatherable.spawnRange),
        math.random(-gatherable.spawnRange, gatherable.spawnRange),
        0.0
    )

    local spawnCoords = gatherable.centerCoords + randomOffset
    local foundGround, groundZ = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z + 100.0, true)

    if not foundGround then return end

    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)

    local newProp = CreateObject(LoadModel(gatherable.model), spawnCoords, false, false, false)
    PlaceObjectOnGroundProperly(newProp)
    FreezeEntityPosition(newProp, true)

    for i, prop in ipairs(gatherable.props) do
        if prop == oldProp then
            gatherable.props[i] = newProp
            break
        end
    end

    table.insert(createdProps, newProp)
    AddInteractionForProp(gatherable, newProp)
end

local function DeleteAllProps()
    for _, prop in ipairs(createdProps) do
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
        RemoveKeyProp(prop)
    end

    createdProps = {}
    KeyProps = {}
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteAllProps()
    end
end)

-- Key interaction loop
CreateThread(function()
    while true do
        if Config.KeyInteraction and Config.KeyInteraction.Enabled and #KeyProps > 0 then
            local playerPed = PlayerPedId()
            local pcoords = GetEntityCoords(playerPed)

            local nearestEntry, nearestDist = nil, 9999.0

            for _, entry in ipairs(KeyProps) do
                if entry and entry.prop and DoesEntityExist(entry.prop) then
                    local ecoords = GetEntityCoords(entry.prop)
                    local dist = #(pcoords - ecoords)

                    if dist < (Config.KeyInteraction.Distance or 2.0) and dist < nearestDist then
                        nearestEntry = entry
                        nearestDist = dist
                    end
                end
            end

            if nearestEntry then
                if Config.KeyInteraction.FloatingText then
                    local label = (Config.TargetOptions and Config.TargetOptions.label) or 'Interact'
                    local key = (Config.KeyInteraction.KeyLabel or 'E')
                    local prompt = string.format(Config.KeyInteraction.Prompt or 'Press [%s] to %s', key, label)

                    local ecoords = GetEntityCoords(nearestEntry.prop)
                    DrawText3D(ecoords.x, ecoords.y, ecoords.z + 1.0, prompt)
                end

                if not isGathering and IsControlJustReleased(0, Config.KeyInteraction.Control or 38) then
                    StartGathering(nearestEntry.gatherable, nearestEntry.prop)
                    -- small debounce
                    Wait(300)
                else
                    Wait(0)
                end
            else
                Wait(150)
            end
        else
            Wait(350)
        end
    end
end)

-- Initial spawn
CreateThread(function()
    Wait(250)
    for _, gatherable in pairs(Config.Gatherables) do
        SpawnRandomProps(gatherable)
        CreateBlip(gatherable)
    end
end)

-- Optional maintenance: ensure props exist (useful after server restart / entity cleanup)
CreateThread(function()
    if not Config.Maintenance or not Config.Maintenance.Enabled then return end

    local interval = Config.Maintenance.CheckInterval or 30000

    while true do
        Wait(interval)

        for _, gatherable in pairs(Config.Gatherables) do
            local needsRespawn = false

            if not gatherable.props or #gatherable.props == 0 then
                needsRespawn = true
            else
                for _, prop in ipairs(gatherable.props) do
                    if not DoesEntityExist(prop) then
                        needsRespawn = true
                        break
                    end
                end
            end

            if needsRespawn then
                -- cleanup anything that still exists
                if gatherable.props then
                    for _, prop in ipairs(gatherable.props) do
                        if DoesEntityExist(prop) then
                            DeleteEntity(prop)
                        end
                        RemoveKeyProp(prop)
                        RemoveFromCreatedProps(prop)
                    end
                end

                gatherable.props = {}
                SpawnRandomProps(gatherable)
            end
        end
    end
end)

-- Main gather function
function StartGathering(gatherable, prop)
    if isGathering then return end
    if not gatherable or not prop or not DoesEntityExist(prop) then return end

    isGathering = true

    local ped = PlayerPedId()
    local tool = nil

    if gatherable.spawnPickaxe then
        tool = SpawnPickaxe(ped)
    elseif gatherable.spawnAxe then
        tool = SpawnAxe(ped)
    end

    local minAmount = (gatherable.rewardAmount and gatherable.rewardAmount.min) or 1
    local maxAmount = (gatherable.rewardAmount and gatherable.rewardAmount.max) or minAmount
    local amount = math.random(minAmount, maxAmount)

    QBCore.Functions.Progressbar(
        'offmeta_gathering',
        gatherable.progressText or 'Gathering...',
        gatherable.progressTime or 5000,
        false,
        true,
        {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        {
            animDict = gatherable.animation.dict,
            anim = gatherable.animation.anim,
            flags = 49,
        },
        {},
        {},
        function() -- success
            TriggerServerEvent('offmeta-gathering:server:giveItem', gatherable.name, amount)

            local msg = (Config.Notifications and Config.Notifications.Success) or '✅ Collected %sx %s'
            QBCore.Functions.Notify(msg:format(amount, gatherable.label or gatherable.name), 'success')

            if tool then
                DeleteEntity(tool)
            end

            ClearPedTasks(ped)

            if DoesEntityExist(prop) then
                DeleteObject(prop)
            end

            RemoveKeyProp(prop)
            RemoveFromCreatedProps(prop)

            RespawnProp(gatherable, prop)
            isGathering = false
        end,
        function() -- cancel
            if tool then
                DeleteEntity(tool)
            end
            ClearPedTasks(ped)

            local msg = (Config.Notifications and Config.Notifications.Canceled) or '❌ Action canceled'
            QBCore.Functions.Notify(msg, 'error')

            isGathering = false
        end
    )
end
