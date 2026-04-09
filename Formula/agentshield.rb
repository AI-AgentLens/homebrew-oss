class Agentshield < Formula
  desc "Open-source runtime security gateway for AI coding agents"
  homepage "https://github.com/AI-AgentLens/agentshield-oss"
  url "https://github.com/AI-AgentLens/agentshield-oss.git", branch: "main"
  version "0.3.0"
  license "Apache-2.0"
  head "https://github.com/AI-AgentLens/agentshield-oss.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/AI-AgentLens/agentshield/internal/cli.Version=#{version}
      -X github.com/AI-AgentLens/agentshield/internal/cli.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/agentshield"

    # Install community packs to share directory
    (share/"agentshield/packs").install Dir["packs/community/*.yaml"]
    (share/"agentshield/packs/mcp").install Dir["packs/community/mcp/*.yaml"]
  end

  def caveats
    <<~EOS
      AgentShield OSS installed. Quick start:

        agentshield setup claude-code   # Claude Code
        agentshield setup cursor        # Cursor
        agentshield setup windsurf      # Windsurf

      Set up MCP proxy:
        agentshield setup mcp

      Premium rules (1,300+ curated rules, advanced detection):
        agentshield update
        # Requires license key — see https://aiagentlens.com
    EOS
  end

  test do
    # Verify binary runs
    assert_match "AgentShield", shell_output("#{bin}/agentshield --help")

    # Verify scan self-test works
    output = shell_output("#{bin}/agentshield scan 2>&1")
    assert_match "Shell Command Policy", output
  end
end
