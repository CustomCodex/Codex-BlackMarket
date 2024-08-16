ESX = nil
local isMenuOpen = false
local originalText = "~w~Press E to interact with the black market"
local menuLines = {
    "Hi gangsta,",
    "Select your weapon with ammo.",
    "Bro don't get shot this time oke?"
}
local menuTextDisplayed = false
local menuTextStartTime = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Load NPC model and create NPCs
Citizen.CreateThread(function()
    RequestModel('a_m_m_business_01')
    while not HasModelLoaded('a_m_m_business_01') do
        Citizen.Wait(500)
    end

    for _, npc in ipairs(Config.NPCs) do
        local ped = CreatePed(4, 'a_m_m_business_01', npc.coords, npc.heading, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetPedCanRagdoll(ped, false)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        -- Create a text label above the NPC's head
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                local playerPed = PlayerPedId()
                local npcCoords = GetEntityCoords(ped)
                local playerCoords = GetEntityCoords(playerPed)
                local npcHeight = npcCoords.z + 1.0

                if not isMenuOpen then
                    if Vdist(playerCoords, npcCoords) < 2.0 then
                        -- Animate text
                        local time = GetGameTimer()
                        local offset = math.sin(time / 500) * 0.05 -- Animation effect
                        DrawText3D(npcCoords.x, npcCoords.y, npcHeight + offset, originalText)
                    end
                else
                    if menuTextDisplayed then
                        if Vdist(playerCoords, npcCoords) < 2.0 then
                            -- Display typing text
                            local time = GetGameTimer()
                            local elapsed = (time - menuTextStartTime) / 1000 -- Elapsed time in seconds
                            local currentLineIndex = math.floor(elapsed / 2) + 1 -- Show new line every 2 seconds
                            local textToDisplay = menuLines[currentLineIndex] or ""
                            DrawText3D(npcCoords.x, npcCoords.y, npcHeight, textToDisplay)
                        end
                    end
                end
            end
        end)
    end
end)

-- Show 3D text function with multi-line support
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local distance = Vdist(px, py, pz, x, y, z)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0, scale * 0.3) -- Smaller text size
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215) -- White color
        SetTextEntry("STRING")

        -- Draw the current line
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Open menu and manage interaction
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for _, npc in ipairs(Config.NPCs) do
            local npcCoords = npc.coords
            if Vdist(coords, npcCoords) < 2.0 and not isMenuOpen then
                if IsControlJustReleased(0, 38) then -- E key
                    isMenuOpen = true
                    menuTextDisplayed = false -- Start typing effect
                    TriggerEvent('showMenuText') -- Show new text after 2 seconds
                    OpenBlackMarketMenu()
                end
            end
        end
    end
end)

function OpenBlackMarketMenu()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'black_market_menu',
        {
            title = 'Black Market',
            align = 'top-left',
            elements = GetMenuElements()
        },
        function(data, menu)
            local item = data.current
            if item.value then
                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'black_market_confirm',
                    {
                        title = ('Buy %s for $%d'):format(item.label, item.price),
                        align = 'top-left',
                        elements = {
                            { label = 'Cash', value = 'cash' },
                            { label = 'Bank', value = 'bank' },
                            { label = 'Black Money', value = 'black_money' }
                        }
                    },
                    function(confirmData, confirmMenu)
                        if confirmData.current.value then
                            TriggerServerEvent('codex-blackmarket:buyItem', item.value, 1, confirmData.current.value)
                        end
                        confirmMenu.close()
                        isMenuOpen = false
                        menuTextDisplayed = false -- Restore the original text
                    end,
                    function(data, menu)
                        menu.close()
                        isMenuOpen = false
                        menuTextDisplayed = false -- Restore the original text
                    end
                )
            end
        end,
        function(data, menu)
            menu.close()
            isMenuOpen = false
            menuTextDisplayed = false -- Restore the original text
        end
    )
end

-- Trigger event to show menu text after a delay
AddEventHandler('showMenuText', function()
    Citizen.Wait(2000) -- Wait for 2 seconds
    menuTextDisplayed = true
    menuTextStartTime = GetGameTimer() -- Start typing effect timer
end)

function GetMenuElements()
    local elements = {}
    for _, item in ipairs(Config.Items) do
        table.insert(elements, {
            label = item.label,
            value = item.name,
            price = item.price
        })
    end
    return elements
end
