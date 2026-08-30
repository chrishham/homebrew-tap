class NetbridgeSocks < Formula
  desc "SOCKS5 and HTTP proxy client for NetBridge"
  homepage "https://github.com/chrishham/netbridge"
  url "https://github.com/chrishham/netbridge/archive/refs/tags/socks-v1.5.0.tar.gz"
  version "1.5.0"
  sha256 "5b0fa3b8f0869a0afd7f9761eda080292b5b26f3f86aa5495ccebef3bbbc8dd2"
  license "MIT"

  depends_on "uv"

  on_linux do
    depends_on "cairo"
    depends_on "gobject-introspection"
  end

  def install
    # Store uv-managed Python inside the formula prefix so it persists after build
    python_dir = libexec/"python"
    venv = libexec/"venv"

    ENV["UV_PYTHON_INSTALL_DIR"] = python_dir.to_s
    system "uv", "venv", venv, "--python", "3.14"

    # Inject the formula version into pyproject.toml (the source uses a placeholder)
    inreplace buildpath/"socks-proxy/pyproject.toml", /^version = .*$/, "version = \"#{version}\""

    # Install shared-auth first (local dependency)
    system "uv", "pip", "install", "--python", venv/"bin/python", buildpath/"shared"

    # Install socks-proxy
    system "uv", "pip", "install", "--python", venv/"bin/python", buildpath/"socks-proxy"

    # Fix the venv python symlink to point to the persisted location.
    # When uv downloads Python into python_dir, the symlink must be updated.
    # When uv uses an existing Python (e.g. Homebrew's python@3.14), skip this.
    python_bin = Dir.glob("#{python_dir}/cpython-*/bin/python3*").reject { |p| File.symlink?(p) }.first
    if python_bin
      (venv/"bin/python").unlink
      (venv/"bin/python").make_symlink(python_bin)
    end

    # Re-write the netbridge-socks shebang to use the correct python path
    inreplace venv/"bin/netbridge-socks", %r{#!.*}, "#!#{venv}/bin/python"

    # Create a wrapper script
    (bin/"netbridge-socks").write <<~BASH
      #!/bin/bash
      exec "#{venv}/bin/netbridge-socks" "$@"
    BASH
  end

  def caveats
    caveats_text = <<~EOS
      To use netbridge-socks, you need:
        1. Azure CLI installed and logged in (az login)
        2. Your relay URL (ask your team admin)

      Configure your relay URL:
        #{etc}/netbridge/config

      macOS — run as a service (tray icon appears automatically):
        brew services start netbridge-socks

      Linux — the tray icon needs your desktop session:
        Log out and back in (autostart entry was created), or run now:
        #{opt_libexec}/netbridge-socks-tray &
    EOS
    caveats_text
  end

  def post_install
    (etc/"netbridge").mkpath
    config = etc/"netbridge/config"
    unless config.exist?
      config.write <<~EOS
        # NetBridge relay hostname (required - just the hostname, e.g. relay.example.com)
        RELAY_URL=your-relay-host.example.com
      EOS
    end

    # Create wrapper that reads config before launching
    # Include Homebrew bin dirs in PATH so az CLI is discoverable under launchd
    # On macOS (launchd), tray works automatically; on Linux (systemd), use --no-tray
    (libexec/"netbridge-socks-service").delete if (libexec/"netbridge-socks-service").exist?
    (libexec/"netbridge-socks-service").write <<~BASH
      #!/bin/bash
      export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
      source "#{etc}/netbridge/config"
      TRAY_FLAG=""
      if [ "$(uname)" = "Linux" ]; then
        TRAY_FLAG="--no-tray"
      fi
      exec "#{libexec}/venv/bin/netbridge-socks" --relay "$RELAY_URL" $TRAY_FLAG
    BASH
    (libexec/"netbridge-socks-service").chmod 0755

    # On Linux, create a tray-enabled launcher (reads config, keeps tray)
    # Include system GI typelib paths so AppIndicator3 is discoverable
    (libexec/"netbridge-socks-tray").delete if (libexec/"netbridge-socks-tray").exist?
    (libexec/"netbridge-socks-tray").write <<~BASH
      #!/bin/bash
      export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
      export GI_TYPELIB_PATH="/usr/lib/girepository-1.0:/usr/lib/x86_64-linux-gnu/girepository-1.0:${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"
      source "#{etc}/netbridge/config"
      exec "#{libexec}/venv/bin/netbridge-socks" --relay "$RELAY_URL"
    BASH
    (libexec/"netbridge-socks-tray").chmod 0755

    # On Linux, create a .desktop autostart entry for tray mode
    if OS.linux?
      autostart_dir = Pathname.new(Dir.home)/".config/autostart"
      autostart_dir.mkpath
      desktop_file = autostart_dir/"netbridge-socks.desktop"
      unless desktop_file.exist?
        desktop_file.write <<~DESKTOP
          [Desktop Entry]
          Type=Application
          Name=NetBridge Socks
          Comment=SOCKS5/HTTP proxy with system tray
          Exec=#{libexec}/netbridge-socks-tray
          Hidden=false
          X-GNOME-Autostart-enabled=true
          StartupNotify=false
        DESKTOP
      end
    end
  end

  service do
    run [opt_libexec/"netbridge-socks-service"]
    keep_alive true
    log_path var/"log/netbridge-socks.log"
    error_log_path var/"log/netbridge-socks.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "SOCKS5", shell_output("#{bin}/netbridge-socks --help")
  end
end