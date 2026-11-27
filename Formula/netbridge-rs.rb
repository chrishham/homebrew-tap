require "download_strategy"
require "json"

# Downloads a release asset of a private GitHub repo through the API.
# Other URLs (e.g. file://) use the stock curl strategy.
class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  URL_RE = %r{\Ahttps://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/([^/]+)\z}

  def initialize(url, name, version, **meta)
    super
    @nb_match = URL_RE.match(url)
    check_token if @nb_match
  end

  private

  def check_token
    return unless ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?

    raise CurlDownloadStrategyError,
          "Set HOMEBREW_GITHUB_API_TOKEN (a token with read access to the repo) and retry."
  end

  def auth_header
    "Authorization: token #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN")}"
  end

  def asset_url
    owner, repo, tag, file = @nb_match.captures
    api = "https://api.github.com/repos/#{owner}/#{repo}"
    out, = curl_output("--header", auth_header, "--header", "Accept: application/vnd.github+json",
                       "#{api}/releases/tags/#{tag}")
    asset = JSON.parse(out).fetch("assets", []).find { |a| a["name"] == file }
    raise CurlDownloadStrategyError, "Release asset #{file} not found for tag #{tag}." unless asset

    "#{api}/releases/assets/#{asset["id"]}"
  end

  def _fetch(url:, resolved_url:, timeout:)
    return super unless @nb_match

    curl_download asset_url, "--header", "Accept: application/octet-stream", "--header", auth_header,
                  to: temporary_path, timeout: timeout
  end
end

class NetbridgeRs < Formula
  desc "SOCKS5-over-WebSocket tunnel: laptop app with tray icon"
  homepage "https://github.com/chrishham/netbridge-rs"
  url "https://github.com/chrishham/netbridge-rs/releases/download/v0.3.0/nb-v0.3.0-linux-x86_64.tar.gz", using: GitHubPrivateReleaseDownloadStrategy
  version "0.3.0"
  sha256 "d5a91c1c26fb1627787af724243e13edebefa07fc9c348509e420864128d556d"

  depends_on :linux

  def install
    bin.install "nb"
  end

  def caveats
    <<~EOS
      Install and upgrade need HOMEBREW_GITHUB_API_TOKEN exported (read access to the repo).
      The tray needs the system packages libgtk-3-0 and libayatana-appindicator3-1
      (present on Mint/Ubuntu desktops).

      First run:
        nb setup
        nb firefox setup

      Start at login while netbridge-socks still runs:
        nb autostart on --socks 127.0.0.1:1081 --http 127.0.0.1:3129
      After netbridge-socks is gone:
        nb autostart on

      Upgrade with: brew upgrade netbridge-rs
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nb --version")
  end
end
