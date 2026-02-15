class NetbridgeSocks < Formula
  desc "SOCKS5 and HTTP proxy client for NetBridge"
  homepage "https://github.com/chrishham/netbridge"
  url "https://github.com/chrishham/netbridge/archive/refs/tags/socks-v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "001d011ada03b5d683fc6bf1fb21f4e919425a5b649f3e859f18243d131573df"
  license "MIT"

  depends_on "uv"

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

    # Fix the venv python symlink to point to the persisted location
    python_bin = Dir.glob("#{python_dir}/cpython-*/bin/python3*").reject { |p| File.symlink?(p) }.first
    (venv/"bin/python").unlink
    (venv/"bin/python").make_symlink(python_bin)

    # Re-write the netbridge-socks shebang to use the correct python path
    inreplace venv/"bin/netbridge-socks", %r{#!.*}, "#!#{venv}/bin/python"

    # Create a wrapper script
    (bin/"netbridge-socks").write <<~BASH
      #!/bin/bash
      exec "#{venv}/bin/netbridge-socks" "$@"
    BASH
  end

  def caveats
    <<~EOS
      To use netbridge-socks, you need:
        1. Azure CLI installed and logged in (az login)
        2. Your relay URL (ask your team admin)

      Run manually:
        netbridge-socks --relay wss://your-relay.example.com/tunnel

      Or run as a service:
        1. Edit the config with your relay URL:
           #{etc}/netbridge/config

        2. Start the service:
           brew services start netbridge-socks
    EOS
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
    (libexec/"netbridge-socks-service").delete if (libexec/"netbridge-socks-service").exist?
    (libexec/"netbridge-socks-service").write <<~BASH
      #!/bin/bash
      source "#{etc}/netbridge/config"
      exec "#{libexec}/venv/bin/netbridge-socks" --relay "$RELAY_URL"
    BASH
    (libexec/"netbridge-socks-service").chmod 0755
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