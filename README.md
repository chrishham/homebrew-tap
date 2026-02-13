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

### Usage

```bash
# Run manually
netbridge-socks --relay wss://your-relay.example.com/tunnel

# Or as a background service (macOS & Linux)
# First, edit the config with your relay URL:
#   $(brew --prefix)/etc/netbridge/config
brew services start netbridge-socks
```

### Manage service

```bash
brew services start netbridge-socks    # Start
brew services stop netbridge-socks     # Stop
brew services restart netbridge-socks  # Restart
```

See the [NetBridge README](https://github.com/chrishham/netbridge) for full documentation.
