# Codex Black Market

![Codex Black Market](https://i.imgur.com/nKWl5u4.png) <!-- Replace with your actual logo URL -->

## Overview

Codex Black Market is a FiveM script that introduces a dynamic black market system. Enhance your role-playing server with interactive NPCs, item purchases, and real-time transaction logging.

## Features

- **Dynamic NPC Spawns**: NPCs appear at random locations and times.
- **Discount System**: Apply discounts to items.
- **Webhook Notifications**: Log transactions to Discord.
- **Flexible Payment Options**: Supports cash, bank, and black money.
- **Lua 5.4 Compatibility**: Updated for Lua 5.4.

## Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/CustomCodex/codex-blackmarket.git
    ```

2. **Add to Resources**: Place the `codex-blackmarket` folder into your server's `resources` directory.

3. **Update `server.cfg`**: Add the following line:

    ```plaintext
    start codex-blackmarket
    ```

4. **Configure the Script**: Edit `config.lua` to set the `WebhookURL` and NPC settings.

5. **Restart the Server**: Reload or restart your FiveM server.

## Usage

- **Buying Items**: Interact with NPCs to buy items using cash, bank, or black money. Discounts apply as configured.
- **Webhook Notifications**: Transaction details are sent to your Discord webhook.

## Configuration

- **NPC Coordinates**: Set NPC locations and settings in `config.lua`.
- **Item Definitions**: Define items, prices, and discounts in `config.lua`.
- **Webhook Settings**: Configure your Discord webhook URL in `config.lua`.


## Contributing

To contribute:
1. Fork the repository.
2. Create a new branch.
3. Submit a pull request with your changes.

## Support

For support:
- Open an issue on GitHub.
- Join our [Discord server](https://discord.gg/AWR2PjPQe8).

