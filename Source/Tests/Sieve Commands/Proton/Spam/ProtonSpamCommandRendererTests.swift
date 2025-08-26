import Foundation
import Testing
@testable import Yasba

struct ProtonSpamCommandRendererTests {
    private let renderer = ProtonSpamCommandRenderer()

    @Test func render_spamCommand_withDefaultIndent() async throws {
        let command = ProtonSpamCommand()
        let output = renderer.render(command: command, atIndent: 0)

        let expected = """
if allof (
  environment :matches "vnd.proton.spam-threshold" "*",
  spamtest :value "ge" :comparator "i;ascii-numeric" "${1}"
) {
    return;
}
"""
        #expect(output == expected)
    }
}
