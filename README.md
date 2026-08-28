# Homebrew Tap

Custom Homebrew formulae by [@chrishham](https://github.com/chrishham).

## Setup

```bash
brew tap chrishham/tap
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| `netbridge-socks` | SOCKS5 and HTTP proxy client for [NetBridge](https://github.com/chrishham/netbridge) VDI tunnel |

## netbridge-socks

SOCKS5 and HTTP proxy client that tunnels connections through a VDI relay, allowing access to internal corporate resources from your laptop.

### Install

```bash
brew install netbridge-socks
```

### Two ways to run

| Mode | How | Tray icon? | Best for |
|------|-----|------------|----------|
| **Desktop (tray)** | Launch "NetBridge Socks" from app menu | Yes | Daily desktop use |
| **Headless service** | `brew services start netbridge-socks` | No | Servers, SSH sessions |

Pick one — don't run both at the same time.

### Desktop mode (recommended for laptops)

The tray app starts automatically on login. You can also launch it from the application menu ("NetBridge Socks") or manually:

```bash
$(brew --prefix netbridge-socks)/libexec/netbridge-socks-tray &
```

The tray icon shows live connection status:
- 🟢 Connected
- 🟡 Connecting / Reconnecting
- 🔴 Disconnected
- 🟠 Authentication expired

Right-click the tray icon for:
- **Reconnect** — restart the proxy connection without relaunching
- **Change Relay URL** — update and save the relay, then relaunch
- **Login (az login)** — open a terminal for Azure re-authentication
- **View Logs** — open the log file

Configuration is saved to:
- macOS: `~/Library/Application Support/netbridge-socks/config.json`
- Linux: `~/.config/netbridge-socks/config.json`

### Headless service mode

```bash
# First, edit the config with your relay URL:
nano $(brew --prefix)/etc/netbridge/config
brew services start netbridge-socks
```

#### Manage service

```bash
brew services info netbridge-socks     # Show service status
brew services start netbridge-socks    # Start (auto-starts at boot)
brew services run netbridge-socks      # Start (current session only)
brew services stop netbridge-socks     # Stop
brew services restart netbridge-socks  # Restart
```

#### Changing the Relay URL (headless)

```bash
nano $(brew --prefix)/etc/netbridge/config
brew services restart netbridge-socks
```

### Upgrading

```bash
brew update
brew upgrade netbridge-socks
```

### Logs

```bash
# Tray mode
# macOS:
tail -f ~/Library/Logs/netbridge-socks.log
# Linux:
tail -f ~/.local/state/netbridge-socks/netbridge-socks.log

# Headless service mode
tail -f $(brew --prefix)/var/log/netbridge-socks.log
```

### Version

```bash
netbridge-socks --version
```

See the [NetBridge README](https://github.com/chrishham/netbridge) for full documentation.
