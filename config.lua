Config = {}

-- ASCII Art for Custom Code
Config.CustomCodeArt = [[
   ___              _                        ___             _             
  / __\ _   _  ___ | |_   ___   _ __ ___    / __\  ___    __| |  ___ __  __
 / /   | | | |/ __|| __| / _ \ | '_ ` _ \  / /    / _ \  / _` | / _ \\ \/ /
/ /___ | |_| |\__ \| |_ | (_) || | | | | |/ /___ | (_) || (_| ||  __/ >  < 
\____/  \__,_||___/ \__| \___/ |_| |_| |_|\____/  \___/  \__,_| \___|/_/\_\
]]

-- Function to Print the Custom Code Art
function printCustomCodeArt()
    print(Config.CustomCodeArt)
end

-- Call the function to display the ASCII art
printCustomCodeArt()

-- Display GitHub Link
print("Visit us at: https://github.com/CustomCodex")

-- NPC Coordinates
Config.NPCs = {
    { coords = vector3(-802.84088134766, 168.89665222168, 75.740501403809), heading = 10.00 },
    -- Add more NPCs here if needed
}

-- Items, weapons, and ammo available in the black market
Config.Items = {
    { name = 'WEAPON_PISTOL', label = 'Pistol', price = 350000 },
    { name = 'WEAPON_ASSAULTRIFLE', label = 'Assault Rifle', price = 900000 },
    { name = 'WEAPON_SMG_MK2', label = 'SMG MK2', price = 650000 },
    { name = 'ammo_pistol', label = 'Pistol Ammo', price = 500 },
    { name = 'ammo_rifle', label = 'Rifle Ammo', price = 1000 },

    -- New Weapons
    { name = 'WEAPON_MICROSMG', label = 'Micro SMG', price = 450000 },
    { name = 'WEAPON_SMG', label = 'SMG', price = 700000 },
    { name = 'WEAPON_SAWOFFSHOTGUN', label = 'Pump Shotgun', price = 800000 },
    
    -- Added Knife
    { name = 'WEAPON_KNIFE', label = 'Knife', price = 150000 },
}

-- Webhook URL
Config.WebhookURL = 'https://discord.com/api/webhooks/1273607519448731658/bDqHhn-Ubt44odB9sEXPPWrnlPz26ApsmAC0ISXipwtoAOienbd5nO6kaRI9dfcy4cK9'

-- Locale settings
Config.Locale = 'en'
