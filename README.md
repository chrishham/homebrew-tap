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
netbridge-socks --relay your-relay-host.example.com

# Or as a background service (macOS & Linux)
# First, edit the config with your relay URL:
nano $(brew --prefix)/etc/netbridge/config
brew services start netbridge-socks
```

### Manage service

```bash
brew services info netbridge-socks     # Show service status
brew services start netbridge-socks    # Start (auto-starts at boot)
brew services run netbridge-socks      # Start (current session only)
brew services stop netbridge-socks     # Stop
brew services restart netbridge-socks  # Restart
netbridge-socks --version              # Show installed version
```

### Changing the Relay URL

Edit the config file and restart the service:

```bash
nano $(brew --prefix)/etc/netbridge/config
brew services restart netbridge-socks
```

### Upgrading

```bash
brew update
brew upgrade netbridge-socks
brew services restart netbridge-socks
```

### Logs

```bash
tail -f $(brew --prefix)/var/log/netbridge-socks.log
```

See the [NetBridge README](https://github.com/chrishham/netbridge) for full documentation.