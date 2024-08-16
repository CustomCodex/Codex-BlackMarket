ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Function to capitalize the first letter of a string
function capitalize(str)
    if type(str) ~= "string" or str == "" then
        return str
    end
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

RegisterServerEvent('codex-blackmarket:buyItem')
AddEventHandler('codex-blackmarket:buyItem', function(itemName, quantity, paymentMethod)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = nil
    for _, v in ipairs(Config.Items) do
        if v.name == itemName then
            item = v
            break
        end
    end

    if item then
        local totalPrice = item.price * quantity
        local discount = item.discount or 0
        local discountedPrice = totalPrice - (totalPrice * discount / 100)

        if paymentMethod == 'cash' then
            if xPlayer.getMoney() >= discountedPrice then
                xPlayer.removeMoney(discountedPrice)
                GiveItemToPlayer(xPlayer, itemName, quantity)
                TriggerClientEvent('esx:showNotification', source, ('You bought %s x%d for $%d (Discounted)'):format(item.label, quantity, discountedPrice))
                SendWebhookNotification(xPlayer.getName(), itemName, quantity, discountedPrice, 'cash')
            else
                TriggerClientEvent('esx:showNotification', source, 'Not enough cash')
            end
        elseif paymentMethod == 'bank' then
            local bankAccount = xPlayer.getAccount('bank')
            if bankAccount and bankAccount.money >= discountedPrice then
                xPlayer.removeAccountMoney('bank', discountedPrice)
                GiveItemToPlayer(xPlayer, itemName, quantity)
                TriggerClientEvent('esx:showNotification', source, ('You bought %s x%d for $%d (Discounted) from your bank account'):format(item.label, quantity, discountedPrice))
                SendWebhookNotification(xPlayer.getName(), itemName, quantity, discountedPrice, 'bank')
            else
                TriggerClientEvent('esx:showNotification', source, 'Not enough money in bank account')
            end
        elseif paymentMethod == 'black_money' then
            local blackMoneyAccount = xPlayer.getAccount('black_money')
            if blackMoneyAccount and blackMoneyAccount.money >= discountedPrice then
                xPlayer.removeAccountMoney('black_money', discountedPrice)
                GiveItemToPlayer(xPlayer, itemName, quantity)
                TriggerClientEvent('esx:showNotification', source, ('You bought %s x%d for $%d (Discounted) in black money'):format(item.label, quantity, discountedPrice))
                SendWebhookNotification(xPlayer.getName(), itemName, quantity, discountedPrice, 'black_money')
            else
                TriggerClientEvent('esx:showNotification', source, 'Not enough black money')
            end
        else
            TriggerClientEvent('esx:showNotification', source, 'Invalid payment method')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Invalid item')
    end
end)

function GiveItemToPlayer(xPlayer, itemName, quantity)
    if itemName:find('weapon_') then
        xPlayer.addWeapon(itemName, 0) -- No ammo given here; can be customized
    else
        xPlayer.addInventoryItem(itemName, quantity)
    end
end

function SendWebhookNotification(playerName, itemName, quantity, totalPrice, paymentMethod)
    local currentTime = os.date('%Y-%m-%d %H:%M:%S') -- Current date and time
    local itemLabel = "Unknown Item"

    -- Find the label for the item
    for _, v in ipairs(Config.Items) do
        if v.name == itemName then
            itemLabel = v.label
            break
        end
    end

    local description = string.format(
        '**Transaction Details:**\n' ..
        '• **Player:** %s\n' ..
        '• **Item Purchased:** %s\n' ..
        '• **Quantity:** %d\n' ..
        '• **Total Price:** $%d\n' ..
        '• **Payment Method:** %s\n' ..
        '• **Date/Time:** %s\n' ..
        '• **Transaction Status:** %s',
        playerName,
        itemLabel,
        quantity,
        totalPrice,
        paymentMethod,
        currentTime,
        totalPrice > 0 and 'Successful' or 'Failed'
    )

    local data = {
        username = 'Black Market Notification',
        embeds = {{
            title = '🛒 Item Purchase Log',
            description = description,
            color = 3066993, -- Light Blue color for informational purposes
            fields = {
                {
                    name = 'Player Information',
                    value = string.format(
                        '**Player Name:** %s\n' ..
                        '**Transaction Time:** %s',
                        playerName,
                        currentTime
                    ),
                    inline = true
                },
                {
                    name = 'Item Details',
                    value = string.format(
                        '**Item Name:** %s\n' ..
                        '**Quantity:** %d\n' ..
                        '**Total Price:** $%d',
                        itemLabel,
                        quantity,
                        totalPrice
                    ),
                    inline = true
                },
                {
                    name = 'Payment Information',
                    value = string.format(
                        '**Payment Method:** %s',
                        paymentMethod
                    ),
                    inline = true
                }
            },
            footer = {
                text = 'CustomCodex Black Market System',
                icon_url = 'https://yourlogo.url/logo.png' -- Optional logo
            }
        }}
    }

    -- Print debug information
    print("Sending webhook with the following data:")
    print(json.encode(data))

    -- Perform the HTTP request
    PerformHttpRequest(Config.WebhookURL, function(statusCode, responseText, headers)
        -- Log the response from the webhook service
        print("Webhook response status code:", statusCode)
        print("Webhook response body:", responseText)
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

-- Log that the Black Market System has successfully started
print("\27[32mCodex-BlackMarket has successfully started\27[0m")
