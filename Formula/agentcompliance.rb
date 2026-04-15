class Agentcompliance < Formula
  desc "AI compliance scanner — detects AI security risks in codebases"
  homepage "https://aiagentlens.com"
  url "https://github.com/AI-AgentLens/AI_risk_compliance.git", tag: "v0.1.0-comply"
  version "0.1.0"
  license "Apache-2.0"
  head "https://github.com/AI-AgentLens/AI_risk_compliance.git", branch: "main"

  depends_on "go" => :build
  depends_on "semgrep"

  def install
    ldflags = %W[
      -s -w
      -X main.buildCommit=#{Utils.git_short_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"agentcompliance"), "./cmd/comply"
  end

  def caveats
    <<~EOS
      agentcompliance installed. To scan a project:

        agentshield login              # authenticate (required)
        agentcompliance scan .         # scan current directory

      Rules download automatically from AI Agent Lens on first scan.
      Taxonomy and compliance data are embedded in the binary.

      Requires agentshield for authentication:
        brew install agentshield
    EOS
  end

  test do
    assert_match "agentcompliance", shell_output("#{bin}/agentcompliance --help 2>&1")
  end
end
